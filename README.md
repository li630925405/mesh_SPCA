### 数据集 - database

数据下载：

`wget -r -np -A "chedar_00[5-9][0-9].ply" http://sofacoustics.org/data/database/chedar/ `

（下载chedar_0050.ply到chedar_0099.ply

`-A acclist --accept acclist` 后可加文件后缀或文件格式）

1. **chedar**

   + ply

     + chedar_0001.ply：原始3D mesh数据
     + ear_0001.ply：提取的耳部范围数据
     + sample_0001.ply：重采样后的数据（每个mesh有10000个顶点）

   + UV1m

     + chedar_0001_UV1m.sofa

   + dir.mat: 保存HRIR的方向与顺序信息，获取方式为HRTF.IR.SourcePosition

     共2552个方向

     先x不变，遍历y

     x: 90 -> 85 -> … -> 0 -> -5 -> -180 -> 175 -> 170 -> … -> 95

     y: 85 -> 80 -> 0 -> -5 -> -85

   + measurements.mat: 原始的人体参数

     anthro.mat: 选取的人体参数

   + 共200个被试

2. **cipic**

   + subject_003.sofa

   + 共45项数据

     + 两个KEMAR头（一个大耳朵，一个小耳朵），43个被试（27男16女）
     + 其中小耳朵KEMAR头被当作通用HRTF

   + 共1250个方向

     水平角共25个，包括 q=[-80 -65 -55 -45:5:45 55 65 80]；

     仰角共 50个，包括 j=-45+5.625*(0:49)

     先x不变，遍历y

3. **hutubs**

   + ply
     + pp1_3DheadMesh.ply
     + pp1_3DearMesh.ply
     + pp1_3DsampleMesh.ply
   + sofa
     + pp1_HRIRs_measured.sofa：440个方向
     + pp1_HRIRs_simulated.sofa

**预处理  pretreat：**

1. mesh

   `database\mesh_pretreat` 里

   extract_ear_list.py：提取耳部范围数据的顶点列表至list.txt

   extract_from_list.py: 根据上述顶点列表，从其它头部数据中提取耳部数据

   resamply.py: 重采样

2. sofa

   运行sofa2mat.m，将原始HRIR的.sofa文件转换为.mat文件

   输入数据集：'chedar', 'hutubs' 或 'cipic'

   （`cd E:\homework\毕业设计\三维模型\ita-toolbox\external_packages\sofa\sofa\API_MO-master\API_MO`

   和

   `SOFAstart;`

   调用ita-toolbox工具箱）

### 网络 - SPCA-训练

#### 输入 input_data

1. chedar

   + average_itd.mat

     (1250, 1)维 存储各个方向的双耳时间差

   + chedar_l_1.mat 

   + chedar_r_1.mat

   + dir.mat

   + sample_0001.ply (手动从database文件夹复制过来的...)

2. cipic

   + cipic_l_1.mat
   + cipic_r_1.mat
   + dir.mat

3. hutubs

   + hutubs_l_1.mat
   + hutubs_r_1.mat
   + dir.mat
   + pp1_3DsampleMesh.ply

#### 输出 output_data

1. **coeff_predict**

   + anthro: 用人体参数训练的结果

     + coeff_f1_test_ori_l.mat

       原本的测试集第一个频点的主成分参数

     + coeff_f1_train_ori_l.mat

       原本的训练集第一个频点的主成分参数

     + coeff_f1_test_out.mat

       预测的测试集第一个频点的主成分参数

     + coeff_f1_train_out.mat

       预测的训练集第一个频点的主成分参数

   + mesh: 用三维网格训练的结果

     + chedar
     + hutubs
     + 文件命名同上

2. **hrir**

   原始的和合成的hrir

3. **hrtf_predict**

   + basis_test.mat
   + basis_test_ori.mat
   + basis_train.mat
   + basis_train_ori.mat
   + hav_test.mat
   + hav_test_ori.mat
   + hav_train.mat
   + hav_train_ori.mat
   + itd_test.mat
   + itd_test_ori.mat
   + itd_train.mat
   + itd_train_ori.mat
   + hrtf_ori.mat
   + hrtf_output.mat

4. **hrtf_spca**

   SPCA的输出

   + coeff_l.mat 主成分
   + pc_l.mat 主成分系数
   + hav_l.mat 平均空间函数
   + itd.mat
   + total_l.mat, hd_l.mat （后续复原HRTF & debug用）

5. **mesh**

   + mesh_coeff.mat

     三维扫描数据的主成分参数