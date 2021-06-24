function simdata = actor_critic_sim(agent, data)

if ~isfield(agent, 'beta')
    agent.beta = agent.beta0;
end

simdata = data;
cond = unique(data(1).cond);
for c = 1:length(cond)
    idx = find(strcmp(data.cond, cond(c));
    state = data.s(idx);
    corrchoice = data.corrchoice(idx);
    setsize = length(unique(state));    % number of distinct stimuli
    nA = setsize + 1;                   % number of distinct actions
    theta = zeros(setsize, nA);         % policy parameters
    V = zeros(setsize,1);               % state values
    Q = zeros(setsize,nA);              % state-action values
    beta = agent.beta;
    p = zeros(1,nA);                    % marginal action probabilities
    p(1:nA-1) = 1/(nA-1)-0.01; p(nA) = 0.01*(nA-1);                
    ecost = 0;
    
    for t = 1:length(state)
        s = state(t);
        d = beta * theta(s,:) + log(p);
        