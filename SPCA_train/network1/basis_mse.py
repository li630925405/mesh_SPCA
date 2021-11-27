# coding: utf-8
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append("..")
from variables import *


def plot_compare():
    basis_train = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train.mat')['basis_train']
    basis_train = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train.mat')['basis_train']  # (313, 200) 313:train_num
    basis_train_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train_ori.mat')['basis_train_ori']
    basis_train_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train_ori.mat')['basis_train_ori']

    length = basis_train.shape[1]
    train_e = sum(abs(basis_train - basis_train_ori)) / sum(abs(basis_train))

    xx = np.linspace(0, length, length)
    plt.figure(figsize=(16, 12))
    plt.title('SPC mse change with fn', fontsize=12)
    plt.xlabel('f', fontsize=12)
    plt.ylabel('SPC mse', fontsize=12)
    plt.plot(xx, train_e)
    plt.legend(fontsize=12)
    plt.show()

    p_num = 1
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    print("x shape: ", x.shape)
    print("y1 shape: ", y1.shape)
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()

    p_num = 2
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()

    p_num = 5
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    print("x shape: ", x.shape)
    print("y1 shape: ", y1.shape)
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()

    p_num = 10
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()

    p_num = 20
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()

    p_num = 100
    y1 = basis_train[:, p_num - 1]
    x = np.linspace(0, y1.size, y1.size)
    y2 = basis_train_ori[:, p_num - 1]
    plt.figure(figsize=(8, 6))
    plt.xlabel('Spatial Direction', fontsize=12)
    plt.ylabel('SPC', fontsize=12)
    plt.title('output of NN vs. expect value(back) pn = %d' % p_num, fontsize=12)
    plt.plot(x, y1, color='r', label='NN output')
    plt.plot(x, y2, color='b', label='Expect value')
    plt.legend(fontsize=12)
    plt.show()


if __name__ == "__main__":
    plot_compare()
