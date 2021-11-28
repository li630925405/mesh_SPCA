clear all
clc
% fs=100;%设定采样频率 44100?
fs=44100;
N=480; n=0:N-1; t=n*1000/fs;
%进行FFT变换并做频谱图
res = zeros(45, 2522);
for i=1:1
    for j=1250:1250
        load('chedar'+string(i)+'.mat');
        left=permute(tmp(j, 1, :), [3,2,1]); 
        % N和fs有什么区别？
        figure(1);subplot(311);
        plot(t, left);%做频谱图
        xlabel('时间(ms)'); ylabel('幅值'); title('左耳时域波形'); grid;

        load('chedar_r_'+string(i)+'.mat');
        right=permute(tmp(j, 1, :), [3,2,1]); 
        % N和fs有什么区别？
        figure(1);subplot(312);
        plot(t, right);%做频谱图
        xlabel('时间(ms)'); ylabel('幅值'); title('右耳时域波形'); grid;

        [c, lags] = xcorr(left, right);
        figure(1);subplot(313);
        stem(lags, c);  % length(c): 959  c(480): 0
        title('互相关'); 
        [m, index] = max(c);
        itd = (480 - index)*1000/fs;
        disp(index);
        disp(itd);
        res(i, j) = itd;
    end
end

% save('./itd.mat', 'res');

% %进行FFT变换并做频谱图
% y=fft(x,N);%进行fft变换
% % N和fs有什么区别？
% mag=abs(y);%求幅值
% f=(0:length(y)-1)'*fs/length(y);%进行对应的频率转换
% figure(1); subplot(212); plot(f,mag);%做频谱图
% xlabel('频率(Hz)'); ylabel('幅值'); title('幅频谱图N=128'); grid;
