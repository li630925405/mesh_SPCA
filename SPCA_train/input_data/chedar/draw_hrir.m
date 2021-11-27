clear all
clc
% fs=100;%�趨����Ƶ�� 44100?
fs=44100;
N=480; n=0:N-1; t=n*1000/fs;
%����FFT�任����Ƶ��ͼ
res = zeros(45, 2522);
for i=1:1
    for j=1250:1250
        load('chedar'+string(i)+'.mat');
        left=permute(tmp(j, 1, :), [3,2,1]); 
        % N��fs��ʲô����
        figure(1);subplot(311);
        plot(t, left);%��Ƶ��ͼ
        xlabel('ʱ��(ms)'); ylabel('��ֵ'); title('���ʱ����'); grid;

        load('chedar_r_'+string(i)+'.mat');
        right=permute(tmp(j, 1, :), [3,2,1]); 
        % N��fs��ʲô����
        figure(1);subplot(312);
        plot(t, right);%��Ƶ��ͼ
        xlabel('ʱ��(ms)'); ylabel('��ֵ'); title('�Ҷ�ʱ����'); grid;

        [c, lags] = xcorr(left, right);
        figure(1);subplot(313);
        stem(lags, c);  % length(c): 959  c(480): 0
        title('�����'); 
        [m, index] = max(c);
        itd = (480 - index)*1000/fs;
        disp(index);
        disp(itd);
        res(i, j) = itd;
    end
end

% save('./itd.mat', 'res');

% %����FFT�任����Ƶ��ͼ
% y=fft(x,N);%����fft�任
% % N��fs��ʲô����
% mag=abs(y);%���ֵ
% f=(0:length(y)-1)'*fs/length(y);%���ж�Ӧ��Ƶ��ת��
% figure(1); subplot(212); plot(f,mag);%��Ƶ��ͼ
% xlabel('Ƶ��(Hz)'); ylabel('��ֵ'); title('��Ƶ��ͼN=128'); grid;
