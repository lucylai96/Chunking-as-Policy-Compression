function err = test_MI
    
    % Compare mean squared error for Hutter estimator with and without
    % ground truth state probability
    
    alpha = 0.1;
    N = 100;
    pS = [0.2 0.8];
    pSA = [0.9 0.1; 0.1 0.9];
    for i = 1:N
        state(i) = fastrandsample(pS);
        action(i) = fastrandsample(pSA(state(i),:));
    end
    
    Itrue = sum(sum(pS.*pSA.*log(pSA./pS)));
    for rep = 1:50
        I = mutual_information(state,action,alpha);
        err(rep,1) = (I - Itrue).^2;                    % error estimating state probability
        I = mutual_information(state,action,alpha,pS);  % error with ground truth state probability
        err(rep,2) = (I - Itrue).^2;
    end
    
    mean(err)