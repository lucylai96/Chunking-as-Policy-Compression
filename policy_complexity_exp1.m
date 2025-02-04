function policy_complexity_exp1(plotCase, data)

%{
    Analyses and plottings related to policy complexity, including average
    policy complexity in different blocks, reward-complexity curves,
    and rain cloud plot of policy complexity distribution in different blocks.

    USAGE:
        policy_complexity_exp1("avgComplexity", data)
        policy_complexity_exp1("RC_curves", data)
        policy_complexity_exp1("RC_curves_without_scatter", data)
        policy_complexity_exp1("rainCloud_complexity", data)
    
    Input: "plotCase" is a string representing which plot to show; data is
    an optional input and can be the simulated data structure

    Called by: plot_all_figures()
%}


prettyplot;
load('actionChunk_data.mat');
bmap =[141 182 205
    255 140 105
    238 201 0
    155 205 155] / 255;

nSubj = length(data);
condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
    'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};

recode = 1;     % whether use recoded states to calculate policy complexity
maxreward = [80 80 60 60 120 120 90 90];
[reward, complexity] = calculateRPC(data, condition, recode, maxreward);

% Calculate average policy complexity for different blocks
avgComplx = reshape(mean(complexity,1), [4 2])';
sem = nanstd(complexity,1)/sqrt(nSubj);
sem = reshape(sem, [4 2])';

% Caclulate average RT / ICRT
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


figure; hold on;
subplot 131; hold on;
plot(complexity(:,4),rtChunkCorr(:,4),'.','MarkerSize', 30); xlabel('Policy Complexity'); ylabel('Intrachunk RT')
plot(complexity(:,8),rtChunkCorr(:,8),'.','MarkerSize', 30);
plot(complexity(:,[1 5]),rtChunkCorr(:,[1 5]),'.','MarkerSize', 30);
lsline;

subplot 132; hold on;
plot(complexity(:,1)-complexity(:,2),rtChunkCorr(:,1)./avgRT(:,1)-rtChunkCorr(:,2)./avgRT(:,2),'.','MarkerSize', 30) % Ns = 4, chunking (reduction in ICRT from random to structured train) predicted by a reduction in policy complexity
plot(complexity(:,5)-complexity(:,6),rtChunkCorr(:,5)./avgRT(:,5)-rtChunkCorr(:,6)./avgRT(:,6),'.','MarkerSize', 30) % Ns = 6, chunking (reduction in ICRT from random to structured train) vs beta (higher beta less chunking)
xlabel('Reduction in Policy Complexity (Random-Structured)')
ylabel('Reduction in Normalized ICRT (Random-Structured)')
title('Train')
legend('Ns = 4','Ns = 6')
lsline;

subplot 133; hold on;
plot(complexity(:,3)-complexity(:,4),(rtChunkCorr(:,3)./avgRT(:,3))-(rtChunkCorr(:,4)./avgRT(:,4)),'.','MarkerSize', 30) % Ns = 4, increase from structured to random test vs beta (should be
plot(complexity(:,7)-complexity(:,8),(rtChunkCorr(:,7)./avgRT(:,7))-(rtChunkCorr(:,8)./avgRT(:,8)),'.','MarkerSize', 30) % Ns = 6, increase from structured to random test vs beta (should be less increase with higher beta)
xlabel('Increase in Policy Complexity (Structured-Random)')
ylabel('Increase in Normalized ICRT (Structured-Random)')
legend('Ns = 4','Ns = 6')
title('Test')
lsline;

% load('matlab_data/model_fitting_all.mat')
% beta = results(5).x(:,1);
% figure; hold on;
% plot(beta,complexity,'.','MarkerSize', 30)
% 
% beta = results(6).x(:,1);
% figure; hold on;
% plot(beta,complexity,'.','MarkerSize', 30)
why
switch plotCase
    %% Plot average policy complexity for different blocks
    case "avgComplexity"
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
        legend('Structured Test', 'Random Test','Location', 'northwest'); legend('boxoff');
        ylabel('Policy Complexity');
        exportgraphics(gcf,[pwd '/figures/complexity_test.png']);
        
        
        
        
        %% Plot reward-complexity curve
    case "RC_curves"    % Plot reward-complexity curve
        plot_RPCcurve(reward, complexity, [1 2], {'Ns=4, Random Train', 'Ns=4, Structured Train'});
        plot_RPCcurve(reward, complexity, [5 6], {'Ns=6, Random Train', 'Ns=6, Structured Train'});
        plot_RPCcurve(reward, complexity, [3 4], {'Ns=4, Structured Test', 'Ns=4, Random Test'});
        plot_RPCcurve(reward, complexity, [7 8], {'Ns=6, Structured Test', 'Ns=6, Random Test'});
        
        
        %% Plot reward-complexity curve without scatter plots
    case "RC_curves_without_scatter"
        entrySet = [1 2 5 6];
        figure; hold on;
        for i = 1:length(entrySet)
            polycoef = polyfit(complexity(:,entrySet(i)), reward(:,entrySet(i)), 2);
            X = linspace(0.6, 1.4, 80);
            Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
            color_row = entrySet(i)-idivide(entrySet(i),int8(4))*4;
            p(i) = plot(X, Y, 'Color', bmap(color_row,:), 'LineWidth', 5);
        end
        p(3).LineStyle = '--'; p(4).LineStyle = '--';
        legend('Ns=4, Random Train', 'Ns=4, Structured Train', 'Ns=6, Random Train', 'Ns=6, Structured Train',...
            'location', 'southeast'); legend('boxoff');
        ylim([0 1]); xlabel('Policy Complexity'); ylabel('Average Reward');
        
        
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
        
        
        %% Raincloud plot of policy complexity
    case "rainCloud_complexity"
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
        
        %% Scatter plot degree of chunking VS policy compression
    case "scatter_deltaRT_VS_compression"
        conds = {'Ns4,baseline', 'Ns4,train','Ns6,baseline', 'Ns6,train'};
        chunkRT = zeros(nSubj, length(conds));
        chunkInit = [2,5];
        for s = 1:nSubj
            for c = 1:length(conds)
                idx = strcmp(data(s).cond, conds{c});
                state = data(s).s(idx);
                action = data(s).a(idx);
                rt = data(s).rt(idx);
                if contains(conds(c),'4')
                    condIdx = 1;
                elseif contains(conds(c), '6')
                    condIdx = 2;
                end
                pos = find(state==chunkInit(condIdx))+1; pos(pos>length(state))=[];
                chunkRT(s,c) = nanmean(rt(intersect(find(state == action), pos)));
            end
        end
        
        % delta ICRT
        deltaICRT(:,1) = chunkRT(:,1)-chunkRT(:,2); deltaICRT(:,2) = chunkRT(:,3)-chunkRT(:,4);
        
        % policy compression
        deltaComplexity(:,1) = complexity(:,1)-complexity(:,2); deltaComplexity(:,2) = complexity(:,5)-complexity(:,6);
        
        figure; hold on;
        scatter(deltaComplexity(:,1), deltaICRT(:,1), 120, 'filled');
        xline(0, '--'); yline(0, '--');
        
        scatter(deltaComplexity(:,2), deltaICRT(:,2), 120, 'filled');
        [r, p] = corrcoef(deltaICRT(:,1), deltaComplexity(:,1));
        [r, p] = corrcoef(deltaICRT(:,2), deltaComplexity(:,2));
        
        
        %% Plot RT-Complexity curve
    case "RT_complexity_curves"
        figure; hold on;
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
        
        
        %% Change in reward VS policy complexity between Random and Structured block
    case "scatter_deltaR_deltaComplexity"
        for i = 1:4
            reward_diff(:,i) = reward(:,2*i) - reward(:,2*i-1);
            complexity_diff(:,i) = complexity(:,2*i) - complexity(:,2*i-1);
        end
        figure;
        scatter(complexity_diff(:,1), reward_diff(:,1), 120,'filled'); %Ns6, Structured Test to Ns6, Random Test
end

end
