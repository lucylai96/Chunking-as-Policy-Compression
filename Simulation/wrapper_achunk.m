%% Wrapper function to simulate the experiment for diff state spaces
%% 
clear all;
rng(12);

withinChunkUpdate = 0;
stateSpace = [4 6];
beta = [0.5 1 1.5 2 2.5];
numBetas = length(beta);

agent.lrate_V = 0.15;
agent.lrate_p = 0.01;
agent.lrate_theta = 0.15;
agent.test = 1;

for i = 1:length(stateSpace)
    for b = 1:length(beta)
        agent.beta = beta(b);
        experiment(i,b) = actor_critic_sim(stateSpace(i), agent);
    end
end 

pAS = zeros(length(stateSpace), numBetas);
pCS = zeros(length(stateSpace), numBetas);
rt = zeros(length(stateSpace), numBetas, 2);

for i = 1:length(stateSpace)
    for j = 1:numBetas
        simdata = experiment(i,j);
        pAS(i,j) = simdata.chooseA3;
        pCS(i,j) = simdata.chooseC1;
        rt(i,j,1) = simdata.rt;
        rt(i,j,2)  = simdata.test.rt;
    end
end

%% Plot p(choose A|S), p(choose C|S)
%% 
bmap = plmColors(length(stateSpace), 'set2');
hold on;
bar(beta, pAS');
xlabel("\beta");
ylabel('p(choose A_3|S_3)');
legend('N=3','N=6','Location','north');    
legend('boxoff')
box off
exportgraphics(gcf,[pwd, '/figures/pAS', '.jpeg']);

bmap = plmColors(length(stateSpace), 'set2');
figure; hold on;
bar(beta, pCS');
xlabel("\beta");
ylabel('p(choose C|S_3)');
legend('N=3','N=6','Location','northeast');    
legend('boxoff')
box off
exportgraphics(gcf,[pwd, '/figures/pCS', '.jpeg']);

%% Stack plot
%%

pCS_stack = pCS ./ (pCS+pAS) / 5;
pAS_stack = pAS ./ (pCS+pAS) / 5;

bmap = plmColors(numBetas, 'b');
bar(categorical({'3' '6'}), pCS_stack,0.5, 'stacked');
xlabel("Number of primitive states");
ylabel('Normalized p(choose C|S_3)');
legend('\beta=0.5', '\beta=1', '\beta=1.5', '\beta=2', '\beta=2.5', 'Location','northwest')
legend('boxoff')
box off
exportgraphics(gcf,[pwd, '/figures/stack_pCS', '.jpeg']);

figure; hold on;
bmap = plmColors(numBetas, 'b');
bar(categorical({'3' '6'}), pAS_stack,0.5, 'stacked');
xlabel("Number of primitive states");
ylabel('Normalized p(choose A_3|S_3)');
legend('\beta=0.5', '\beta=1', '\beta=1.5', '\beta=2', '\beta=2.5', 'Location','northeast')
legend('boxoff')
box off
exportgraphics(gcf,[pwd, '/figures/stack_pAS', '.jpeg']);


%% Plot action slips
%% 
actionSlips = zeros(length(stateSpace), numBetas);
for i = 1:length(stateSpace)
    nS = stateSpace(i);
    for j = 1:numBetas
        simdata = experiment(i,j);
        actionSlips(i,j) = sum(simdata.test.state == chunk(1) & simdata.test.action==6)/sum(simdata.test.state == chunk(1));
    end
end

bmap = plmColors(length(stateSpace), 'set2');
figure; hold on;
bar(beta, actionSlips');
xlabel("\beta");
ylabel('% Action slips (Test)');
legend('N=3','N=6','Location','northeast');    
legend('boxoff')
box off

exportgraphics(gcf,[pwd, '/figures/actionSlips', '.jpeg']);


%% Average reaction time
%% 
figure; hold on;
rt_6 = squeeze(rt(:,:,2));


bar(beta, rt_6);
colorScheme = ['r' 'b'];
figure; hold on;
for j = 1:2
    bmap = plmColors(5,colorScheme(j));
    for i = 1:length(beta)
        kl(i) = mean([experiment(2,i).KL]);
        rt(i) = experiment(2,i);
        plot(mean([experiment(2,i).KL]),experiment(2,i).test.rt,'.','Color',bmap(i,:),'MarkerSize',50);
    end
    polynomial = polyfit(kl, rt);
    fitted = polyval(polynomial, kl);
    plot(kl, fitted, 'Color',plmColors(1,colorScheme(i)), 'LineWidth', 1);
end

legend({'','','','','','N=3','','','','','','N=6'}, 'Location', 'Southeast');
%% Reward Complexity Tradeoff
%%   
figure; hold on;
bmaps = ['b' 'r' 'g'];

for i = 1:length(stateSpace)
    bmap = plmColors(length(beta),bmaps(i));
    policy = zeros(1,length(beta));
    reward = zeros(1,length(beta));
    for j = 1:length(beta)
        policy(j) = mean([experiment(i,j).KL]);
        reward(j) = mean([experiment(i,j).reward]);
        plot(mean([experiment(i,j).KL]), mean([experiment(i,j).reward]),'.','Color',bmap(j,:),'MarkerSize',50);
    end
    polynomial = polyfit(policy, reward, 2);
    fitted = polyval(polynomial, policy);
    plot(policy, fitted, 'Color',plmColors(1,bmaps(i)), 'LineWidth', 1);
    %legend({'','','','','',['N=', int2str(stateSpace(i))]}, 'Location', 'Southeast');
    ylabel('Average reward')
    xlabel('Policy complexity')
    hold on;
     %plot(simdata(i).cost,simdata(i).reward,'o','Color',bmap(i,:),'MarkerSize',10); 
end

legend({'','','','','','N=3','','','','','','N=6'}, 'Location', 'Southeast');

legend('boxoff')
title(l,'\beta')
%prettyplot(20)

set(gcf, 'Position',  [500, 100, 1000, 500])

exportgraphics(gcf,[pwd, '/figures/rc_tradeoff', '.jpeg']);
