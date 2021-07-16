function exploratoryAnalysis(data, plotCase)
prettyplot;
if nargin==0; load('actionChunk_data.mat'); end
nSubj = length(data);
%condition = unique(data(1).cond);
%condition(strcmp(condition, '')) = [];
condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test',...
    'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};

switch plotCase
    case 'avgAcc'
        acc = nan(nSubj, length(condition));
        sem = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                accData = data(s).acc;
                acc(s,c) = nanmean(accData(strcmp(data(s).cond, condition(c))));
            end
        end

        bmap = plmColors(length(condition)/2, 'pastel1');
        figure; hold on;
        X = 1:2;
        tmp = mean(acc,1); plotAcc(1,:) = tmp(1:length(condition)/2); plotAcc(2,:) = tmp(length(condition)/2+1:length(condition));
        b = bar(X, plotAcc);
        sem = nanstd(acc, 1)/sqrt(nSubj) ; sem = reshape(sem, [2 length(condition)/2]);
        errorbar_pos = errorbarPosition(b, sem);
        errorbar(errorbar_pos', plotAcc, min(sem,1-plotAcc), sem, 'k','linestyle','none', 'lineWidth', 1.2);
        ylim([0 1]);
        legend('Baseline', 'Train', 'Perform', 'Test', 'Location', 'north');
        legend('boxoff');
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Average accuracy');


    case 'avgRT'
        rt = nan(nSubj, length(condition));
        for s = 1:nSubj
            for c = 1:length(condition)
                rtData = data(s).rt;
                rt(s,c) = nanmean(rtData(strcmp(data(s).cond, condition(c))));
                sem(s,c) = nanstd(rtData(strcmp(data(s).cond, condition(c))));
                %rt_all{s,c} = rtData(strcmp(data(s).cond, condition(c)));
            end
        end

        bmap = plmColors(4, 'pastel1');
        hold on;
        tmp = mean(rt,1); plotRT(1,:) = tmp(1:length(condition)/2); plotRT(2,:) = tmp(length(condition)/2+1:length(condition));
        b = bar([1 2], plotRT);
        sem = nanstd(rt, 1)/sqrt(nSubj); sem = reshape(sem, [2 length(condition)/2]);
        errorbar_pos = errorbarPosition(b, sem);
        errorbar(errorbar_pos', plotRT, sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
        legend('Baseline', 'Train', 'Perform', 'Test', 'Location', 'north');
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Average Response Time');
   

    case 'actionSlips'
        actionSlip = zeros(nSubj, 2);
        slipCond = {'Ns4,test', 'Ns6,test'};
        slipPos = [2,5];
        chunkResp = [1,4];
        for s = 1:nSubj
            for c = 1:2
                state = data(s).s(strcmp(data(s).cond, slipCond(c)));
                action = data(s).a(strcmp(data(s).cond, slipCond(c)));
                pos = find(state==slipPos(c))+1;
                pos(pos>length(state))=[];
                actionSlip(s,c) = sum(state(pos)~=chunkResp(c) & action(pos)==chunkResp(c));
            end
        end

        X = [4,6];
        b = bar(X, sum(actionSlip,1));
        xtips = b.XEndPoints;
        ytips = b.YEndPoints;
        labels = string(b.YData);
        text(xtips, ytips, labels, 'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');

    case 'intachunkRT'
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

        bmap = plmColors(4, 'pastel1');
        figure; hold on;
        tmp = nanmean(rtChunkCorr,1); plotRTChunk(1,:) = tmp(1:length(condition)/2); plotRTChunk(2,:) = tmp(length(condition)/2+1:length(condition));
        sem = nanstd(rtChunkCorr, 1) / sqrt(nSubj); sem = reshape(sem, [2 4]);
        b = bar([1 2], plotRTChunk(:,1:2));
        errorbar_pos = errorbarPosition(b, sem(:,1:2));
        errorbar(errorbar_pos', plotRTChunk(:,1:2), sem(:,1:2), sem(:,1:2), 'k','linestyle','none', 'lineWidth', 1.2);
        legend('Baseline', 'Train', 'Location', 'northwest');  
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Intrachunk Response Time');

        bmap = plmColors(4, 'pastel1');
        figure; hold on;
        b = bar([1 2], plotRTChunk(:,3:4));
        errorbar_pos = errorbarPosition(b, sem(:,3:4));
        errorbar(errorbar_pos', plotRTChunk(:,3:4), sem(:,3:4), sem(:,3:4), 'k','linestyle','none', 'lineWidth', 1.2);
        legend('Perform', 'Test', 'Location', 'northwest');  
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
        xlabel('Set size'); ylabel('Intrachunk Response Time');
        
    
    case 'error_plot'
        cond = {'Ns4,test', 'Ns6,test'};
        chunkInit = [2 5];
        error = zeros(nSubj,2);
        slips = zeros(nSubj,2);
        reactionTime = nan(nSubj,2);
        for s = 1:nSubj
            for c = 1:length(cond)
                state = data(s).s(strcmp(data(s).cond, cond{c}));
                action = data(s).a(strcmp(data(s).cond, cond{c}));
                rt = data(s).rt(strcmp(data(s).cond, cond{c}));
                pos = find(state==chunkInit(c))+1; pos(pos>length(state))=[];
                slips(s,c) = sum(state(pos)~=action(pos) & action(pos)==chunkInit(c)-1);
                error(s,c) = sum(state(pos)~=action(pos))-slips(s,c);
                if ~isnan(rt(state(pos)~=action(pos))); reactionTime(s,c) = nanmean(rt(state(pos)~=action(pos)));end
            end
        end
        [h, p] = ttest2(slips(:,1)+error(:,1),slips(:,2)+error(:,2) , 'Tail', 'left');
        total_error = slips + error;
        hold on; bar([1 2], mean(total_error), 'stacked');
        errorbar(mean(total_error), std(total_error,1)/sqrt(nSubj), 'k','linestyle','none', 'lineWidth', 1.2);
        set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4,test', 'Ns=6,test'});
        ylabel('Average # of incorrect responses');
end        
           
end