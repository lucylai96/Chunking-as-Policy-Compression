function statisticalTests_setsize()

    %{
    Perform statistical tests on the set size manipulation experiment data
    %}

    load('actionChunk_data.mat');
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
    
    %% Statistical tests for intrachunk RT reduction

    [h,p] = ttest2(rtChunkCorr(:,1), rtChunkCorr(:,2), 'tail', 'right')
    [h,p] = ttest2(rtChunkCorr(:,5), rtChunkCorr(:,6), 'tail', 'right')
    [h,p] = ttest2(rtChunkCorr(:,3), rtChunkCorr(:,4), 'tail', 'right')
    [h,p] = ttest2(rtChunkCorr(:,7), rtChunkCorr(:,8), 'tail', 'left')
    
    %% Correlation between RT and policy complexity

    % average & intrachunk for Perform & Test
    avgRT_test = horzcat([avgRT(:,3); avgRT(:,4)], [avgRT(:,7); avgRT(:,8)]);
    intraRT_test = horzcat([rtChunkCorr(:,3); rtChunkCorr(:,4)], [rtChunkCorr(:,7); rtChunkCorr(:,8)]);
    % policy complexity for Perform & Test
    complx_test = horzcat([complexity(:,3); complexity(:,4)], [complexity(:,7); complexity(:,8)]);

    % test for correlation between RT & Complexity in Perform & Test
    % Pearson correlation coefficient assumes normality
    [r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Pearson');
    [r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Pearson');
    [r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Pearson');
    [r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Pearson');

    % Magnitude of Spearman's correlation coefficient doesn't indicate strength
    % of correlation becasue it's a rank test
    [r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Spearman');
    [r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Spearman');
    [r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Spearman');
    [r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Spearman');

    % Kendall's tau measures the degree of concordance 
    [r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Kendall');
    [r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Kendall');
    [r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Kendall');
    [r,p] = corr(intraRT_test(:,2), complx_test(:,2), 'Type', 'Kendall');


    % average & intrachunk for Baseline & Train
    avgRT_test = horzcat([avgRT(:,1); avgRT(:,2)], [avgRT(:,5); avgRT(:,6)]);
    intraRT_test = horzcat([rtChunkCorr(:,1); rtChunkCorr(:,2)], [rtChunkCorr(:,5); rtChunkCorr(:,6)]);
    % policy complexity for Perform & Test
    complx_test = horzcat([complexity(:,1); complexity(:,2)], [complexity(:,5); complexity(:,6)]);

    % Pearson correlation coefficient assumes normality
    [r,p] = corr(avgRT_test(:,1), complx_test(:,1), 'Type', 'Pearson');
    [r,p] = corr(avgRT_test(:,2), complx_test(:,2), 'Type', 'Pearson');
    [r,p] = corr(intraRT_test(:,1), complx_test(:,1), 'Type', 'Pearson');
    [r,p] = corr(intraRT_test(~isnan(intraRT_test(:,2)),2), complx_test(~isnan(intraRT_test(:,2)),2), 'Type', 'Pearson');

    %% Test if people show reduction in policy complexity from Random to Structured

    [h,p] = ttest2(complexity(:,1), complexity(:,2), 'tail', 'right');
    [h,p] = ttest2(complexity(:,3), complexity(:,4), 'tail', 'left');
    [h,p] = ttest2(complexity(:,5), complexity(:,6), 'tail', 'right');
    [h,p] = ttest2(complexity(:,7), complexity(:,8), 'tail', 'left');
    [h,p] = ttest2(complexity(:,1)-complexity(:,2), complexity(:,5)-complexity(:,6), 'tail', 'left');
