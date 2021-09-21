function time_on_task(data)
   
    %{
    Plot the average response time against the training length.
    
    USAGE: time_on_task()
    %}

    if nargin==0; load('actionChunk_data.mat'); end
    conditions = {{'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
                  {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
    nSubj = length(data);
    iter = nan(1,length(conditions{1}));
    for c = 1:length(conditions{1})
        cond = conditions{1};
        iter(c) = sum(data(1).s(strcmp(data(1).cond, cond{c}))==1);
    end
    cumIter = [0 cumsum(iter)];
    runningAvgRT = nan(length(conditions), sum(iter));
    runningSemRT = nan(length(conditions), sum(iter));
    setsizes = [4 6];

    for c = 1:length(conditions)
        conds = conditions{c};
        setsize = setsizes(c);
        for condIdx = 1:length(conditions{1})
            avgRT = nan(nSubj, setsize, iter(condIdx));
            for subj = 1:nSubj
                for s = 1:setsize 
                    avgRT(subj, s, :) = data(subj).rt(strcmp(data(subj).cond, conds(condIdx)) & data(subj).s==s);
                end
            end
            avgRT = squeeze(nanmean(avgRT, 2));
            runningAvgRT(c, cumIter(condIdx)+1:cumIter(condIdx+1)) = nanmean(avgRT, 1);
            runningSemRT(c, cumIter(condIdx)+1:cumIter(condIdx+1)) = nanstd(avgRT, 1) / sqrt(nSubj);
        end
    end

    %%
    prettyplot;
    runningAvgRT = movmean(runningAvgRT,4,2);

    figure;
    bmap = [139 101 8
            0 139 139] /255;
    colororder(bmap);
    plot(runningAvgRT', 'LineWidth', 4);
    legend('Ns=4', 'Ns=6'); legend('boxoff');
    ylabel('Average RT'); xlabel('Task Progression');
    title('Dynamics of Response Time')
    set(gca, 'XTick',cumIter+1, 'XTickLabel', {'Structured Train','Structred Test', 'Random Test'});
    box off;

    figure;colororder(bmap);
    plot(runningAvgRT(:,1:20)', 'LineWidth', 4);
    legend('Ns=4', 'Ns=6'); legend('boxoff');
    title('Structured Train');
    xlabel('Iterations/stimulus');ylabel('Average RT'); box off;
    box off;

    figure;colororder(bmap);
    plot(runningAvgRT(:,21:35)', 'LineWidth', 4);
    legend('Ns=4', 'Ns=6'); legend('boxoff');
    title('Structured Test')
    xlabel('Iterations/stimulus');ylabel('Average RT'); box off;
    box off;

    figure;colororder(bmap);
    plot(runningAvgRT(:,36:50)', 'LineWidth', 4);
    legend('Ns=4', 'Ns=6'); legend('boxoff');
    title('Random Test');
    xlabel('Iterations/stimulus');ylabel('Average RT'); box off;
    box off;
    
end