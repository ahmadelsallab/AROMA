function LM_startLearningProcessRAE(cTestData, vTestTargets, cTrainData, vTrainTargets, nDictionaryLength)
    clear, clc;

    % Load minFunc
    addpath(genpath('tools/'))

    % Load configurations
    CONFIG_strParams;

    %%%%%%%%%%%%%%%%%%%%%%
    % Initialize parameters
    %%%%%%%%%%%%%%%%%%%%%%
    theta = NM_initializeRAEParameters(CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nEmbeddingSize, cat_size, nDictionaryLength);

    index_list_train = cell2mat(cTrainData');
    freq_train = histc(index_list_train,1:size(We,2));
    
    freq_train = freq_train/sum(freq_train);
        
    cat_size=1;% for multinomial distributions this would be >1
    numExamples = length(cTrainData);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Parallelize if on cluster
    %%%%%%%%%%%%%%%%%%%%%%
    if isunix && matlabpool('size') == 0
        numCores = feature('numCores');
        if numCores==16
            numCores=8;
        end
        matlabpool('open', numCores);
    end


    %%%%%%%%%%%%%%%%%%%%%%
    % Train/Test Model
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Set unsupervised word embedding dataset
    snum_We = cTrainData; % TBD
        
    [opttheta, cost] = minFunc( @(p)UNSUP_trainRAE(p, CONFIG_strParams.RAEParams.nAlphaCat, cat_size,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        CONFIG_strParams.RAEParams.nLambda, We, cTrainData, vTrainTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime), ...
        theta, CONFIG_strParams.RAEParams.Options);
    theta = opttheta;
    
    [W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = getW(1, theta, CONFIG_strParams.RAEParams.nEmbeddingSize, cat_size, nDictionaryLength);
    
    save(['../output/ATB/savedParams_CV' num2str(CONFIG_strParams.RAEParams.CVNUM) '.mat'],'opttheta','CONFIG_strParams.RAEParams','CONFIG_strParams.RAEParams.Options');
    SUP_trainSoftmaxWithRAE
        

end % end function