import os
from plyfile import PlyData, PlyElement
import numpy as np
import pandas as pd
import math
import sys

vertex_list = np.loadtxt('./list.txt')

def extract_ear(subject):
    file_dir = '../chedar/ply/chedar_' + '%04d' % subject + '.ply'  #文件的路径
    plydata = PlyData.read(file_dir)  # 读取文件
    vertex = plydata.elements[0].data
    new_vertex = []
    for i in range(len(vertex)):
        if i in vertex_list:
            new_vertex.append(vertex[i])
        # if i % 1000 == 0:
        #     print(i)

    print(subject)
    e1 = PlyElement.describe(np.array(new_vertex), 'vertex')
    # print(vertex_idx)
    new_ply = PlyData([e1])
    new_ply.write('../chedar/ply/ear_' + '%04d' % subject + '.ply')


for subject in range(46, 200):
    extract_ear(subject)