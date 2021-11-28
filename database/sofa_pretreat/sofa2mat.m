% convert sofa files to mat
cd E:\homework\毕业设计\三维模型\ita-toolbox\external_packages\sofa\sofa\API_MO-master\API_MO
SOFAstart;
mesh_num = 44;
database = input('input database: ');
p_root = 'E:\homework\毕业设计\三维模型\SPCA代码\database\'; 
out_root = strcat('E:\homework\毕业设计\三维模型\SPCA代码\SPCA-训练\input_data\', database, '\');

if database == "hutubs"
    p = strcat(p_root, database, '\sofa\');
    ind_list = sort([10, 11, 12, 16, 19, 1, 20, 21, 22, 23, 29, 2, 30, 31, 32, 33, 3, 40, 41, 44, 45, 46, 47, 48, 49, 4, 55, 57, 58, 59, 5, 60, 61, 62, 63, 66, 67, 68, 69, 6, 70, 71, 8, 9]);
    for i = 1:mesh_num
        output_path_l = strcat(out_root, database, '_l_', num2str(i), '.mat');
        output_path_r = strcat(out_root, database, '_r_', num2str(i), '.mat');
        hrtf = SOFAload(strcat(p, 'pp', num2str(ind_list(i)), '_HRIRs_measured.sofa'));
        tmp = hrtf.Data.IR(:, 1, :);
        save(output_path_l, 'tmp');
        tmp = hrtf.Data.IR(:, 2, :);
        save(output_path_r, 'tmp');
    end
elseif database == "cipic"
    ind_list = [03, 08, 09, 10, 11, 12, 15, 17, 18, 19, 20, 21, 27, 28, 33, 40, 44, 48, 50, 51, 58, 59, 60, 61, 65, 119, 124, 126, 127, 131, 133, 134, 135, 137, 147, 148, 152, 153, 154, 155, 156, 158, 162, 163, 165];
    p = strcat(p_root, database, '\');
    for i = 1:mesh_num
        output_path_l = strcat(out_root, database, '_l_', num2str(i), '.mat');
        output_path_r = strcat(out_root, database, '_r_', num2str(i), '.mat');
        num = sprintf('%03d', ind_list(i));
        name = strcat(p, 'subject_', num, '.sofa');
        hrtf = SOFAload(name);
        tmp = hrtf.Data.IR(:, 1, :);
        save(output_path_l, 'tmp');
        tmp = hrtf.Data.IR(:, 2, :);
        save(output_path_r, 'tmp');
    end
elseif database == "chedar"
    mesh_num = 199;
    % 'chedar_0001_UV1m.sofa
    p = strcat(p_root, database, '\UV1m\');
    for i = 120:mesh_num
        output_path_l = strcat(out_root, database, '_l_', num2str(i), '.mat');
        output_path_r = strcat(out_root, database, '_r_', num2str(i), '.mat');
        num = sprintf('%04d', i);
        name = strcat(p, 'chedar_', num, '_UV1m.sofa');
        hrtf = SOFAload(name);
        tmp = hrtf.Data.IR(:, 1, :);
        save(output_path_l, 'tmp');
        tmp = hrtf.Data.IR(:, 2, :);
        save(output_path_r, 'tmp');
    end
end


