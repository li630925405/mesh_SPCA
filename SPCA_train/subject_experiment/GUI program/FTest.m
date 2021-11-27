function [p, F] = FTest(arr1, arr2)
n1 = length(arr1);
n2 = length(arr2);
% 均值
mu1 = mean(arr1);
mu2 = mean(arr2);
mu = (mu1*n1+mu2*n2)/(n1+n2);
% 组间离差平方和
ssb = (mu-mu1)^2*n1 + (mu-mu2)^2*n2;
% 组内离差平方和
ssw = sum((arr1-mu1).^2) + sum((arr2-mu2).^2);
% 组内均方
sigma = ssw / (n1+n2-2);
F = ssb / sigma;
p = fcdf(F, 1, n1+n2-2, 'upper');