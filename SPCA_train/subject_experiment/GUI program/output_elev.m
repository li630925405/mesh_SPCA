
clear;

subjectName = {'CGF','HYK','GS','WYW','ST','GZS','CJF','QY','LR', ...
    'JJB','CJX','ZBJ','XW','YMY','LYB',  'XYX','XTR','CH',...
    'NYD','LJ','PC','LX'};% 'SMJ', 
pn = length(subjectName); % people number

ang = [90 70 47 19 0 -19 -42];

fb = [0 1];
test = [1 2 3];
selec_val = zeros(21,6);
real_val = zeros(21,6);

for s = 1 : pn
    for i = 1 : 2
    % i=1;
        for j = 1 : 3
            load(strcat('../GUI data/elevation data/',subjectName{s},'_fb',num2str(fb(i)),'_test',num2str(test(j)),'.mat'))
            load(strcat('../GUI data/elevation data/',subjectName{s},'_fb',num2str(fb(i)),'_test',num2str(test(j)),'_index.mat'))
%             load(strcat('../GUI data/elevation data/',subjectName{s},'_fb',num2str(fb(i)),'_test',num2str(test(j)),'.mat'))
%             load(strcat('../GUI data/elevation data/',subjectName{s},'_fb',num2str(fb(i)),'_test',num2str(test(j)),'_index.mat'))
            selec_val(:, (i-1)*3+j) = val(1:21);
            selec_val(selec_val>90) = 180 - selec_val(selec_val>90);
            for k = 1 : 21
                real_val(k, (i-1)*3+j) = ang(index(k));
            end
            t = (i-1)*3+j;
            [ascend_ang, order]= sort(real_val(:, t));
            record_val = reshape(selec_val(order, t), [3 7])';
%             record_val = record_val(:);
            [err(t, s), errs, ~, rate(t, s)] = fb_confuse(90-sort(ang'), 90-record_val);
            dest = strcat('../GUI data/process/',subjectName{s},'_test',num2str(t),'_elev_record_val.mat');
            save(dest, 'record_val', 'errs');
        end
    end
    fprintf('%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n', subjectName{s}, round(err(:, s)', 0));
%     disp(subjectName{s});
%     display(round(err(:, s)', 0), 'err');
%     display(round(100*rate(:, s)', 0), 'fb_rate');
end
display(round(mean(err(:, :), 2)', 2), 'err_mean');
display(round(mean(100*rate(:, :), 2)', 2), 'ud_rate_mean');
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
ud=zeros(1,6);
ud_all=zeros(1,6);
correctRate=zeros(1,6);
correctRate_ud=zeros(1,6);
err_ang=zeros(1,6);
for i = 1 : 6
%     ud(i)=0;
    correctRate(i) = size(find(abs(real_val(:,i)-selec_val(:,i))<15),1)/21;
    for j = 1 : 21
        if real_val(j,i) > 0 && selec_val(j,i) < 0
            ud_all(i) = ud_all(i) + 1;
            selec_val(j,i) = -selec_val(j,i);
        end
        if selec_val(j,i) > 0 && real_val(j,i) < 0
            ud_all(i) = ud_all(i) + 1;
            selec_val(j,i) = -selec_val(j,i);
        end
    end

%     ud(i) = ud(i)/21; % up-down confusion
    ud_all(i) = ud_all(i)/21;
    correctRate_ud(i) = size(find(abs(real_val(:,i)-selec_val(:,i))<15),1)/21;
    for k = 1 : 21
        diff = abs(selec_val(k,i) - real_val(k,i));
%         if selec_val(k,i) + real_val(k,i) == 0
%             diff = 0;
%         end
        err_ang(i) = err_ang(i) + diff;
    end

    err_ang(i) = err_ang(i)/21; % error angle
    
end
correctRate
correctRate_ud
% ud
ud_all
err_ang
