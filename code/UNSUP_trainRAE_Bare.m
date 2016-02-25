function [cost_total,grad_total] = UNSUP_trainRAE_Bare(theta, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
    lambda, We_orig, data_cell, freq_orig, f, f_prime, allKids)

[~, ~, ~, ~, ~, ~, ~, Wcat, bcat, We] = NM_getRAEWeights(1, theta, hiddenSize, cat_size, dictionary_length);

szWe = length(We(:));
szbcat = length(bcat(:));
szWcat = length(Wcat(:));
theta1 = theta;
theta1(end-szWe+1:end) = We;
theta1(end-szWe-szbcat-szWcat+1:end-szWe) = [];


theta2 = theta;
theta2(end-szWe+1:end) = We_orig(:) + We(:);
lambda2 = lambda;
lambda(3) = lambda2(4);
lambda(4) = lambda2(3);

 global CONFIG_strParams;
 if(CONFIG_strParams.bKnownParsing)
     %load(preProFile, 'allKids');
     [costRAE, gradRAE, allKids] = UNSUP_computeCostAndGradRAE_Bare(allKids, theta1, 0, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
         (alpha_cat)*lambda, We_orig , data_cell, freq_orig, f, f_prime, 0);
 
 else
     [costRAE, gradRAE, allKids] = UNSUP_computeCostAndGradRAE_Bare([], theta1, 0, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
         (alpha_cat)*lambda, We_orig , data_cell, freq_orig, f, f_prime, 0);
 end


WegradRAE = gradRAE(end-szWe+1:end);
gradRAE(end-szWe+1:end) = 0;
gradRAE = [gradRAE; zeros(szbcat+szWcat,1)];
gradRAE(end-szWe+1:end) = WegradRAE;

cost_total =  costRAE;
grad_total =  gradRAE;
