import os
from plyfile import PlyData, PlyElement
import numpy as np
import pandas as pd

# 画了一个四面体 每个面是不同颜色

vertex = np.array([(0, 0, 0),
                      (0, 1, 1),
                      (1, 0, 1),
                      (1, 1, 0)],
                     dtype=[('x', 'f4'), ('y', 'f4'),
                            ('z', 'f4')])
face = np.array([([0, 1, 2], 255, 255, 255),
                    ([0, 2, 3], 255,   0,   0),
                    ([0, 1, 3],   0, 255,   0),
                    ([1, 2, 3],   0,   0, 255)],
                   dtype=[('vertex_indices', 'i4', (3,)),
                          ('red', 'u1'), ('green', 'u1'),
                          ('blue', 'u1')])

# [0, 1, 2]是shape为3的数组，每个数类型为i4 (32bit的整数)
# 255, 255, 255分别是property uchar red, property uchar green和property uchar blue

e1 = PlyElement.describe(vertex, 'vertex')
e2 = PlyElement.describe(face, 'face')
my_ply = PlyData([e1, e2])
my_ply.write('my.ply')