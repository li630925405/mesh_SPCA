# coding: utf-8
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append("..")
from variables import *

itd_train = scio.loadmat('../output_data/hrtf_predict/' + database + '/itd_train.mat')['itd_train']
itd_test = scio.loadmat('../output_data/hrtf_predict//' + database + '/itd_test.mat')['itd_test']
itd_train_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/itd_train_ori.mat')['itd_train_ori']
itd_test_ori = scio.loadmat('../output_data/hrtf_predict/' + database + '/itd_test_ori.mat')['itd_test_ori']

train_e = sum(abs(itd_train-itd_train_ori))/len(itd_train)
test_e = sum(abs(itd_test-itd_test_ori))/len(itd_test)


print("train error: ", train_e)
print("test error: ", test_e)
