% close all;
theta = (0:5:180)*pi/180;
phi = (0.001:5:359)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);
azim = round(Phi(:)'*180/pi);
elev = 90 - round(Theta(:)'*180/pi);
X = sin(Theta).*cos(Phi);
Y = sin(Theta).*sin(Phi);
Z = cos(Theta);
Pol = atan2(X, -Z);
Pol(Pol>pi) = Pol(Pol>pi) - 2*pi;
Lat = atan2(Y, sqrt(X.^2 + Z.^2));
shape = size(X);
polar = (-45:5.625:235)*pi/180;
lateral = [-100 -80 -65 -55 -45:5:45 55 65 80 100]*pi/180;
pol = polar+pi/2;
pol(pol>pi) = pol(pol>pi)-2*pi;
[pol, ind] = sort(pol);
pol = [-pol(end) pol];
ind = [ind(end), ind];
lat = lateral;
% [pol, lat] = meshgrid(pol, lat);
[lat, pol] = meshgrid(lat, pol);

% v = ones(size(lat));
% V = interp2(lat, pol, v, Lat(:), Pol(:));
% V = reshape(V, shape);
% figure;
% % scatter3(x(:), y(:), z(:), 20, v(:));
% scatter(lat(:), pol(:), 20,  v(:));
% hold on
% scatter(Lat(:), Pol(:), 5);
% % hold on 
% % mesh(X, Y, Z, V);
% axis equal

% subjectName = {'subject_165', 'GZS', 'CJF', 'CGF', 'LJ', 'LR', 'NYD', 'QY', 'LX', 'PC', 'GS', 'WYW', 'ST', 'HYK', 'SMJ'};
% load('../sub_IEEE_P1_name');
subjectName = {'ZGJ', 'ZBJ'};
type = {'_kemar', '_pca', '_spca'};
for i = 1:length(subjectName)
    for j = 1:length(type)
        filepath = ['../HRIR_polar/' subjectName{i}];
        fileName = dir([filepath '/*' type{j} '*.mat']);
        if(isempty(fileName));continue;end
        fileName = fileName.name;
        load([filepath '/' fileName]);
        hrir_l = [fliplr(hrir_l(1, :, :)); hrir_l; fliplr(hrir_l(end, :, :))];
        hrir_r = [fliplr(hrir_r(1, :, :)); hrir_r; fliplr(hrir_r(end, :, :))];
        hrir_l = hrir_l(:, ind, :);
        hrir_r = hrir_r(:, ind, :);
        
        len = size(hrir_l, 3);
        HR_L = zeros(length(azim), len);
        HR_R = HR_L;
        for it = 1:len
            HR_L(:, it) = interp2(lat, pol, squeeze(hrir_l(:, :, it))', Lat(:), Pol(:));
            HR_R(:, it) = interp2(lat, pol, squeeze(hrir_r(:, :, it))', Lat(:), Pol(:));
        end
        outpath = ['../HR/' subjectName{i} '/'];
        if(~isdir(outpath));mkdir(outpath);end
        save([outpath 'hrir' type{j}], 'HR_L', 'HR_R', 'azim', 'elev');
    end
    fprintf('complete %d / %d\n', i, length(subjectName));
end