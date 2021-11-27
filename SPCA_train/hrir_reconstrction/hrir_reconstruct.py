import scipy.io as scio
import numpy as np
from numpy.matlib import repmat
from scipy.fftpack import hilbert
import os
import sys
sys.path.append("..")
from variables import *

# load data

if database == 'chedar':
    M = 630  # only train set
    N = 180  # 只取180个 因为后面的几乎都为0
elif database == 'hutubs':
    M = 330
    N = 128
S = total_train_num

type = input("mesh or anthro: ")

basis_train = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train.mat')['basis_train']  # (630, 200)
hav_train = scio.loadmat('../output_data/hrtf_predict/' + database + '/hav_train.mat')['hav_train']
hav_train = hav_train.reshape(hav_train.shape[0])  # (630, 1) --> 630
total_l = scio.loadmat('../output_data/hrtf_spca/' + database + '/total_l.mat')['total_l']
total_l = total_l.reshape(total_l.shape[1])[0:N]  # (1, 480) -- > 480

basis_train_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/basis_train_ori.mat')['basis_train_ori']  # (630, 200)
hav_train_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/hav_train_ori.mat')['hav_train_ori']
hav_train_ori = hav_train_ori.reshape(hav_train.shape[0])  # (630, 1) --> 630
total_l_ori = total_l

# 只有train？改成np.concatenate([train, test])
coe_train_l = np.zeros((pc_num, N, S))
coe_train_l_ori = np.zeros((pc_num, N, S))
for n in range(1, N):  # 240
# for n in range(1, 180):
    coe_train_l[:, n - 1, :] = np.transpose(scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n) + '_train_out_l.mat')['train_out'][:, 0:200])
    coe_train_l_ori[:, n - 1, :] = np.transpose(scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n) + '_train_ori_l.mat')['p_l_train'][:, 0:200])  # (10, 200) - train_num, num

# Reconstruct HRTF
hd_l_train = np.zeros((S, N, M))
hrtf_l_train = np.zeros((S, N, M))
hd_l_train_ori = np.zeros((S, N, M))
hrtf_l_train_ori = np.zeros((S, N, M))

# basis_train = np.ones((1890, 200))

# pca projection
for i in range(0, S):
    for l in range(0, M):
        # print("coe: ", np.transpose(coe_l[:, :, i]).shape)  (480, 200)
        # print("basis: ", np.transpose(basis_train[l, :]).shape)  (200,)
        # print("hd: ", hd_l_train[i, :, l].shape)  (480,)
        hd_l_train[i, :, l] = np.transpose(coe_train_l[:, :, i]) @ np.transpose(basis_train[l, :])
        hrtf_l_train[i, :, l] = hd_l_train[i, :, l] + hav_train[l] + total_l
        # hrtf_l_train[i, :, l] = hd_l_train[i, :, l]
        hd_l_train_ori[i, :, l] = np.transpose(coe_train_l_ori[:, :, i]) @ np.transpose(basis_train_ori[l, :])
        hrtf_l_train_ori[i, :, l] = hd_l_train_ori[i, :, l] + hav_train_ori[l] + total_l_ori

        # print(hrtf_l_train[i, :, l])
        # print(hrtf_l_train_ori[i, :, l])
        # input()
        # hrtf_l_train_ori[i, :, l] = hd_l_train_ori[i, :, l]

scio.savemat('../output_data/hrtf_predict/' + type + '/' + database + '/hrtf_output.mat',{'hrtf_l_train':hrtf_l_train})
scio.savemat('../output_data/hrtf_predict/' + type + '/' + database + '/hrtf_ori.mat',{'hrtf_l_train_ori':hrtf_l_train_ori})

# def reconstr(hrtf_l, pn):
#     hrir_l = np.zeros((pn, N))
#     rebuiltphase_l = np.zeros((pn, N))
#     magn_l = np.power(hrtf_l / 20, 10)  # 左耳幅度
#     magn_l_log = np.log(magn_l)  # 左耳对数幅度，以e为底
#     for i in range(0, pn):
#         rebuiltphase_l[i, :] = -np.imag(hilbert(magn_l_log[i, :]))  # 重建相位 lyz:???
#     hr_l = magn_l * np.cos(rebuiltphase_l) + (0 + 1.j) * magn_l * np.sin(rebuiltphase_l)  # 重建后hrtf的对数表示
#     for i in range(0, pn):
#         hrir_l[i, :] = np.real(np.fft.ifft(hr_l[i, :]))  # 左耳时域
#     return hrir_l
#
# hrir_l = np.zeros((S, N, M))
# hrir_l_ori = np.zeros((S, N, M))
# for i in range(0, M):
#     hrir_l[:, :, i] = reconstr(hrtf_l_train[:, :, i], S)
#     hrir_l_ori[:, :, i] = reconstr(hrtf_l_train_ori[:, :, i], S)

# for i in range(0, S):
#     outdir = '../output_data/hrir/' + str(i + 1) + '/'
#     try:
#         scio.savemat(outdir + type + '/' + database + '/hrir_predict_' + str(i + 1) + '.mat', {'hrir_l': hrir_l[i]})
#         scio.savemat(outdir + type + '/' + database + '/hrir_ori_' + str(i + 1) + '.mat', {'hrir_l_ori': hrir_l_ori[i]})
#     except:
#         os.mkdir(outdir)
#         scio.savemat(outdir + type + '/' + database + '/hrir_predict_' + str(i + 1) + '.mat', {'hrir_l': hrir_l[i]})
#         scio.savemat(outdir + type + '/' + database + '/hrir_ori_' + str(i + 1) + '.mat', {'hrir_l_ori': hrir_l_ori[i]})
#
