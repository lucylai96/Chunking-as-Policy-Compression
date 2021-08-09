function policyComplexityAnalysis()
prettyplot;
load('actionChunk_data.mat'); 
%%
bmap =[141 182 205     % #8DB6CD LightSkyBlue3
    255 140 105
    238 201 0  % #EED5B7 Bisque2
    155 205 155];   % #9BCD9B DarkSeaGreen3   % #9BCD9B DarkSeaGreen3
bmap = bmap/255;
    
nSubj = length(data);
condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
             'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};
%condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test'};

recode = 1;     % whether to calculate recoded policy complexity
[reward, complexity] = calculateRPC(data, condition, 'regular', recode);             % when each state is rewarded equally
%[reward, complexity] = calculateRPC(data, condition,'incentive_manip', recode);     % when states are rewarded unequally

%% Average policy complexity for different blocks
avgComplx = reshape(mean(complexity,1), [4 2])';
sem = nanstd(complexity,1)/sqrt(nSubj);
sem = reshape(sem, [4 2])';

figure; hold on;
colororder(bmap);
b = bar(avgComplx(:,1:2)); 
errorbar_pos = errorbarPosition(b, sem(:,1:2));
errorbar(errorbar_pos', avgComplx(:,1:2), sem(:,1:2), sem(:,1:2), 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
ylabel('Policy Complexity');
legend('Random Train', 'Structured Train','Location', 'northwest'); legend('boxoff');
exportgraphics(gcf,[pwd '/figures/complexity_train.png'])
 
figure; hold on;
colororder(bmap(3:4,:));
b = bar(avgComplx(:,3:4)); 
errorbar_pos = errorbarPosition(b, sem(:,3:4));
errorbar(errorbar_pos', avgComplx(:,3:4), sem(:,3:4), sem(:,3:4), 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
legend('Strcutured Test', 'Random Test','Location', 'northwest'); legend('boxoff');
ylabel('Policy Complexity');
exportgraphics(gcf,[pwd '/figures/complexity_test.png'])

%% Change in reward VS policy complexity between Random and Structured block
for i = 1:4
    reward_diff(:,i) = reward(:,2*i) - reward(:,2*i-1);
    complexity_diff(:,i) = complexity(:,2*i) - complexity(:,2*i-1);
end
figure;
scatter(complexity_diff(:,1), reward_diff(:,1), 120,'filled'); %Ns6, Structured Test to Ns6, Random Test

%% Reward-complexity curve
plot_RPCcurve(reward, complexity, [1 2], {'Ns=4, Random Train', 'Ns=4, Structured Train'});
plot_RPCcurve(reward, complexity, [5 6], {'Ns=6, Random Train', 'Ns=6, Structured Train'});
plot_RPCcurve(reward, complexity, [3 4], {'Ns=4, Structured Test', 'Ns=4, Random Test'});
plot_RPCcurve(reward, complexity, [7 8], {'Ns=6, Structured Test', 'Ns=6, Random Test'});


%% Reward-complexity curve without scatter plots
entrySet = [1 2 5 6];
color_map = [
             16 78 139
             165 42 42
             141 182 205    
             255 140 105] /255; 
figure; hold on;
for i = 1:length(entrySet)
    polycoef = polyfit(complexity(:,entrySet(i)), reward(:,entrySet(i)), 2);
    X = linspace(0.6, 1.4, 80);
    Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
    p(i) = plot(X, Y, 'Color', color_map(i,:), 'LineWidth', 5);
end
legend('Ns=4, Random Train', 'Ns=4, Structured Train', 'Ns=6, Random Train', 'Ns=6, Structured Train',...
       'location', 'southeast'); legend('boxoff');
ylim([0 1]);xlabel('Policy Complexity'); ylabel('Average Reward');


entrySet = [3 7 8];
colors = {'#D95319', '#7E2F8E', '#EDB120'};
figure; hold on;
for i = 1:length(entrySet)
    polycoef = polyfit(complexity(:,entrySet(i)), reward(:,entrySet(i)), 2);
    X = linspace(0.6, 1.4, 80);
    Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
    p(i) = plot(X, Y, 'Color', colors{i}, 'LineWidth', 4);
end
polycoef = polyfit(complexity(:,4), reward(:,4), 2);
X = linspace(1.1, 1.4, 80);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
plot(X, Y, 'Color', '#0072BD', 'LineWidth', 4);

legend('Ns=4, Structured Test', 'Ns=6, Structured Test', 'Ns=6, Random Test', 'Ns=4, Random Test',...
       'location', 'southeast');
legend('boxoff');
ylim([0 1]); xlabel('Policy Complexity'); ylabel('Average Reward');


%% RT-Complexity curve
avgRT = nan(nSubj, length(condition));
rtChunkCorr = zeros(nSubj, length(condition));
chunkInit = [2,5];
for s = 1:nSubj
    for c = 1:length(condition)
        idx = strcmp(data(s).cond, condition(c));
        state = data(s).s(idx);
        action = data(s).a(idx);
        rt = data(s).rt(idx);
        avgRT(s,c) = nanmean(rt);
        if contains(condition(c),'4'); condIdx = 1; end
        if contains(condition(c),'6'); condIdx = 2; end
        pos = find(state==chunkInit(condIdx))+1; pos(pos>length(state))=[];
        rtChunkCorr(s,c) = nanmean(rt(intersect(find(state == action), pos)));
    end
end

hold on;
entry = 7;
scatter(complexity(:,entry), avgRT(:,entry), 120, 'filled', 'MarkerFaceColor', '#0072BD');
polycoef = polyfit(complexity(:,entry), avgRT(:,entry), 2);
X = linspace(0, 1.55, 100);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p1 = plot(X, Y, 'Color', '#0072BD', 'LineWidth', 4);

entry = 8;
scatter(complexity(:,entry), avgRT(:,entry), 120, 'filled', 'MarkerFaceColor', '#D95319');
polycoef = polyfit(complexity(:,entry), avgRT(:,entry), 2);
X = linspace(0, 1.55, 100);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p2 = plot(X, Y, 'Color', '#D95319', 'LineWidth', 4);

legend([p1 p2], {'Ns=4 Baseline','Ns=6 Baseline'}, 'Location', 'northeast');
legend('boxoff');
%xlim([0 1.62]); ylim([0.6, 1.0]);
xlabel('Policy complexity'); ylabel('Average RT');

%% Correlation between RT and policy complexity

% average & intrachunk for Perform & Test
avgRT_test = horzcat([avgRT(:,3); avgRT(:,4)], [avgRT(:,7); avgRT(:,8)]);
intraRT_test = horzcat([rtChunkCorr(:,3); rtChunkCorr(:,4)], [rtChunkCorr(:,7); rtChunkCorr(:,8)]);
% policy complexity for Perform & Test
complx_test = horzcat([complexity(:,3); complexity(:,4)], [complexity(:,7); complexity(:,8)]);

% test for correlation between RT & Complexity in Perform & Test
% Pearson correlation coefficient assumes normality
[r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Pearson')
[r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Pearson')
[r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Pearson')
[r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Pearson')

% Magnitude of Spearman's correlation coefficient doesn't indicate strength
% of correlation becasue it's a rank test
[r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Spearman')
[r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Spearman')
[r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Spearman')
[r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Spearman')

% Kendall's tau measures the degree of concordance 
[r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Kendall')
[r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Kendall')
[r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Kendall')
[r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Kendall')


% average & intrachunk for Baseline & Train
avgRT_test = horzcat([avgRT(:,1); avgRT(:,2)], [avgRT(:,5); avgRT(:,6)]);
intraRT_test = horzcat([rtChunkCorr(:,1); rtChunkCorr(:,2)], [rtChunkCorr(:,5); rtChunkCorr(:,6)]);
% policy complexity for Perform & Test
complx_test = horzcat([complexity(:,1); complexity(:,2)], [complexity(:,5); complexity(:,6)]);

% Pearson correlation coefficient assumes normality
[r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Pearson')
[r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Pearson')
[r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Pearson')
[r,p] = corr(intraRT_test(~isnan(intraRT_test(:,2)),2), complx_test(~isnan(intraRT_test(:,2)),2), 'Type', 'Pearson')

%% Test if people show reduction in policy complexity from Random to Structured
[h,p] = ttest2(complexity(:,1), complexity(:,2), 'tail', 'right')
[h,p] = ttest2(complexity(:,3), complexity(:,4), 'tail', 'left')
[h,p] = ttest2(complexity(:,5), complexity(:,6), 'tail', 'right')
[h,p] = ttest2(complexity(:,7), complexity(:,8), 'tail', 'left')
[h,p] = ttest2(complexity(:,1)-complexity(:,2), complexity(:,5)-complexity(:,6), 'tail', 'left')
%% RT-Complexity Curve
hold on;
entry = [6 5];
scatter(complexity(:,entry(1))-complexity(:,entry(2)), avgRT(:,entry(1))-avgRT(:,entry(2)), 120, 'filled', 'MarkerFaceColor', '#77AC30');
polycoef = polyfit(complexity(:,entry(1))-complexity(:,entry(2)), avgRT(:,entry(1))-avgRT(:,entry(2)), 2);
X = linspace(-0.5, 0.4, 100);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p1 = plot(X, Y, 'Color', '#77AC30', 'LineWidth', 4);
xlim([-0.5 0.4]);

hold on; entry = [2 1];
scatter(complexity(:,entry(1))-complexity(:,entry(2)), avgRT(:,entry(1))-avgRT(:,entry(2)), 120, 'filled', 'MarkerFaceColor', '#77AC30');
polycoef = polyfit(complexity(:,entry(1))-complexity(:,entry(2)), avgRT(:,entry(1))-avgRT(:,entry(2)), 2);
X = linspace(-0.5, 0.4, 100);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p1 = plot(X, Y, 'Color', '#77AC30', 'LineWidth', 4);
ylim([-300 80]);


legend([p1 p2], {'Ns=4 Baseline','Ns=6 Baseline'}, 'Location', 'northeast');
legend('boxoff');
%xlim([0 1.62]); ylim([0.6, 1.0]);
xlabel('Policy complexity'); ylabel('Average RT');

%% Raincloud plot of policy complexity
%addpath('/Users/ann/Desktop/CCN_Lab/BehavioralExperiment/Ns6_FinalVersion/RainCloudPlots-master/tutorial_matlab/cbrewer');
%addpath('/RainCloudPlots-master/tutorial_matlab/Robust_Statistical_Toolbox-master');
%[cb] = cbrewer("qual", "Set3", 12, "pchip");

figure; 
colororder(bmap);
h1 = raincloud_plot(complexity(:,1), 'color', bmap(1,:),'alpha', 0.7,  'box_dodge', 1,  'cloud_edge_col', bmap(1,:),...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', 0.15, 'box_col_match', 0, ...
    'line_width', 3);

h2 = raincloud_plot(complexity(:,2), 'color', bmap(2,:),'alpha', 0.7, 'box_dodge', 1, 'cloud_edge_col', bmap(2,:),...
    'box_on', 1, 'box_dodge', 1,  'box_dodge_amount', .35, 'dot_dodge_amount', 0.35, 'box_col_match', 0,...
    'line_width', 3);
%title(['Ns4 Random Train VS Structured Train']);
legend([h1{1} h2{1}], {'Ns=4 Random Train','Ns=4 Structured Train'}, 'location', 'northwest');
legend('boxoff');
set(gca, 'XLim', [0.2 1.8]);
ax = gca; ax.YAxis.Visible = 'off';
box off;

figure; 
colororder(bmap);
h1 = raincloud_plot(complexity(:,4), 'color', bmap(4,:),'alpha', 0.8,  'box_dodge', 1,  'cloud_edge_col', bmap(4,:),...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', 0.15, 'box_col_match', 0, ...
    'line_width', 3);

h2 = raincloud_plot(complexity(:,3), 'color', bmap(3,:),'alpha', 0.8, 'box_dodge', 1, 'cloud_edge_col', bmap(3,:),...
    'box_on', 1, 'box_dodge', 1,  'box_dodge_amount', .35, 'dot_dodge_amount', 0.35, 'box_col_match', 0,...
    'line_width', 3);
%title(['Ns4 Random Train VS Structured Train']);
legend([h1{1} h2{1}], {'Ns=4 Random Test','Ns=4 Structured Test'}, 'location', 'northwest');
legend('boxoff');
set(gca, 'XLim', [0.2 1.8]);
ax = gca; ax.YAxis.Visible = 'off';
box off;

figure;
colororder(bmap);
h1 = raincloud_plot(complexity(:,5), 'color', bmap(1,:),'alpha', 0.7,  'box_dodge', 1,  'cloud_edge_col', bmap(1,:),...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', 0.15, 'box_col_match', 0, ...
    'line_width', 3);

h2 = raincloud_plot(complexity(:,6), 'color', bmap(2,:),'alpha', 0.7, 'box_dodge', 1, 'cloud_edge_col', bmap(2,:),...
    'box_on', 1, 'box_dodge', 1,  'box_dodge_amount', .35, 'dot_dodge_amount', 0.35, 'box_col_match', 0,...
    'line_width', 3);
%title(['Ns4 Random Train VS Structured Train']);
legend([h1{1} h2{1}], {'Ns=6 Random Train','Ns=6 Structured Train'}, 'location', 'northwest');
legend('boxoff');
set(gca, 'XLim', [0.2 1.8]);
ax = gca; ax.YAxis.Visible = 'off';
box off;

figure;
colororder(bmap);
h1 = raincloud_plot(complexity(:,8), 'color', bmap(4,:),'alpha', 0.8,  'box_dodge', 1,  'cloud_edge_col', bmap(4,:),...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', 0.15, 'box_col_match', 0, ...
    'line_width', 3);

h2 = raincloud_plot(complexity(:,7), 'color', bmap(3,:),'alpha', 0.8, 'box_dodge', 1, 'cloud_edge_col', bmap(3,:),...
    'box_on', 1, 'box_dodge', 1,  'box_dodge_amount', .35, 'dot_dodge_amount', 0.35, 'box_col_match', 0,...
    'line_width', 3);
%title(['Ns4 Random Train VS Structured Train']);
legend([h1{1} h2{1}], {'Ns=6 Random Test','Ns=6 Structured Test'}, 'location', 'northwest');
legend('boxoff');
set(gca, 'XLim', [0.2 1.8]);
ax = gca; ax.YAxis.Visible = 'off';
box off;
end


%%
function [reward, complexity] = calculateRPC(data, condition, manip, recode)
if recode
    complexity = recoded_policy_complexity(data, condition);
end

switch manip
    case 'regular'      
        reward = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                idx = strcmp(data(s).cond, condition(c));
                state = data(s).s(idx);
                action = data(s).a(idx);
                reward(s,c) = mean(state==action);
                if ~recode; complexity(s,c) = mutual_information(state,action); end
            end
        end

    case 'incentive_manip'
        reward = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                idx = strcmp(data(s).cond, condition(c));
                state = data(s).s(idx);
                action = data(s).a(idx);
                reward(s,c) = sum(data(s).r(idx));
                if ~recode; complexity(s,c) = mutual_information(state,action); end
            end
        end
        reward = reward ./ [160 160 120 120 200 200 150 150];
end
end

       