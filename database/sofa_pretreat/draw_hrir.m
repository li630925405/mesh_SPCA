% clear all
% clc
database = input('input databse: ');
dir = input('input direction: ');
p_root = 'E:\homework\毕业设计\三维模型\SPCA代码\database\';  
% 这能硬编码吗 matlab路径太多，直接'../'都不知道到哪去了
if database == "hutubs"
    fs = 44100;
    N = 256;
    disp(p_root);
    disp(database);
    disp('\sofa\');
    p = strcat(p_root, database, '\sofa\');
    filename = strcat(p, 'pp1_HRIRs_measured.sofa');
    % 也可以改成/再画一个simulate
elseif database == "cipic"
    fs = 44100;
    N = 200;
    p = strcat(p_root, database, '\');
    filename = strcat(p, 'subject_003.sofa');
elseif database == "chedar"
    fs = 48000;
    N = 480;
    p = strcat(p_root, database, '\UV1m\');
    filename = strcat(p, 'chedar_0001_UV1m.sofa');
end

n=0:N-1; 
t=n*1000/fs;
%进行FFT变换并做频谱图

% hutubs measure
mea = SOFAload(filename);
mea_left = permute(mea.Data.IR(dir,1,:), [3,2,1]);
% N和fs有什么区别？
figure(1);subplot(211);
plot(t, mea_left);%做频谱图
xlabel('时间(ms)'); ylabel('幅值'); title('左耳时域波形'); grid;

mea_right = permute(mea.Data.IR(dir,2,:), [3,2,1]);
% N和fs有什么区别？
figure(1);subplot(212);
plot(t, mea_right);%做频谱图
xlabel('时间(ms)'); ylabel('幅值'); title('右耳时域波形'); grid;