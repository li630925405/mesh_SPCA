close all;
ang = [90 70 47 19 0 -19 -42];
angles = sort(ang);
edges = angles - 30/2;

xx = ones(1,6*6)*30;
yx = 0:5:180-5;
Ctx = xx/15;
Ctx([1:6:end 5:6:end]) = 0;
Ctx(6:6:36) = 5:5:30;
xt = [];
yt = [];
ct = [];
for ix = 1:6
    xt = [xt, repmat(xx(ix*6), 1, ix*5)];
    yt = [yt, repmat(yx(ix*6), 1, ix*5)];
    ct = [ct, repmat(Ctx(ix*6), 1, ix*5)];
end
validx = find(Ctx>0);
validx = validx(validx<=30);

fbStr = {'back', 'front'};
azims = [150 30];
tests = {'KEMAR', 'PCA', 'SPCA'};
subjectName = {'CGF','HYK','GS','WYW','ST','GZS','CJF','QY','LR', ...
    'JJB','CJX','ZBJ','XW','YMY','LYB',  'XYX','XTR','CH',...
    'NYD','LJ','PC','LX'};% 'SMJ', 
subjectName = subjectName([1:18]);
ns = length(subjectName);

for fb = [1 0]; % 0 for "back", 1 for "front"
cond = length(tests);
Tick = 0:60:360;
figure(1);
clf;
set(gcf, 'Position', [267 248.3333 734.6667 267.3333], ...
    'PaperPosition', [-0.8 -0.3 24.5 9], ...
    'PaperSize', [23.6 8.8]);
for p = 1:cond
        ha(p) = axes('Position', [0.1+(p-1)*0.87/3 0.2 0.873/3 0.75]);
        set(ha(p), 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on',...
            'XLim', [-100 100], 'YLim', [-100 100],...
            'XTick', angles, 'YTick', -90:30:90,...
            ... % 'XScale', 'log', 'YScale', 'log',...
            'fontname', 'Micrsoft Yahei');% Courier
        if(p>1)
            set(ha(p), 'YTickLabel', []);
        else
            ylabel('Judgement Angle (Deg)');
        end
        xlabel('Target Angle (Deg)');
        axis equal
        hold on;
end

recordStr = zeros(7, 3, length(tests), ns);
errsAll = zeros(21, ns, length(tests));
errConfuse = zeros(2, length(tests), ns);
for i  = 1:ns
    for j = 1:length(tests)
        load(strcat('../GUI data/process/',subjectName{i},'_test',num2str(j+fb*3),'_elev_record_val.mat'))
        t = j+(j==2)-(j==3);
        recordStr(:,:,t,i) = record_val;
        errsAll(:, i, t) = errs;
        [errConfuse(1, t, i), ~, ~, errConfuse(2, t, i)] = fb_confuse(90 - angles', 90 - record_val);
    end
end
recordStr = permute(recordStr, [1 2 4 3]);
% angls = recordStr;
% ind_adj = recordStr >= 355;
% recordStr(ind_adj) = recordStr(ind_adj) - 360;
% [Count, ~] = histc(recordStr, edges, 2);
% Count = permute(squeeze(sum(Count, 3)), [2,1,3]);
% Count(:,13,:) = 0;
% [x, y] = meshgrid(angles);
xlables = {'(a)', '(b)', '(c)'};
for j = 1:length(tests)
%                 figure(j);clf;
%                 if(j==3)
%                     ha = axes('Position', [0.82 0.1 0.11 0.5]);
%                     hx = scatter(ha, xx(validx), yx(validx), Ctx(validx)*8, 'filled');
%                     for ix = find(Ctx>4&Ctx<30)
%                         text(xx(ix)+0.5,yx(ix),num2str(Ctx(ix)),'fontsize',14);
%                     end
%                     xlim([29,31]);
%                     axis off
%                 end
%                 
%                 Ct = Count(:,:,j);
%                 [ix, iy] = find(Ct > 0);
%                 valid = sub2ind(size(Ct), ix, iy);
%                 hf = axes('Position',[0.080 0.1100 0.7750 0.8150]);
%                 scatter(hf, x(valid), y(valid), Ct(valid)*8, 'filled');
%                 set(gca, 'xtick', angles, 'ytick', angles, 'fontsize', 10);
%                 axis equal
%                 hold on
%                 plot([0, 0, 180; 360, 180, 360], [0, 180, 360; 360, 0, 180], 'k:');
%                 axis([-10 360 -10 360]);
%                 xlabel('Target azimuth (бу)');
%                 ylabel('Percepted azimuth (бу)');
%                 box on;
    
    angls = recordStr(:, :, :, j);
%     hf = axes('Position',[0.080 0.1100 0.7750 0.8150]);
    scatter(ha(j), repmat(angles, 1, ns*3), angls(:), 48, 'ks', 'filled', 'markerfacealpha', 0.15);
%     set(gca, 'xtick', angles, 'ytick', -90:30:90, 'fontsize', 10);
%     axis equal
%     hold on
    plot(ha(j), [0, 0; 180, 180]-90, [0, 180; 180, 0]-90, 'k:');
%     axis([0 180 0 180]-90);
%     xlabel('Target elavation (бу)');
%     ylabel('Percepted elavation (бу)');
%     title([tests{j} '-' fbStr{fb+1}]);
    box on;
%     set(gca, 'fontname', 'Helvetica', 'fontsize', 10);
%     print(['./angle_' tests{j}], '-depsc');
end
% print(['../latex/azimuth_' fbStr{fb+1}], '-dpdf');

% % fprintf('%s results:\n', fbStr{fb+1});
err = squeeze(mean(errConfuse(1, :, :), 3));
confuse = squeeze(mean(errConfuse(2, :, :), 3))*100;
fprintf('\\multirow{3}{*}{%3g}   & Generic & %.2f    & %.2f \\\\\n', ...
    azims(fb+1), confuse(1), err(1));
[p, f] = FTest(errs(1,:)', errs(2,:)');
fprintf('                       & PCA     & %.2f    & %.2f \\\\\n', ...
    confuse(2), err(2));
fprintf('                       & SPCA    & %.2f    & %.2f \\\\ \\hline\n', ...
    confuse(3), err(3));
% % errsAll = reshape(errsAll, 21*ns, length(tests))';
% % fid = fopen(['errors_elev_' fbStr{fb+1} '.txt'], 'w+');
% % fprintf(fid, 'Generic, 1, %f\nPCA, 2, %f\nSPCA, 3, %f\n', errsAll);
% % fclose(fid);
% errsAll = reshape(errsAll, 21*ns, length(tests));
% [pKEMAR, FKEMAR] = FTest(errsAll(:,2), errsAll(:, 1));
% fprintf('spca Vs KEMAR: f(1, %d) = %.2f, p = %.4f.\n', 36*ns-2, FKEMAR, pKEMAR);
% [ppca, Fpca] = FTest(errsAll(:,2), errsAll(:, 3));
% fprintf('spca Vs pca: f(1, %d) = %.2f, p = %.4f.\n', 36*ns-2, Fpca, ppca);
end