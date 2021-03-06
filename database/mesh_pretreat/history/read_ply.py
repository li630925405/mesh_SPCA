import os
from plyfile import PlyData, PlyElement
import numpy as np
import pandas as pd

# ply数据格式信息

file_dir = 'ear_0001.ply'  #文件的路径  
plydata = PlyData.read(file_dir)  # 读取文件
# plydata.elements[0]: vertex
# plydata.elements[1]: faces
# vertex 55332; face: 110660
# only ear: vertex: 10899; face: 21546
data = plydata.elements[0].data  # 读取数据
data_pd = pd.DataFrame(data)  # 转换成DataFrame, 因为DataFrame可以解析结构化的数据
# chedar_0001.ply没有颜色信息
# 俺感觉到这里就可以了
data_np = np.zeros(data_pd.shape, dtype=np.float)  # 初始化储存数据的array
property_names = data[0].dtype.names  # 读取property的名字
print(property_names)  # x, y, z
for i, name in enumerate(property_names):  # 按property读取数据，这样可以保证读出的数据是同样的数据类型。
    data_np[:, i] = data_pd[name]