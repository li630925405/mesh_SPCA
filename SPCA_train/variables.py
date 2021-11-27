database = input("input database: ")
print(database)
# print(database is "chedar")  # 不行 为啥
# print(database == "chedar")
if database == "chedar":
    num = 2520  # num of SPCs
    M = 2520  # 方向个数
    N = 480  # 频点
elif database == "cipic":
    num = 1250  # num of SPCs
    M = 1250  # 方向个数
    N = 200  # 频点
elif database == "hutubs":
    num = 440  # num of SPCs
    M = 440  # 方向个数
    N = 256  # 频点

pc_num = 200
S = 45  # 个体数量
test_num = 10
train_num = 35
valid_num = 5
mesh_num = 60  # 扫描数据主成分个数 ×3
