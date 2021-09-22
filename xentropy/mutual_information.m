function I = mutual_information(state,action,alpha,pS)
    
    % Hutter estimator of mutual information.
    %
    % USAGE: I = mutual_information(state,action,[alpha],[pS])
    %
    % INPUTS:
    %   state - vector of states
    %   action - vector of actions
    %   alpha (optional) - concentration parameter (defaults to Perks prior)
    %   pS (optional) - vector of state probabilities
    %
    % OUTPUTS:
    %   I - mutual information estimate
    %
    % Sam Gershman, July 2021
    
    
    uS = unique(state);
    uA = unique(action);
    
    if nargin < 4 || isempty(pS)
        N = zeros(length(uS),length(uA));
        if nargin < 3 || isempty(alpha); alpha = 1/numel(N); end % Perks (1947) prior
        
        for s = 1:length(uS)
            for a = 1:length(uA)
                N(s,a) = alpha + sum(state==uS(s) & action==uA(a));
            end
        end
        
        n = sum(N(:));
        nA = sum(N);
        nS = sum(N,2);
        P = psi(N+1) - psi(nA+1) - psi(nS+1) + psi(n+1);
        I = sum(sum(N.*P))/n;
    else
        N = zeros(length(uS),length(uA));
        if nargin < 3 || isempty(alpha); alpha = 1/length(uA); end % Perks (1947) prior
        ix = find(pS>0);
        
        for s = ix
            for a = 1:length(uA)
                N(s,a) = alpha + sum(state==uS(s) & action==uA(a));
            end
        end
        
        nS = sum(N,2);
        P = psi(N(ix,:)+1) - psi(nS(ix,:)+1);
        I = pS(ix)*sum(N(ix,:).*P./nS,2) - sum(log(pS(ix))*pS(ix)');
    end