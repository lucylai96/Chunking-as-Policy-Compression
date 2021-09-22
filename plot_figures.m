function plot_figures(fig)

% Figure Plan
% Figure 1:[expt 1] task, learning curves
% Figure 2: [expt 1] ICRT analyses: greater reduction of ICRT in high vs low load, increase in ICRT when chunk broken
% Figure 3: [expt 1] chunking reduces policy complexity
% Figure 4: model fit / simulations / comparison
% Figure 5: [expt 2] task and toy figure of simulated model predictions to load and incentive manipulation
% Figure 6: [expt 2] data confirming simulations from experiment 2
% Figure 7: [expt 2] psychopathology analyses
prettyplot;
if nargin==1; load('actionChunk_data.mat'); end
nSubj = length(data);

condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test',...
    'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};

bmap =[141 182 205
    255 140 105
    238 201 0
    155 205 155]/255;

rtChunkCorr = zeros(nSubj, length(condition));
chunkInit = [2,5];
for s = 1:nSubj
    for c = 1:length(condition)
        idx = strcmp(data(s).cond, condition(c));
        state = data(s).s(idx);
        action = data(s).a(idx);
        rt = data(s).rt(idx);
        if contains(condition(c),'4')
            condIdx = 1;
        elseif contains(condition(c), '6')
            condIdx = 2;
        end
        pos = find(state==chunkInit(condIdx))+1; pos(pos>length(state))=[];
        rtChunkCorr(s,c) = nanmean(rt(intersect(find(state == action), pos)));
    end
end

switch fig
    
    case 'task' % Figure 1:[expt 1] task, learning curves
        figure; hold on;
        subplot 121; hold on;
        %map =  [16 78 139
        %    165 42 42] /255;
        map = [141 182 205
            255 140 105]/255;
        stateConds = {'Ns4,baseline', 'Ns4,train', 'Ns6,baseline', 'Ns6,train'};
        nSubj = length(data);
        nPresent = sum(data(1).s(strcmp(data(1).cond, stateConds{1}))==1);
        
        accuracy = nan(length(stateConds), nSubj, nPresent);
        for s = 1:nSubj
            for condIdx = 1:length(stateConds)
                states = data(s).s(strcmp(data(s).cond, stateConds{condIdx}));
                acc = data(s).acc(strcmp(data(s).cond, stateConds{condIdx}));
                acc_by_nPres = nan(length(unique(states)), nPresent);
                for i = 1:length(unique(states))
                    acc_by_nPres(i,:) = acc(states==i);
                end
                accuracy(condIdx,s,:) = nanmean(acc_by_nPres, 1);
            end
        end
        
        avgAccuracy = squeeze(nanmean(accuracy, 2));
        X = 1:nPresent;
        for i = 1:2
            plot(X, avgAccuracy(i,:), 'Color', map(i,:), 'LineWidth', 3.5);
        end
        for i = 3:4
            plot(X, avgAccuracy(i,:), '-.','Color', map(i-2,:), 'LineWidth', 3.5);
        end
        legend({'Ns=4 Random Train', 'Ns=4 Structured Train', 'Ns=6 Random Train',...
            'Ns=6 Structured Train'}, 'Location', 'southeast');
        legend('boxoff');
        xlabel('Number of Iteration'); ylabel('Average Accuracy');
        title('Learning Curve');
        
        
        subplot 122; hold on;
        acc = nan(nSubj, length(condition));
        sem = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                %accData = data(s).acc;
                accData = data(s).s == data(s).a;
                acc(s,c) = nanmean(accData(strcmp(data(s).cond, condition(c))));
            end
        end
        
        colororder(bmap);
        X = 1:2;
        tmp = mean(acc,1); plotAcc(1,:) = tmp(1:length(condition)/2); plotAcc(2,:) = tmp(length(condition)/2+1:length(condition));
        b = bar(X, plotAcc, 'CData', bmap);
        sem = nanstd(acc, 1)/sqrt(nSubj) ; sem = transpose(reshape(sem, [4 2]));
        errorbar_pos = errorbarPosition(b, sem);
        errorbar(errorbar_pos', plotAcc, min(sem,1-plotAcc), sem, 'k','linestyle','none', 'lineWidth', 1.2);
        ylim([0 1]);
        lgd = legend('Random Train', 'Structured Train', 'Structured Test', 'Random Test', 'Location', 'north');
        legend('boxoff');
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Average accuracy');
        %exportgraphics(gcf,[pwd '/figures/avgAcc.png']);
        
        
    case 'icrt' % Figure 2: [expt 1] ICRT analyses: greater reduction of ICRT in high vs low load, increase in ICRT when chunk broken
        
        
        figure; hold on; colororder(bmap);
        tmp = nanmean(rtChunkCorr,1); plotRTChunk(1,:) = tmp(1:length(condition)/2); plotRTChunk(2,:) = tmp(length(condition)/2+1:length(condition));
        sem = nanstd(rtChunkCorr, 1) / sqrt(nSubj); sem = transpose(reshape(sem, [4 2]));
        b = bar([1 2], plotRTChunk);
        errorbar_pos = errorbarPosition(b, sem);
        errorbar(errorbar_pos', plotRTChunk, sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        legend('Random Train', 'Structured Train', 'Structured Test', 'Random Test', 'Location', 'northwest'); legend('boxoff');
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Intrachunk Response Time');
        
        %exportgraphics(gcf,[pwd '/figures/intrachunkRT.png'])
        
    case 'chunk'% Figure 3: [expt 1] chunking reduces policy complexity
        
        nSubj = length(data);
        condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
            'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};
        
        recode = 1;     % whether use recoded states to calculate policy complexity
        maxreward = [80 80 60 60 120 120 90 90];
        [reward, complexity] = calculateRPC(data, condition, recode, maxreward);
        
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
        
        %% Hick's Law (policy complexity scales with reaction time, should be true in first expt)
        figure; hold on;
        subplot 131; hold on; box off
        plot(complexity(:), avgRT(:),'k.','MarkerSize',30); lsline; axis tight
        [R,P] = corr(complexity(:), avgRT(:), 'Type', 'Pearson')
        text(0.1,1200,strcat('R = ',num2str(R)),'FontSize',14)
        text(0.1,1100,strcat('p = ',num2str(P)),'FontSize',14)
        xlabel('Policy Complexity')
        ylabel('Reaction Time (ms)')
        
        
        %% Average policy complexity for different blocks
        avgComplx = reshape(mean(complexity,1), [4 2])';
        sem = nanstd(complexity,1)/sqrt(nSubj);
        sem = reshape(sem, [4 2])';
        
        subplot 132;hold on;
        colororder(bmap);
        b = bar(avgComplx);
        errorbar_pos = errorbarPosition(b, sem);
        errorbar(errorbar_pos', avgComplx, sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        ylabel('Policy Complexity');
        legend('Random Train', 'Structured Train','Structured Test', 'Random Test','Location', 'northwest'); legend('boxoff');
        %exportgraphics(gcf,[pwd '/figures/complexity_train.png'])
        
        %% Change in policy complexity (structured-random, structured-random)
        % correlate complexity w chunking (ICRT)
        subplot 133; hold on;
        delta_RT = [rtChunkCorr(:,2)'-rtChunkCorr(:,1)';
            rtChunkCorr(:,4)'-rtChunkCorr(:,3)';
            rtChunkCorr(:,6)'-rtChunkCorr(:,5)';
            rtChunkCorr(:,8)'-rtChunkCorr(:,7)']';
        delta_complexity = [complexity(:,2)'-complexity(:,1)';
            complexity(:,4)'-complexity(:,3)';
            complexity(:,6)'-complexity(:,5)';
            complexity(:,8)'-complexity(:,7)']';
        
        plot(delta_complexity,delta_RT,'.','MarkerSize',30);lsline
        plot(nanmean(delta_complexity),nanmean(delta_RT),'k.','MarkerSize',50);lsline
         ylabel('\Delta ICRT')
          xlabel('\Delta Policy Complexity')
          % increase in policy complexity predicts 
        
    case 'model' % Figure 4: model fit / simulations / comparison
        
    case 'predict' % Figure 5: [expt 2] task and toy figure of simulated model predictions to load and incentive manipulation
        
    case 'load_incentive' % Figure 6: [expt 2] data confirming simulations from experiment 2
        
    case 'psycho'% Figure 7: [expt 2] psychopathology analyses
        
end


end