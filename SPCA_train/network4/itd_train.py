import os
import scipy.io as scio
import numpy as np
import functions
from random import sample as sample
import tensorflow as tf
from tensorflow import keras
from numpy.matlib import repmat
import matplotlib.pyplot as plt
import pandas as pd
import math
import sys
sys.path.append("..")
from variables import *
np.set_printoptions(threshold=sys.maxsize)

M = 2522

dir_path = '../../' + database + '/dir.mat'

# Run this cell for Data loading and processing
itd = scio.loadmat('../output_data/hrtf_spca/' + database + '_hrtf/itd.mat')['itd']
print(itd.shape)
itd = np.transpose(itd)
dir = scio.loadmat(dir_path)['dir'][:, 0:2]
print(dir.shape)

cartesian = np.ones((M, 3))
for i in range(len(dir)):
    theta = math.radians(dir[i][0])
    phi = math.radians(dir[i][1])
    cartesian[i][0] = math.cos(phi)*math.cos(theta)
    cartesian[i][1] = math.cos(phi)*math.sin(theta)
    cartesian[i][2] = math.sin(phi)

input = cartesian
output = np.array(itd)

totalSet = list(range(0, M))
testSet = list(range(0, M, 4))
dataSet = [i for i in totalSet if i not in testSet]
trainSet = dataSet[1:len(dataSet):5] + dataSet[2:len(dataSet):5] + dataSet[3:len(dataSet):5] + dataSet[4:len(dataSet):5]
validSet = dataSet[1:len(dataSet):5]
test_num = len(testSet)
other_num = len(validSet) + len(trainSet)

# split traing and testing dataset according to calculated index.
train_in = input[trainSet + validSet, :]
test_in = input[testSet, :]

itd_train_ori = output[trainSet + validSet, :]
itd_test_ori = output[testSet, :]

scio.savemat('../output_data/hrtf_predict/' + database + '/itd_test_ori.mat', {'itd_test_ori': itd_test_ori})
scio.savemat('../output_data/hrtf_predict/' + database + '/itd_train_ori.mat', {'itd_train_ori': itd_train_ori})

# normalize
def zscore(x, axis=None):
    xmean = x.mean(axis=axis, keepdims=True)
    xstd = np.std(x, axis=axis, keepdims=True)
    zscore = (x - xmean) / xstd
    return zscore, xmean, xstd


train_in, mu, sigma = zscore(train_in, axis=0)
test_in = functions.normalize(test_in, mu, sigma)
itd_train_ori, mu_out, sigma_out = zscore(itd_train_ori, axis=0)
itd_test_ori = functions.normalize(itd_test_ori, mu_out, sigma_out)


# Run this cell to training Nerual Network & saving network parameters
"""
reTrain: retrain flag
0: load trained network
1: train the network again.
"""
reTrain = 1

# Set model
optimizer = keras.optimizers.SGD(lr=0.01, momentum=0.9)
def tanh_opt(x, beta=1.0):
    return 1.7159*tanh(2/3 * x)

reg = tf.keras.regularizers.l2(0.01)
nn = tf.keras.models.Sequential([
  tf.keras.layers.InputLayer(input_shape=[3]),
  tf.keras.layers.Lambda(lambda x: x*2/3),
  tf.keras.layers.Dense(180, activation='tanh',kernel_regularizer=reg),
  tf.keras.layers.Lambda(lambda x: x*1.1759),
  tf.keras.layers.Lambda(lambda x: x*2/3),
  tf.keras.layers.Dense(120, activation='tanh',kernel_regularizer=reg),
  tf.keras.layers.Lambda(lambda x: x*1.1759),
  tf.keras.layers.Lambda(lambda x: x*2/3),
  tf.keras.layers.Dense(180, activation='tanh',kernel_regularizer=reg),
  tf.keras.layers.Lambda(lambda x: x*1.1759),
  tf.keras.layers.Lambda(lambda x: x*2/3),
  tf.keras.layers.Dense(1)
])
nn.compile(loss='mse',
                optimizer=optimizer,
                metrics=[ 'mse'])


if reTrain == 0:
    # NN data saved at ./nnParameters
    nn.load_weights('./nnParameters/front')
elif reTrain == 1:
    print("------train front----------")
    history = nn.fit(
      train_in[:M//5*3], itd_train_ori[:M//5*3],
      batch_size=10,
      epochs=50, verbose=1,
      validation_data=(train_in[M//5*3:], itd_train_ori[M//5*3:]),
      callbacks=[]
    )

    nn.save_weights('./nnParameters/front')

# ## Training Outcome

hist_f = pd.DataFrame(history.history)
hist_f['epoch'] = history.epoch

# plot validation error
plt.figure(figsize=(8, 6))
plt.title('validation MSE over epoches on front NN and back NN')
plt.plot(np.linspace(0, hist_f['val_mean_squared_error'].size, hist_f['val_mean_squared_error'].size), hist_f['val_mean_squared_error'], color='b', label="Front")
plt.legend()
plt.show()

# test set MSE of tensorflow nn
# print(test_in_front)
nn.evaluate(test_in, itd_test_ori)

# visualization of front output
y1 = nn.predict(test_in)
x = np.linspace(0, y1.size, y1.size)
y2 = itd_test_ori
plt.figure(figsize=(8, 6))
plt.xlabel('Spatial Direction', fontsize=12)
plt.ylabel('normed itd', fontsize=12)
plt.title('test output of NN vs. expect value', fontsize=12)
plt.plot(x, y1, color='r', label='NN output')
plt.plot(x, y2, color='b', label='Expect value')
plt.legend(fontsize=10)
plt.show()


# save predictions
itd_test = nn.predict(test_in)
itd_train = nn.predict(train_in)

itd_test = itd_test * repmat(sigma_out, test_num, 1) + repmat(mu_out, test_num, 1)
itd_train = itd_train * repmat(sigma_out, other_num, 1) + repmat(mu_out, other_num, 1)

scio.savemat('../output_data/hrtf_predict/' + database + '/itd_test.mat', {'itd_test': itd_test})
scio.savemat('../output_data/hrtf_predict/' + database + '/itd_train.mat', {'itd_train': itd_train})


y1 = nn.predict(train_in)
x = np.linspace(0, y1.size, y1.size)
y2 = itd_train_ori
plt.figure(figsize=(8, 6))
plt.xlabel('Spatial Direction', fontsize=12)
plt.ylabel('normed itd', fontsize=12)
plt.title('train output of NN vs. expect value (train)', fontsize=12)
plt.plot(x, y1, color='r', label='NN output')
plt.plot(x, y2, color='b', label='Expect value')
plt.legend(fontsize=10)
plt.show()
