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

dir_path = '../input_data/' + database + '/dir.mat'

# Run this cell for Data loading and processing
hav_l = scio.loadmat('../output_data/hrtf_spca/' + database + '/hav_l.mat')['hav_l']
hav_l = np.transpose(hav_l)
dir = scio.loadmat(dir_path)['dir'][:, 0:2]

if database == "chedar":
    dir = np.delete(dir, 70, axis=0)  # (0, 0)
    dir = np.delete(dir, 281, axis=0)  # (180, 0)

cartesian = np.ones((M, 3))
for i in range(len(dir)):
    theta = math.radians(dir[i][0])
    phi = math.radians(dir[i][1])
    cartesian[i][0] = math.cos(phi)*math.cos(theta)
    cartesian[i][1] = math.cos(phi)*math.sin(theta)
    cartesian[i][2] = math.sin(phi)

input = cartesian
output = np.array(hav_l)

totalSet = list(range(0, M))
testSet = list(range(0, M, 4))
dataSet = [i for i in totalSet if i not in testSet]
trainSet = dataSet[1:len(dataSet):5] + dataSet[2:len(dataSet):5] + dataSet[3:len(dataSet):5] + dataSet[4:len(dataSet):5]
validSet = dataSet[0:len(dataSet):5]
test_num = len(testSet)
train_num = len(trainSet)
other_num = len(validSet) + len(trainSet)

# split traing and testing dataset according to calculated index.
train_in = input[trainSet + validSet, :]
test_in = input[testSet, :]

hav_train_ori = output[trainSet + validSet, :]
hav_test_ori = output[testSet, :]

scio.savemat('../output_data/hrtf_predict/' + database + '/hav_training_data.mat', {'train_in': train_in})
scio.savemat('../output_data/hrtf_predict/' + database + '/hav_training_data.mat', {'test_in': test_in})

scio.savemat('../output_data/hrtf_predict/' + database + '/hav_test_ori.mat', {'hav_test_ori': hav_test_ori})
scio.savemat('../output_data/hrtf_predict/' + database + '/hav_train_ori.mat', {'hav_train_ori': hav_train_ori})


# normalize
def zscore(x, axis=None):
    xmean = x.mean(axis=axis, keepdims=True)
    xstd = np.std(x, axis=axis, keepdims=True)
    zscore = (x - xmean) / xstd
    return zscore, xmean, xstd


train_in, mu, sigma = zscore(train_in, axis=0)
test_in = functions.normalize(test_in, mu, sigma)
hav_train_ori, mu_out, sigma_out = zscore(hav_train_ori, axis=0)
hav_test_ori = functions.normalize(hav_test_ori, mu_out, sigma_out)


# Run this cell to training Nerual Network & saving network parameters
"""
reTrain: retrain flag
0: load trained network
1: train the network again.
"""
reTrain = 1

# Set model
optimizer = keras.optimizers.SGD(learning_rate=0.01, momentum=0.9)
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
  # tf.keras.layers.Dense(180, activation='tanh',kernel_regularizer=reg),
  # tf.keras.layers.Lambda(lambda x: x*1.1759),
  # tf.keras.layers.Lambda(lambda x: x*2/3),
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
      train_in[:train_num], hav_train_ori[:train_num],
      batch_size=10,
      epochs=200, verbose=1,
      validation_data=(train_in[train_num:], hav_train_ori[train_num:]),
      callbacks=[]
    )

    nn.save_weights('./nnParameters/front')

# ## Training Outcome

hist_f = pd.DataFrame(history.history)
hist_f['epoch'] = history.epoch

# plot validation error
plt.figure(figsize=(8, 6))
plt.title('validation MSE over epoches on front NN and back NN')
plt.plot(np.linspace(0, hist_f['val_mse'].size, hist_f['val_mse'].size), hist_f['val_mse'], color='b', label="Front")
plt.legend()
plt.show()

# test set MSE of tensorflow nn
# print(test_in_front)
nn.evaluate(test_in, hav_test_ori)

# visualization of front output
y1 = nn.predict(test_in)
x = np.linspace(0, y1.size, y1.size)
y2 = hav_test_ori
plt.figure(figsize=(8, 6))
plt.xlabel('Spatial Direction', fontsize=12)
plt.ylabel('normed hav', fontsize=12)
plt.title('test output of NN vs. expect value', fontsize=12)
plt.plot(x, y1, color='r', label='NN output')
plt.plot(x, y2, color='b', label='Expect value')
plt.legend(fontsize=10)
plt.show()


# ## Save Predictions

# save predictions
hav_test = nn.predict(test_in)
hav_train = nn.predict(train_in)

hav_test = hav_test * repmat(sigma_out, test_num, 1) + repmat(mu_out, test_num, 1)
hav_train = hav_train * repmat(sigma_out, other_num, 1) + repmat(mu_out, other_num, 1)

scio.savemat('../output_data/hrtf_predict/' + database + '/hav_test.mat', {'hav_test': hav_test})
scio.savemat('../output_data/hrtf_predict/' + database + '/hav_train.mat', {'hav_train': hav_train})


y1 = nn.predict(train_in)
x = np.linspace(0, y1.size, y1.size)
y2 = hav_train_ori
plt.figure(figsize=(8, 6))
plt.xlabel('Spatial Direction', fontsize=12)
plt.ylabel('normed hav', fontsize=12)
plt.title('train output of NN vs. expect value (train)', fontsize=12)
plt.plot(x, y1, color='r', label='NN output')
plt.plot(x, y2, color='b', label='Expect value')
plt.legend(fontsize=10)
plt.show()
