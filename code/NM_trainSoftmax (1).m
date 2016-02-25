function [vWeights] = NM_trainSoftmax(cFeatures, vTargets)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Logistic regression
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global CONFIG_strParams;
    t3 = 2; % concatenate the top representation with the average representation, so 2 (t3) * CONFIG_strParams.RAEParams.nEmbeddingSize (=50) = 100
    theta2 = -0.5+rand(2*t3*CONFIG_strParams.RAEParams.nEmbeddingSize*CONFIG_strParams.RAEParams.nCategorySize + CONFIG_strParams.RAEParams.nCategorySize,1);

    options2.Method = 'lbfgs';
    options2.maxIter = 1000;

    % Training
    [vWeights, cost] = minFunc( @(p) soft_cost(p,cFeatures, vTargets, 1e-6),theta2, options2);

end% end function