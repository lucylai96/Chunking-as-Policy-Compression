function analyze_simdata()

load('actionChunk_data.mat');
%load('fixed_adaptive_chunk');
condition = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
             'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};
bmap = [141 182 205    
        255 140 105
        238 201 0  
        155 205 155] / 255;         
    
%% Simulate data
incentive_manip = 0; 

if incentive_manip  % simulate data under incentive manipulation for Ns=4
    manipulation = [eye(4), transpose([0 1 0 0])];
    manipulation(1,1) = 5;
    incentives{3} = manipulation;
    simdata = sim_incentive_manipulation(incentives, 4);
else                % simulate data under regular reward scheme
    simdata = sim_from_empirical();    
end


%% Exploratory Analysis
learning_curve(simdata);
exploratory_analysis_exp1('avgAcc', simdata);
           

%% The probability of using chunks VS primitive action
nSubj = length(simdata);
times = zeros(nSubj, length(condition));
timesInit = zeros(nSubj, length(condition));
for subj = 1:nSubj
    for cond = 1:length(condition)
        idx = strcmp(simdata(subj).cond, condition{cond});
        state = simdata(subj).s(idx);
        if length(unique(state))==4; init = 2; end
        if length(unique(state))==6; init = 5; end
        times(subj,cond) = sum(simdata(subj).chunkStep(idx)==1);
        timesInit(subj, cond) = sum(simdata(subj).s(idx)==init & simdata(subj).chunkStep(idx)==1);  
    end
end


X = 1:2;
Y = mean(timesInit,1); 
Y = Y ./ repmat([20 20 15 15],[1 2]);
Y = transpose(reshape(Y, [4 2]));
sem = nanstd(timesInit./repmat([20 20 15 15],[1 2]),1)/sqrt(nSubj) ; sem = transpose(reshape(sem, [4 2]));
labels = {'Random Train', 'Structured Train', 'Random Test', 'Structured Test'};

figure; 
colororder(bmap); hold on;
b = bar(X, Y, 'CData', bmap);
errorbar_pos = errorbarPosition(b, sem);
errorbar(errorbar_pos', Y, sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
legend(labels, 'Location', 'northeast');
legend('boxoff');
set(gca, 'XTick',1:2, 'XTickLabel', {'Ns=4', 'Ns=6'});
xlabel('Set size'); ylabel('P(choose C|S_{init})');
box off;



%% Alternative way of calculating P(C|S)
nSubj = length(simdata);
pCS = zeros(nSubj, length(condition));
pAS = zeros(nSubj, length(condition));
for subj = 1:nSubj
    for cond = 1:length(condition)
        idx = strcmp(simdata(subj).cond, condition{cond});
        state = simdata(subj).s(idx);
        if length(unique(state))==4; init = 2; end
        if length(unique(state))==6; init = 5; end
        pCS(subj,cond) = sum(simdata(subj).inChunk(idx)==1 & state==init) / sum(state==init);
        pAS(subj,cond) = sum(simdata(subj).inChunk(idx)==0 & simdata(subj).a(idx)==init & state==init) / sum(state==init);
    end
end


%% Cumulative cost (WRONG WAY OF CALCULATING THE ECOST)
bmap = plmColors(length(condition)/2, 'pastel1');
cumcost = cell(length(simdata), length(condition));
avgcumcost = cell(1, length(condition));
for cond = 1:length(condition)
    for subj = 1:length(simdata)
        cumcost{subj, cond} = cumsum(simdata(subj).cost(strcmp(simdata(subj).cond, condition{cond})));
        if isempty(avgcumcost{cond}); avgcumcost{cond} = zeros(1, length(cumcost{subj,cond})); end
        avgcumcost{cond} = avgcumcost{cond} + cumcost{subj, cond};
    end
    avgcumcost{cond} = avgcumcost{cond} / length(simdata);
end

for i = 1:2
    figure; hold on;
    plot(avgcumcost{4*(i-1)+1}, 'linewidth', 4);
    plot(avgcumcost{4*(i-1)+2}, 'linewidth', 4);
    plot(avgcumcost{4*(i-1)+4}, 'linewidth', 4);
    plot(avgcumcost{4*(i-1)+3}, 'linewidth', 4);
    xlabel('Iterations'); ylabel('Cumulative cost');
    legend('Random Train', 'Structured Train', 'Random Test', 'Structured Test', 'location','northwest');
    legend('boxoff');
    if i==1; title('Ns=4'); end
    if i==2; title('Ns=6'); end
end

