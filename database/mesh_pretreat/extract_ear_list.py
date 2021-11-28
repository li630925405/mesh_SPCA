import os
from plyfile import PlyData, PlyElement
import numpy as np
import pandas as pd
import math

# 通过某个耳朵数据，提取耳朵范围的vertex的编号vertex_list，
# 对其它头部数据同样应用这组list, 提取出耳部范围
# 时间复杂度过高，在服务器上跑的

file_dir = '../chedar/ply/chedar_0002.ply'  #文件的路径
plydata = PlyData.read(file_dir)  # 读取文件
ear1 = PlyData.read('ear_0002.ply')

vertex = plydata.elements[0].data
vertex_ear = ear1.elements[0].data

vertex_list = []
# x_l = 0.005
# x_r = -0.025
# # y = 0 右耳
# z_u = 0.035
# z_d = -0.035
for i in range(len(vertex)):
    for j in range(len(vertex_ear)):
        if vertex[i][0] == vertex_ear[j][0] and vertex[i][1] == vertex_ear[j][1] and vertex[i][2] == vertex_ear[j][2]:
            vertex_list.append(i)
    if i % 1000 == 0:
        print(i)

np.savetxt('./list.txt', vertex_list)