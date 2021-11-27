import scipy.io as scio
import numpy as np
from sklearn.decomposition import PCA
from sklearn import datasets
import matplotlib.pyplot as plt
import sys
sys.path.append("..")
from variables import *


def cal_basis():
    # initialize
    total_l = 0
    hrtf_l = np.zeros((M, N, S))
    hav_l = np.zeros((M, 1))  # 平均空间函数

    print("begin load")

    # mat方向是前一半在前面，后一半在后面
    for i in range(0, S):
        mat = scio.loadmat('../input_data/' + database + '/' + database + '_l_' + str(i + 1) + '.mat')['tmp']
        if database == "chedar":
            mat = mat.reshape(M+2, N)  # (2522, 1, 480) -> (2522, 480)
            mat = np.delete(mat, 70, axis=0)  # (0, 0)
            mat = np.delete(mat, 281, axis=0)  # (180, 0)
        for j in range(0, M):
            hrtf_l[j, :, i] = 20 * np.log10(np.abs(np.fft.fft(mat[j, :])))
            total_l = total_l + hrtf_l[j, :, i]

    print("end load")

    total_l = total_l / (M * S)

    # 求Hd

    tf_l = np.zeros((M, N, S))  # 零均值化的hrtf
    htf_l = np.zeros((M, N, S))  # 空间方向向量
    hd_l = np.zeros((N*S, M))  # 空间方向向量
    pc_l = np.zeros((N, num, S))  # 空间主成分

    # 去平均
    for i in range(0, S):
        for m in range(0, M):
            tf_l[m, :, i] = hrtf_l[m, :, i] - total_l

    for i in range(M):
        hav_l[i] = sum(sum(tf_l[i]))

    print('begin')
    hav_l = hav_l / (N * S)
    hav_l = np.transpose(hav_l).reshape(M)

    for i in range(0, S):
        for j in range(0, N):
            htf_l[:, j, i] = tf_l[:, j, i] - hav_l
            hd_l[(i - 1) * N + j, :] = np.transpose(htf_l[:, j, i])

    # hd_l = np.transpose(hd_l)

    pca = PCA(num)
    pca.fit(hd_l)
    p_l = pca.transform(hd_l)
    print(p_l.shape)
    input()
    coeff_l = pca.components_  # (num, M)
    np.savetxt("./pc_variance.txt", pca.explained_variance_ratio_)

    for p in range(0, S):
        for q in range(0, N):
            pc_l[q, :, p] = p_l[p * N + q, :]

    print('end PCs')

    scio.savemat('../output_data/hrtf_spca/' + database + '/pc_l.mat', {'pc_l': pc_l})  # 系数 太奇怪了！
    scio.savemat('../output_data/hrtf_spca/' + database + '/hd_l.mat', {'hd_l': hd_l})
    scio.savemat('../output_data/hrtf_spca/' + database + '/coeff_l.mat', {'coeff_l': coeff_l})  # 主成分
    scio.savemat('../output_data/hrtf_spca/' + database + '/total_l.mat', {'total_l': total_l})
    scio.savemat('../output_data/hrtf_spca/' + database + '/hav_l.mat', {'hav_l': hav_l})


def plot_pc():
    y = np.loadtxt("./pc_variance.txt")
    select_x = [1, 50, 100, 200, 500, 1000]
    x = np.linspace(1, num, num)
    tot = sum(y)
    perc = np.array([sum(y[0:i])/tot for i in range(len(y))])  # zip时不能直接把list和np.array zip
    plt.plot(x, perc)
    for a, b in zip(x, perc):
        if a-1 in select_x:
            plt.text(a, b, (int(a), round(b, 2)), ha='center', va='bottom', fontsize=7)
            print(a, round(b, 4))
    plt.show()


if __name__ == "__main__":
    cal_basis()
