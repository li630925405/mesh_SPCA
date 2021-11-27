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

def anthro_train():
    out_dir = '../output_data/coeff_predict/anthro/' + database
    pc_l = scio.loadmat('../output_data/hrtf_spca/' + database + '/pc_l.mat')['pc_l'][:, 0:200, :]  # (480, 200, 4)

    # mesh coeff of train data and test data
    anthro_train = scio.loadmat('../../database/chedar/anthro.mat')['anthro']
    anthro_train = np.delete(anthro_train, 2, axis=1)

    train_num = 30  # 训练集
    valid_num = 5
    total_train_num = 35
    num = 200

    server = 0

    his = list(range(0, N // 2 + 1))

    for fn in range(0, 180):
        print(str(str(fn + 1) + ' start'))
        p_l = np.transpose(pc_l[fn, :, :].reshape(num, S))  # 取出第fn个频点的那组系数 200 * 74

        p_l_train = p_l[0:total_train_num, :]
        p_l_test = p_l[total_train_num:S, :]

        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_train_ori_l.mat', {'p_l_train': p_l_train})
        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_test_ori_l.mat', {'p_l_test': p_l_test})

        # 输入也是只有左耳，输出也是只有左耳

        # Input data
        train_in = anthro_train[0:total_train_num, :]
        train_out = p_l_train
        test_in = anthro_train[total_train_num:S, :]

        # print(train_in)
        # print(train_out)
        # print("11111111")

        # train NN

        # normalize
        def zscore(x, axis=None):
            xmean = x.mean(axis=axis, keepdims=True)
            xstd = np.std(x, axis=axis, keepdims=True)
            zscore = (x - xmean) / xstd
            return zscore, xmean, xstd

        train_in, mu_in, sigma_in = zscore(train_in, axis=0)
        test_in = functions.normalize(test_in, mu_in, sigma_in)
        train_out, mu_out, sigma_out = zscore(train_out, axis=0)

        # print(train_in)
        # print(train_out)
        # print("222222222")

        # nn setup
        # R = sample(range(0, total_train_num), total_train_num)
        # 这就没随机化的必要了吧
        optimizer = keras.optimizers.SGD(learning_rate=0.1, momentum=0.7)
        reg = tf.keras.regularizers.l2(0.02)
        nn = tf.keras.models.Sequential([
            tf.keras.layers.Dense(20, activation='tanh', input_shape=[7]),
            # tf.keras.layers.Dense(100, activation='tanh', kernel_regularizer=reg),
            # tf.keras.layers.Dense(100, activation='tanh', kernel_regularizer=reg),
            tf.keras.layers.Dense(27, activation='tanh', kernel_regularizer=reg),
            tf.keras.layers.Dense(5, activation='tanh', kernel_regularizer=reg),
            tf.keras.layers.Dense(num),
        ])

        # if os.path.isfile('./lyz_nnParameters/%d.data-00000-of-00001' %(fn+1)) and os.path.isfile('./lyz_nnParameters/%d.index' %(fn+1)):
        if 0 and os.path.isfile('./nnParameters_anthro/%d.index' % (fn + 1)):
            print('Load trained network')
            nn.load_weights('./nnParameters_anthro/' + str(fn + 1))
        else:
            print('Neural network parameters not found, Subject num %d' % (fn + 1))
            print('Begin training')
            early_stop = keras.callbacks.EarlyStopping(monitor='val_mse', min_delta=0.001, patience=20)
            nn.compile(loss='mse',
                       optimizer=optimizer,
                       metrics=['mse'])
            his[fn] = nn.fit(
                train_in[0:train_num, :], train_out[0:train_num, :],
                batch_size=10,
                epochs=500, verbose=1,
                validation_data=(train_in[:train_num, :], train_out[:train_num, :]),
                callbacks=[]
            )
            nn.save_weights('./nnParameters_anthro/' + str(fn + 1))
            print('Subject %d ends training, network saved at ./nnParameters_anthro' % (fn + 1))
            # print("fn: ", fn)
            # print(his)

        print('------------------------------')
        # predict and save output
        train_out = nn.predict(train_in)
        test_out = nn.predict(test_in)

        # print(train_out)
        # print("3333333")

        train_out = train_out * repmat(sigma_out, train_out.shape[0], 1) + repmat(mu_out, train_out.shape[0], 1)
        test_out = test_out * repmat(sigma_out, test_out.shape[0], 1) + repmat(mu_out, test_out.shape[0], 1)
        # print(train_out)
        # print("4444444")

        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_train_out_l.mat', {'train_out': train_out})
        scio.savemat(out_dir + '/coeff_f' + str(fn + 1) + '_test_out_l.mat', {'test_out': test_out})

    return his


if __name__ == '__main__':
    his = anthro_train()

    if server == 0:
        # plot validation error
        plt.figure(figsize=(8, 6))
        plt.title('validation MSE over epoches on frequency point 0')
        # print(his)

        hist0 = pd.DataFrame(his[0].history)
        plt.plot(np.linspace(0, hist0['val_mse'].size, hist0['val_mse'].size),
                 hist0['val_mse'], color='b', label="0")
        plt.legend()
        # plt.savefig('./images/validation_after_training.jpg')
        plt.show()
