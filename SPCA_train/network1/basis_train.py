# data processing
import scipy.io as scio
import numpy as np
import numpy.matlib
from numpy.matlib import repmat
import functions
import tensorflow as tf
from tensorflow import keras
import os
import matplotlib.pyplot as plt
import pandas as pd
import math
import sys
sys.path.append("..")
from variables import *


def train_basis():
# if __name__ == '__main__':
    coeff_path = '../output_data/hrtf_spca/' + database + '/coeff_l.mat'
    dir_path = '../input_data/' + database + '/dir.mat'

    coeff_l = scio.loadmat(coeff_path)['coeff_l'].transpose()[:, 0:200]  # (2522, 200)
    dir = scio.loadmat(dir_path)['dir'][:, 0:2]

    if database == "chedar":
        dir = np.delete(dir, 70, axis=0)  # (0, 0)
        dir = np.delete(dir, 281, axis=0)  # (180, 0)

    cartesian = np.ones((M, 3))
    for i in range(len(dir)):
        theta = math.radians(dir[i][0])
        phi = math.radians(dir[i][1])
        cartesian[i][0] = math.cos(phi) * math.cos(theta)
        cartesian[i][1] = math.cos(phi) * math.sin(theta)
        cartesian[i][2] = math.sin(phi)

    input = cartesian
    # input = dir

    # concatenate all processed data together
    output = np.concatenate([coeff_l])

    totalSet = list(range(0, M))
    testSet = list(range(0, M, 4))
    dataSet = [i for i in totalSet if i not in testSet]
    trainSet = dataSet[1:len(dataSet):5] + dataSet[2:len(dataSet):5] + dataSet[3:len(dataSet):5] + dataSet[4:len(dataSet):5]
    validSet = dataSet[0:len(dataSet):5]
    test_num = len(testSet)
    other_num = len(validSet) + len(trainSet)
    train_num = len(trainSet)

    # split traing and testing dataset according to calculated index.
    train_in = input[trainSet + validSet, :]
    test_in = input[testSet, :]

    basis_train_ori = output[trainSet + validSet, :]
    basis_test_ori = output[testSet, :]

    scio.savemat('../output_data/hrtf_predict/' + database + '/basis_test_ori.mat', {'basis_test_ori': basis_test_ori})
    scio.savemat('../output_data/hrtf_predict/' + database + '/basis_train_ori.mat', {'basis_train_ori': basis_train_ori})

    # normalize
    def zscore(x, axis=None):
        xmean = x.mean(axis=axis, keepdims=True)
        xstd = np.std(x, axis=axis, keepdims=True)
        zscore = (x-xmean)/xstd
        return zscore, xmean, xstd

    train_in, mu, sigma = zscore(train_in, axis=0)
    test_in = functions.normalize(test_in, mu, sigma)
    basis_train_ori, mu_out, sigma_out = zscore(basis_train_ori, axis=0)
    basis_test_ori = functions.normalize(basis_test_ori, mu_out, sigma_out)

    print("data ready")

    # Set up front nn and back nn
    lr_schedule = keras.optimizers.schedules.ExponentialDecay(
            initial_learning_rate=0.1,
            decay_steps=2000,
            decay_rate=0.9)
    optimizer = keras.optimizers.SGD(learning_rate=0.01, momentum=0.7)
    # optimizer = keras.optimizers.SGD(learning_rate=lr_schedule, momentum=0.7)
    nn = tf.keras.models.Sequential([
      tf.keras.layers.Dense(202, activation='tanh', input_shape=[3]),
      tf.keras.layers.Dense(180, activation='tanh'),
      tf.keras.layers.Dense(180, activation='tanh'),
      tf.keras.layers.Dense(180, activation='tanh'),
      tf.keras.layers.Dense(200)
    ])

    nn.compile(loss='mse',
                    optimizer=optimizer,
                    metrics=['mse'])

    early_stop = keras.callbacks.EarlyStopping(monitor='val_mse', min_delta=0.002, patience=50)

    # fit NNs
    print("begin training")
    # lyz: 只有weight能save, history不能save吗
    if 0 and os.path.isfile('./nnParameters/back.index') and os.path.isfile('./nnParameters/front.index'):
        nn.load_weights('./nnParameters/' + database)
    else:
        history = nn.fit(
          train_in[:train_num], basis_train_ori[:train_num],
          batch_size=10,
          epochs=5000, verbose=1,
          validation_data=(train_in[train_num:], basis_train_ori[train_num:]),
          callbacks=[]
        )

        nn.save_weights('./nnParameters/' + database)

    # visualization of val mse over epoches
    hist_f = pd.DataFrame(history.history)

    hist_f['epoch'] = history.epoch

    # plot validation error
    plt.figure(figsize=(8, 6))
    plt.title('validation MSE over epoches on front NN and back NN')
    plt.plot(np.linspace(0, hist_f['val_mse'].size, hist_f['val_mse'].size),
             hist_f['val_mse'], color='b', label="Front")
    plt.legend()
    plt.savefig('./images/validation_after_training.jpg')
    plt.show()

    # save predicted data
    basis_test = nn.predict(test_in)
    basis_train = nn.predict(train_in)

    basis_test = basis_test * repmat(sigma_out, test_num, 1) + repmat(mu_out, test_num, 1)
    basis_train = basis_train * repmat(sigma_out, other_num, 1) + repmat(mu_out, other_num, 1)

    scio.savemat('../output_data/hrtf_predict/' + database + '/basis_test.mat', {'basis_test': basis_test})
    scio.savemat('../output_data/hrtf_predict/' + database + '/basis_train.mat', {'basis_train': basis_train})


if __name__ == "__main__":
    train_basis()
