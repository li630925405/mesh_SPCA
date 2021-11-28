from plyfile import PlyData, PlyElement
import torch
import torch.nn.functional as F
from torch.autograd import Variable
import numpy as np

database = input("input database: ")

if database == 'chedar':
    mesh_num = 199
    sample_point = 10000
elif database == 'hutubs':
    mesh_num = 45
    sample_point = 20000

def downsample(dim, data):
    ls = []
    if dim == 'x':
        idx = 0
    elif dim == 'y':
        idx = 1
    elif dim == 'z':
        idx = 2
    else:
        print("input x, y or z")
        return
    for i in data:
        ls.append(i[idx])
    ls = np.array(ls)
    ls = Variable(torch.from_numpy(ls))
    ls = ls.view(1, 1, len(ls))
    res = F.interpolate(ls, size = sample_point, mode='linear')
    return res


def batch(input, output):
    plydata = PlyData.read(input)  
    print(plydata)
    print(plydata.elements)
    print(plydata.elements[0])
    input()
    data = plydata.elements[0].data 

    x = downsample('x', data)
    y = downsample('y', data)
    z = downsample('z', data)
    # print(x)
    # print(x.shape)

    vertex = []
    for i in range(sample_point):
        vertex.append((x[0][0][i], y[0][0][i], z[0][0][i]))

    vertex = np.array(vertex, dtype=[('x', 'f4'), ('y', 'f4'),
                                ('z', 'f4')])
    # print(vertex)
    # print(vertex.shape)

    e1 = PlyElement.describe(vertex, 'vertex')
    new_ply = PlyData([e1])
    new_ply.write(output)


if database == 'chedar':
    for i in range(46, mesh_num + 1):
        input = '../chedar/ply/ear_' + '%04d' % i + '.ply'
        output = '../chedar/ply/sample_' + '%04d' % i + '.ply'
        batch(input, output)

    input = '../chedar/ply/ear_' + '%04d' % 2 + '.ply'
    output = '../chedar/ply/sample_' + '%04d' % 2 + '.ply'
    batch(input, output)

elif database == 'hutubs':
    ind_list = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 16, 19, 20, 21, 22, 23, 29, 30, 31, 32, 33, 40, 41, 44, 45, 46, 47, 48, 49, 55, 57, 58, 59, 60, 61, 62, 63, 66, 67, 68, 69, 70, 71, 72]
    for i in ind_list:
        input = '../hutubs/ply/pp' + '%d' % i + '_3DearMesh.ply'
        output = '../hutubs/ply/pp' + '%d' % i + '_3DsampleMesh.ply'
        batch(input, output)