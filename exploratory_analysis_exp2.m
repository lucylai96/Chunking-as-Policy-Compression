function exploratory_analysis_exp2(plotCase, data)
% all of model independent analysis for exp 2
% can plot diff analysis

prettyplot;
if nargin<2; load('load_incentive_data.mat'); end
nSubj = length(data);
threshold = 0.4;   % lowest accuracy in each block
condition = {'structured_normal', 'structured_load', 'structured_incentive'};
    
%%
switch plotCase
    case 'avgAcc'
    %%
        acc = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                accData = data(s).s == data(s).a;
                acc(s,c) = nanmean(accData(strcmp(data(s).cond, condition{c})));
            end
        end
        
        idx = ones(nSubj, 1);
        for c = 1:length(condition)
            idx = idx & acc(:,c)>threshold;
        end
        acc = acc(idx,:);
        sem = nanstd(acc,1) / sqrt(nSubj);
        
        figure; hold on;
        X = 1:length(condition);
        bar(X, mean(acc,1));
        errorbar(X, mean(acc,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        ylim([0 1]);
        set(gca, 'XTick',X, 'XTickLabel', condition);
        xlabel('Block'); ylabel('Average accuracy');
        exportgraphics(gcf,[pwd '/figures_load_incentive/avgAcc.png']);


    case 'avgRT'
    %%
        rt = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                rtData = data(s).rt;
                rt(s,c) = nanmean(rtData(strcmp(data(s).cond, condition(c))));
            end
        end
        sem = nanstd(rt,1) / sqrt(nSubj);
        
        figure; hold on;
        X = 1:length(condition);
        bar(X, mean(rt,1));
        errorbar(X, mean(rt,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        set(gca, 'XTick',X, 'XTickLabel', condition);
        xlabel('Block'); ylabel('Average RT (ms)');
        exportgraphics(gcf,[pwd '/figures_load_incentive/avgRT.png']);
        
    
    case 'intrachunkRT'
    %%
        rtChunkCorr = zeros(nSubj, length(condition));
        intra_s = 1;
        for s = 1:nSubj
            for c = 1:length(condition)
                idx = strcmp(data(s).cond, condition(c));
                state = data(s).s(idx);
                action = data(s).a(idx);
                rt = data(s).rt(idx);
                rtChunkCorr(s,c) = nanmean(rt(state==1 & action==1));
            end
        end
        sem = nanstd(rtChunkCorr,1) / sqrt(nSubj);

        figure; hold on;
        X = 1:length(condition);
        bar(X, mean(rtChunkCorr,1));
        errorbar(X, mean(rtChunkCorr,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        set(gca, 'XTick',X, 'XTickLabel', condition);
        xlabel('Block'); ylabel('Intrachunk RT (ms)');
        exportgraphics(gcf,[pwd '/figures_load_incentive/intrachunkRT_train.png'])
        
end        
           
end