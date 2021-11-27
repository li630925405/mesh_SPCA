import scipy.io as scio
from numpy.matlib import repmat
import numpy as np
import functions
import tensorflow as tf
from random import sample as sample
from tensorflow import keras
import os
import matplotlib.pyplot as plt
import pandas as pd
import sys
sys.path.append("..")
from variables import *

server = 0
num = 200

def mesh_train():
    out_dir = '../output_data/coeff_predict/mesh/' + database
    pc_l = scio.loadmat('../output_data/hrtf_spca/' + database + '/pc_l.mat')['pc_l'][:, 0:num, :]  # (480, 200, 4)
    mesh_train = scio.loadmat('../output_data/mesh/' + database + '/mesh_coeff.mat')['coeff'][:, 0:mesh_num]  # (45, num*3)

    his = list(range(0, N // 2 + 1))

    for fn in range(0, N//2+1):
        print(str(str(fn + 1) + ' start'))
        p_l = np.transpose(pc_l[fn, :, :].reshape(num, S))  # 取出第fn个频点的那组系数 200 * 74

        p_l_train = p_l[0:total_train_num, :]
        p_l_test = p_l[total_train_num:S, :]

        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_train_ori_l.mat', {'p_l_train': p_l_train})
        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_test_ori_l.mat', {'p_l_test': p_l_test})

        # Input data
        train_in = mesh_train[0:total_train_num]
        test_in = mesh_train[total_train_num:S]
        train_out = p_l_train

        # train NN
        # normalize
        def zscore(x, axis=None):
            xmean = x.mean(axis=axis, keepdims=True)
            xstd = np.std(x, axis=axis, keepdims=True)
            zscore = (x - xmean) / xstd
            return zscore, xmean, xstd

        # print(train_in)
        # print(train_out)
        # print("11111")

        train_in, mu_in, sigma_in = zscore(train_in, axis=0)
        test_in = functions.normalize(test_in, mu_in, sigma_in)
        train_out, mu_out, sigma_out = zscore(train_out, axis=0)


        # print(train_in)
        # print(train_out)
        # print("2222")

        # nn setup
        # R = sample(range(0, total_train_num), total_train_num)
        # 这就没随机化的必要了吧
        optimizer = keras.optimizers.SGD(learning_rate=0.1, momentum=0.7)
        # optimizer = keras.optimizers.SGD(lr=0.1, momentum=0.7)
        # reg = tf.keras.regularizers.l2(0.02)
        reg = tf.keras.regularizers.l2(0.001)
        nn = tf.keras.models.Sequential([
            tf.keras.layers.Dense(20, activation='tanh', input_shape=[mesh_num]),
            # 有没有这些隐层好像没区别。。
            # tf.keras.layers.Dense(100, activation='tanh', kernel_regularizer=reg),
            # tf.keras.layers.Dense(100, activation='tanh', kernel_regularizer=reg),  #
            # tf.keras.layers.Dense(100, activation='tanh', kernel_regularizer=reg),
            # tf.keras.layers.Dense(27, activation='tanh', kernel_regularizer=reg),
            # tf.keras.layers.Dense(27, activation='tanh', kernel_regularizer=reg),
            tf.keras.layers.Dense(20, activation='tanh', kernel_regularizer=reg),
            tf.keras.layers.Dense(num),
        ])

        # if os.path.isfile('./lyz_nnParameters/%d.data-00000-of-00001' %(fn+1)) and os.path.isfile('./lyz_nnParameters/%d.index' %(fn+1)):
        if 0 and os.path.isfile('./nnParameters_mesh/%d.index' % (fn + 1)):
            print('Load trained network')
            nn.load_weights('./nnParameters_mesh/' + str(fn + 1))
        else:
            print('Neural network parameters not found, Subject num %d' % (fn + 1))
            print('Begin training')
            early_stop = keras.callbacks.EarlyStopping(monitor='val_mse', min_delta=0.001, patience=20)
            nn.compile(loss='mse',
                       optimizer=optimizer,
                       metrics=['mse'])
            his[fn] = nn.fit(
                train_in[0:train_num], train_out[0:train_num],
                batch_size=10,
                epochs=500, verbose=1,
                # validation_data=(train_in[train_num:], train_out[train_num:]),
                # 看到底是没收敛还是过拟合
                validation_data=(train_in[:train_num], train_out[:train_num]),
                callbacks=[]
            )
            nn.save_weights('./nnParameters_mesh/' + str(fn + 1))
            print('Subject %d ends training, network saved at ./nnParameters' % (fn + 1))

        # predict and save output
        train_out = nn.predict(train_in)
        test_out = nn.predict(test_in)

        # print(train_out)
        # print("-----")

        # train_out = train_out * repmat(sigma_out, train_out.shape[0], train_out.shape[1]) + repmat(mu_out, train_out.shape[0], train_out.shape[1])
        # test_out = test_out * repmat(sigma_out, test_out.shape[0], test_out.shape[1]) + repmat(mu_out, test_out.shape[0], test_out.shape[1])
        train_out = train_out * repmat(sigma_out, train_out.shape[0], 1) + repmat(mu_out, train_out.shape[0], 1)
        test_out = test_out * repmat(sigma_out, test_out.shape[0], 1) + repmat(mu_out, test_out.shape[0], 1)

        # print(train_out)
        # print("3333")

        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_train_out_l.mat', {'train_out': train_out})
        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_test_out_l.mat', {'test_out': test_out})

        # input()

    return his


if __name__ == '__main__':
    his = mesh_train()
    if server == 0:
        plt.figure(figsize=(8, 6))
        plt.title('validation MSE over epoches on frequency point 0')

        # print(his[0])
        hist0 = pd.DataFrame(his[0].history)
        # hist1 = pd.DataFrame(his[0].history)
        plt.plot(np.linspace(0, hist0['val_mse'].size, hist0['val_mse'].size),
                 hist0['val_mse'], color='b', label="100")
        # plt.plot(np.linspace(0, hist0['val_mean_squared_error'].size, hist0['val_mean_squared_error'].size),
        #          hist0['val_mean_squared_error'], color='b', label="100")
        # plt.plot(np.linspace(0, hist1['val_mse'].size, hist1['val_mse'].size),
        #          hist1['val_mse'], color='b', label="0")
        plt.legend()
        plt.show()
