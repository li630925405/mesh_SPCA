# coding: utf-8
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append("..")
from variables import *

num = 200
if database == 'chedar':
    fn = 180
elif database == 'hutubs':
    fn = 128

type = input("anthro or mesh: ")

# 集外数据
coe_test = np.zeros((num, N, test_num))
coe_test_ori_l = np.zeros((num, N, test_num))

for n in range(0, fn):
    test_out = scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n + 1) + '_test_out_l.mat')['test_out'][:, 0:200]
    coe_test[:, n, :] = (np.transpose(test_out)).reshape(num, test_num)

coe_test_l = coe_test

for n in range(0, fn):
    p_l_test = scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n + 1) + '_test_ori_l.mat')['p_l_test'][:, 0:200]
    coe_test_ori_l[:, n, :] = np.transpose(p_l_test).reshape(num, int(test_num))

for n in range(fn, N):
    coe_test_l[:, n, :] = coe_test_l[:, N-1 - n, :]
    coe_test_ori_l[:, n, :] = coe_test_ori_l[:, N-1 - n, :]

# 集内数据
coe_train = np.zeros((num, N, train_num))
coe_train_ori_l = np.zeros((num, N, train_num))
for n in range(0, fn):
    train_out = scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n + 1) + '_train_out_l.mat')['train_out'][:, 0:200]
    coe_train[:, n, :] = np.transpose(train_out).reshape(num, train_num)

coe_train_l = coe_train[:, :, 0:train_num]

for n in range(0, fn):
    p_l_train = scio.loadmat('../output_data/coeff_predict/' + type + '/' + database + '/coeff_f' + str(n + 1) + '_train_ori_l.mat')['p_l_train'][:, 0:200]
    coe_train_ori_l[:, n, :] = np.transpose(p_l_train).reshape(num, int(train_num))

for n in range(fn, N):
    coe_train_l[:, n, :] = coe_train_l[:, N-1 - n, :]
    coe_train_ori_l[:, n, :] = coe_train_ori_l[:, N-1 - n, :]

# 选择要计算的对象
coe_l = np.concatenate([coe_train_l, coe_test_l], axis=2)
coe_ori_l = np.concatenate([coe_train_ori_l, coe_test_ori_l], axis=2)
# l = int(train_num / 2 + test_num / 2)
l = train_num + test_num

msel = np.zeros((fn, l))

for p in range(0, l):
    for m in range(0, fn):
        msel[m, p] = sum(np.abs(coe_l[:, m, p] - coe_ori_l[:, m, p])) / sum(np.abs(coe_ori_l[:, m, p]))

mean_mse = np.mean(msel, axis=1)
fs = 44100
f = np.transpose(np.linspace(0, mean_mse.shape[0] - 1, mean_mse.shape[0])) * fs / mean_mse.shape[0]  # ?
xx = np.linspace(0, mean_mse.shape[0] - 1, mean_mse.shape[0])
print('MSE: %f' % np.mean(mean_mse))

plt.figure(figsize=(16, 12))
plt.title('coeff mse change with fn', fontsize=12)
plt.xlabel('f', fontsize=12)
plt.ylabel('coeff mse', fontsize=12)
plt.plot(xx, mean_mse)
plt.legend(fontsize=12)
plt.show()


# In[4]:


for fn in [0, 10, 20, 50, 100, 200]:
    plt.figure(figsize=(16, 12))
    plt.title('Origin value vs. Predicted value, fn = %d' % fn, fontsize=12)
    plt.xlabel('spatial principle component', fontsize=12)
    plt.ylabel('SPC coeff', fontsize=12)
    # plt.xlim(1, 50)
    # plt.ylim(-N, N)
    plt.plot(coe_l[:, fn, 18], color='r', label='predict')  # 18号
    plt.plot(coe_ori_l[:, fn, 18], color='b', label='original')
    plt.plot(coe_l[:, fn, 34], color='y', label='predict 2')
    plt.plot(coe_ori_l[:, fn, 34], color='g', label='original 2')
    plt.legend(fontsize=12)
    plt.show()

