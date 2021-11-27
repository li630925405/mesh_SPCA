import scipy.io as scio
import numpy as np
from sklearn.decomposition import PCA
from sklearn import datasets
from plyfile import PlyData, PlyElement
import matplotlib.pyplot as plt
import sys
sys.path.append("..")
from variables import *

num = S * 3  # 选取的主成分个数

# 是用(S*3, N)还是(S, 3*N)进行SPCA？如果主成分只选1个就行的话？

### initialize
# mesh = np.array([])  # N, S

if database == 'chedar':
    ls = range(0, S)
elif database == 'hutubs':
    ls = ind_list = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 16, 19, 20, 21, 22, 23, 29, 30, 31, 32, 33, 40, 41, 44, 45, 46, 47, 48, 49, 55, 57, 58, 59, 60, 61, 62, 63, 66, 67, 68, 69, 70, 71, 72]

for i in ls:
    if database == "chedar":
        file = '../input_data/' + database + '/sample_' + '%04d' % (i + 1) + '.ply'
    elif database == 'hutubs':
        file = '../input_data/' + database + '/pp' + '%d' % i + '_3DsampleMesh.ply'
    sample = np.array(PlyData.read(file).elements[0].data)
    tmp = []
    for m in sample:
        try:
            # tmp = np.vstack((tmp, np.transpose(np.array((m[0], m[1], m[2])), dtype='float64')))  # (135, )
            tmp = np.vstack((tmp, np.array((m[0], m[1], m[2]), dtype='float64')))  # (135, 10000)
            # tmp = np.hstack((tmp, np.array((m[0], m[1], m[2]), dtype='float64')))  # (45, 30000)
        except Exception as e:
            # print(e)
            # print("!", i)
            tmp = np.array((m[0], m[1], m[2]), dtype='float64')
    try:
        mesh = np.hstack((mesh, tmp))
        # mesh = np.vstack((mesh, tmp))
    except Exception as e:
        print(e)
        print(i)
        mesh = tmp

mesh = np.transpose(mesh)  # (S * 3, 10000)
np.savetxt('mesh.csv', mesh, delimiter=',')


num_list = [1, 3, 10, 20, 100, 135]

pca = PCA(num)
pca.fit(mesh)
coeff = pca.transform(mesh)  # 转换后的数据 降维后的向量 也即主成分的系数 # (S * 3, num) -- (S*3, S*3)
# print("ratio: ", pca.explained_variance_ratio_)
# print("components: ", pca.components_)
# print("components shape: ", pca.components_.shape)
# print("coeff: ", coeff)

# pca = PCA(n_components=0.9)  # 保证降维后的数据保持90%的信息
# pca.fit_transform(mesh)
# pc = pca.components_
# print("mesh.shape: ", mesh.shape)
# print("pc.shape: ", pc.shape)
# input()

### draw picture to select number of PCs
x = np.linspace(1, num, num)
# y = sum([abs(i) for i in coeff])
# tot = sum(y)
# perc = np.array([sum(y[0:i+1])/tot for i in range(len(y))])  # zip时不能直接把list和np.array zip
# print(perc)
y = pca.explained_variance_ratio_
tot = sum(y)
perc = np.array([sum(y[0:i + 1]) / tot for i in range(len(y))])
plt.plot(x, perc)
for a, b in zip(x, perc):
    if a-1 in num_list:
        plt.text(a, b, (int(a), round(b, 2)), ha='center', va='bottom', fontsize=7)
        print(a, round(b, 4))
plt.xlabel("PC nums")
plt.ylabel("percentage")
plt.show()

### projection to original data

reconstr = pca.inverse_transform(coeff)
# print(sum(sum(distance_matrix(mesh, reconstr))))
# print("reconstr: ", reconstr)
# print("reconstruct shape: ", reconstr.shape)
# print("---------------------------------")

# x = np.linspace(0, num, S + 1)[0:S].astype(int)
# y = x + 1
# z = x + 2
# x = reconstr[x]
# y = reconstr[y]
# z = reconstr[z]

# vertex = []
# for i in range(10000):
#     vertex.append((x[0][i], y[0][i], z[0][i]))
# vertex = np.array(vertex, dtype=[('x', 'f4'), ('y', 'f4'),
#                                  ('z', 'f4')])
#
# e1 = PlyElement.describe(vertex, 'vertex')
# new_ply = PlyData([e1])
# new_ply.write("mesh.ply" % num)

res = np.zeros((S, 3, num))
for p in range(0, S):
    for q in range(0, 3):
        res[p, q, :] = coeff[p * 3 + q, :]
coeff = res
coeff = coeff.reshape(S, 3 * num)
print("coeff shape: ", coeff.shape)  # (199, 1791) -- (199, 199*9) (S, S*9)

scio.savemat('../output_data/mesh/' + database + '/mesh_coeff.mat', {'coeff': coeff})
