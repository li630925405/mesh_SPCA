clear all
clc
fs=100;%�趨����Ƶ��
N=128; n=0:N-1; t=n/fs;
f0=10;%�趨�����ź�Ƶ��
%���������ź�
x=sin(2*pi*f0*t);
figure(1); subplot(311); plot(t,x);%�������źŵ�ʱ����
xlabel('t'); ylabel('y'); title('�����ź�y=2*pi*10tʱ����'); grid;
%����FFT�任����Ƶ��ͼ
y=fft(x,N);%����fft�任
% N��fs��ʲô����
mag=abs(y);%���ֵ
f=(0:length(y)-1)'*fs/length(y);%���ж�Ӧ��Ƶ��ת��
figure(1); subplot(312); 
plot(f,mag);%��Ƶ��ͼ
%plot(f, y);
% axis([0,100,0,80]); 
xlabel('Ƶ��(Hz)'); ylabel('��ֵ'); title('�����ź�y=2*pi*10t��Ƶ��ͼN=128'); grid;
%��IFFT�ָ�ԭʼ�ź�
xifft=ifft(y); magx=real(xifft); ti=[0:length(xifft)-1]/fs;
figure(1); subplot(313); plot(ti,magx);
xlabel('t'); ylabel('y'); title('ͨ��IFFTת���������źŲ���'); grid;