close all;
ang = [80 55 30 0 330 305 280 235 210 180 150 125];
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

elevations = [0, 22, 45];
elevs = [0, 22.5, 45];
tests = {'KEMAR', 'PCA', 'SPCA'};
subjectName = {'CGF','HYK','GS','WYW','ST','GZS','CJF','QY','LR', ...
    'JJB','CJX','ZBJ','XW','YMY','LYB',  'XYX','XTR','CH',...
    'NYD','LJ','PC','LX'};% 'SMJ', 
subjectName = subjectName([1:18]);
ns = length(subjectName);

for elev = [0 1 2]; % 0 for 0deg, 1for 22.5deg, 2 for 45deg
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
            'XLim', [-10 360], 'YLim', [-10 360],...
            'XTick', Tick(1:end-1), 'YTick', Tick,...
            ... % 'XScale', 'log', 'YScale', 'log',...
            'fontname', 'Micrsoft Yahei');% Courier
        if(p>1)
            set(ha(p), 'YTickLabel', []);
        else
            ylabel('Judgement Angle (Deg)');
        end
        xlabel('Target Angle (Deg)');
        axis equal;
        hold on;
end

recordStr = zeros(12, 3, length(tests), ns);
errsAll = zeros(36, ns, length(tests));
errConfuse = zeros(2, length(tests), ns);
for i  = 1:ns
    for j = 1:length(tests)
        resultFile = strcat('../GUI data/process/',subjectName{i},'_test',num2str(j+elev*3),'_record_val.mat');
        load(resultFile);
        t = j+(j==2)-(j==3);
        recordStr(:,:,t,i) = record_val;
        errsAll(:, i, t) = errs;
        [errConfuse(1, t, i), ~, ~, errConfuse(2, t, i)] = fb_confuse(angles', record_val);
    end
end
recordStr = permute(recordStr, [1 2 4 3]);
% angls = recordStr;
ind_adj = recordStr >= 355;
recordStr(ind_adj) = recordStr(ind_adj) - 360;
% recordStr = recordStr(:, :, :, [1 3 2]);% adjust the order of data with methods to be G P S
% [Count, ~] = histc(recordStr, edges, 2);
% Count = permute(squeeze(sum(Count, 3)), [2,1,3]);
% Count(:,13,:) = 0;
% [x, y] = meshgrid(angles);
xlables = {'(a)', '(b)', '(c)'};
for j = 1:length(tests)
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
%     set(gca, 'xtick', angles, 'ytick', 0:30:330, 'fontsize', 10);
%     axis equal
%     hold on
    plot(ha(j), [0, 0, 180; 360, 180, 360], [0, 180, 360; 360, 0, 180], 'k:');
%     axis([-10 360 -10 360]);
%     xlabel('Target azimuth (Deg)');
%     ylabel('Percepted azimuth (Deg)');
%     title([tests{j} '-' num2str(elevations(elev+1)) 'Deg']);
    box on;
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', 10);
end
% % saveas(gcf, ['../latex/elavation_' num2str(elevations(elev+1)), '.pdf']);
% % print(['../latex/elavation_' num2str(elevations(elev+1))], '-dpdf');
% 
% % fprintf('%d deg elevation results:\n', elevations(elev+1));
% err = squeeze(mean(errConfuse(1, :, :), 3));
% confuse = squeeze(mean(errConfuse(2, :, :), 3))*100;
% fprintf('\\multirow{3}{*}{%4g}   & Generic & %.2f    & %.2f \\\\\n', ...
%     elevs(elev+1), confuse(1), err(1));
% [p, f] = FTest(errs(1,:)', errs(2,:)');
% fprintf('                        & PCA     & %.2f    & %.2f \\\\\n', ...
%     confuse(2), err(2));
% fprintf('                        & SPCA    & %.2f    & %.2f \\\\ \\hline\n', ...
%     confuse(3), err(3));
% % errsAll = reshape(errsAll, 36*ns, length(tests))';
% % fid = fopen(['errors_azim_' num2str(elevations(elev+1)) '.txt'], 'w+');
% % fprintf(fid, 'Generic, 1, %f\nPCA, 2, %f\nSPCA, 3, %f\n', errsAll);
% % fclose(fid);
% % errsAll = reshape(errsAll, 36*ns, length(tests));
% % [pKEMAR, FKEMAR] = FTest(errsAll(:,2), errsAll(:, 1));
% % fprintf('spca Vs KEMAR: f(1, %d) = %.2f, p = %.4f.\n', 36*ns-2, FKEMAR, pKEMAR);
% % [ppca, Fpca] = FTest(errsAll(:,2), errsAll(:, 3));
% % fprintf('spca Vs pca: f(1, %d) = %.2f, p = %.4f.\n', 36*ns-2, Fpca, ppca);
end