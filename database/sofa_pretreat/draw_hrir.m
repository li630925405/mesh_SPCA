% clear all
% clc
database = input('input databse: ');
dir = input('input direction: ');
p_root = 'E:\homework\��ҵ���\��άģ��\SPCA����\database\';  
% ����Ӳ������ matlab·��̫�ֱ࣬��'../'����֪������ȥ��
if database == "hutubs"
    fs = 44100;
    N = 256;
    disp(p_root);
    disp(database);
    disp('\sofa\');
    p = strcat(p_root, database, '\sofa\');
    filename = strcat(p, 'pp1_HRIRs_measured.sofa');
    % Ҳ���Ըĳ�/�ٻ�һ��simulate
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
%����FFT�任����Ƶ��ͼ

% hutubs measure
mea = SOFAload(filename);
mea_left = permute(mea.Data.IR(dir,1,:), [3,2,1]);
% N��fs��ʲô����
figure(1);subplot(211);
plot(t, mea_left);%��Ƶ��ͼ
xlabel('ʱ��(ms)'); ylabel('��ֵ'); title('���ʱ����'); grid;

mea_right = permute(mea.Data.IR(dir,2,:), [3,2,1]);
% N��fs��ʲô����
figure(1);subplot(212);
plot(t, mea_right);%��Ƶ��ͼ
xlabel('ʱ��(ms)'); ylabel('��ֵ'); title('�Ҷ�ʱ����'); grid;