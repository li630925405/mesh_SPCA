
clear;

% subjectName = {'QY','CJF','LR','GS','ST','WYW','GZS','CGF','HYK'};%,'LX','NYD','PC' ,'LJ''SMJ',
subjectName = {'ymy'};
% subjectName = {'XYX', 'JJB', 'CJX', 'XTR', 'CH', 'YMY', 'ZBJ', 'YMY', 'XW'};% , 'YZY', 'ZGJ'
subjectName = {'JJB', 'CJX', 'ZBJ', 'XW', 'YMY','LYB'};% , 'YZY', 'ZGJ'
testName = {'KEMAR', 'SPCA', 'PCA'};
pn = length(subjectName); % people number
% pn = 9;

ang = [80 55 30 0 330 305 280 235 210 180 150 125];

elevs = [0 22 45];
test = [1 2 3];
selec_val = zeros(36,9);
real_val = zeros(36,9);

fprintf(' \t%s',testName{1},testName{2},testName{3},testName{1},testName{2},testName{3},testName{1},testName{2},testName{3});
fprintf('\n');
for s = 1 : pn
    for i = 1 : 3 % elevation
    % i=1;
        for j = 1 : 3 % tests(methods)
%             load(strcat('../GUI data/',subjectName,'_dist',num2str(dist(i)),'_test',num2str(test(j)),'.mat'))
%             load(strcat('../GUI data/',subjectName,'_dist',num2str(dist(i)),'_test',num2str(test(j)),'_index.mat'))
            t = (i-1)*3+j;
            recordFile = strcat('../GUI data/',subjectName{s},'_elev',num2str(elevs(i)),'_test',num2str(test(j)),'.mat');
            resultFile = strcat('../GUI data/process/',subjectName{s},'_test',num2str(t),'_record_val.mat');
            if(~exist(recordFile, 'file'))% || exist(resultFile, 'file'))
                continue;
            end
            load(recordFile);
            load(strcat('../GUI data/',subjectName{s},'_elev',num2str(elevs(i)),'_test',num2str(test(j)),'_index.mat'))
            selec_val(:, (i-1)*3+j) = val(1:36);
            for k = 1 : 36
                real_val(k, (i-1)*3+j) = ang(index(k));
            end
            [ascend_ang, order]= sort(real_val(:, t));
            record_val = reshape(selec_val(order, t), [3 12])';
%             record_val = record_val(:);
            [err(t, s), errs, ~, rate(t, s)] = fb_confuse(sort(ang'), record_val);
            save(resultFile,'record_val','errs');
%             title([subjectName{s}, '_', testName{j}], 'interpreter', 'none');
%             pause;
        end
    end
    if(~exist(recordFile, 'file'))% || exist(resultFile, 'file'))
        continue;
    end
    fprintf('%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n', subjectName{s}, round(err(:, s)', 0));
%     disp(subjectName{s});
%     display(round(err(:, s)', 0), 'err');
%     display(round(100*rate(:, s)', 0), 'fb_rate');
end

display(round(mean(err(:, :), 2)', 2), 'err_mean');
display(round(mean(100*rate(:, :), 2)', 2), 'fb_rate_mean');
return;

% for k = 5 : 6
%     figure;
%     plot(real_val(:,k),selec_val(:,k),'*')
%     hold on;
%     plot(0:0.5:360,0:0.5:360,'k')
%     hold on;
%     plot(15:0.5:360,0:0.5:345,'k--')
%     hold on;
%     plot(0:0.5:345,15:0.5:360,'k--')
%     hold on;
%     plot(0:0.5:180,180:-0.5:0,'k')
%     hold on;
%     plot(0:0.5:165,165:-0.5:0,'k:')
%     hold on;
%     plot(0:0.5:195,195:-0.5:0,'k:')
%     hold on;
%     plot(180:0.5:360,360:-0.5:180,'k')
%     hold on;
%     plot(195:0.5:360,360:-0.5:195,'k:')
%     hold on;
%     plot(165:0.5:360,360:-0.5:165,'k:')
%     hold off;
%     xlim([0,360])
%     ylim([0,360])
%     xlabel('目标方向','FontName','Microsoft YaHei')
%     ylabel('判定方向','FontName','Microsoft YaHei')
% end
% 
fb=zeros(1,9);
fb_all=zeros(1,9);
correctRate=zeros(1,9);
correctRate_fb=zeros(1,9);
err_ang=zeros(1,9);
for i = 1 : 9
    fb(i)=0;
    correctRate(i) = size(find(abs(real_val(:,i)-selec_val(:,i))<15),1)/36;
    for j = 1 : 36
        if real_val(j,i) > 90 && real_val(j,i) < 270 && (selec_val(j,i) > 270 || selec_val(j,i) < 90)
            fb_all(i) = fb_all(i) + 1;
            if selec_val(j,i) < 90
                selec_val(j,i) = 180 - selec_val(j,i);
                if selec_val(j,i) == real_val(j,i)
                    fb(i) = fb(i) + 1;
                end
            end
            if selec_val(j,i) > 270
                selec_val(j,i) = 540 - selec_val(j,i);
                if selec_val(j,i) == real_val(j,i)
                    fb(i) = fb(i) + 1;
                end
            end
        end
        if selec_val(j,i) > 90 && selec_val(j,i) < 270 && (real_val(j,i) > 270 || real_val(j,i) < 90)
            fb_all(i) = fb_all(i) + 1;
            if selec_val(j,i) <= 180
                selec_val(j,i) = 180 - selec_val(j,i);
                if selec_val(j,i) == real_val(j,i)
                    fb(i) = fb(i) + 1;
                end
            end
            if selec_val(j,i) > 180
                selec_val(j,i) = 540 - selec_val(j,i);
                if selec_val(j,i) == real_val(j,i)
                    fb(i) = fb(i) + 1;
                end
            end
        end
    end

    fb(i) = fb(i)/36; % front-back confusion
    fb_all(i) = fb_all(i)/36;
    correctRate_fb(i) = size(find(abs(real_val(:,i)-selec_val(:,i))<15),1)/36;
    for k = 1 : 36
        diff = abs(selec_val(k,i) - real_val(k,i));
        if diff > 180
            diff = 360 - diff;
        end
        err_ang(i) = err_ang(i) + diff;
    end

    err_ang(i) = err_ang(i)/36; % error angle
    
end
% correctRate
disp(subjectName{s});
correctRate_fb, fb_all, err_ang
% end