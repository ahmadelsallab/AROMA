function LM_startLearningProcessRAE(cTestData, vTestTargets, cTrainData, vTrainTargets, cTrainKids, cTestKids, nDictionaryLength)
    clear, clc;

    % Load minFunc
    addpath(genpath('tools/'))

    % Load configurations
    CONFIG_strParams;

    %%%%%%%%%%%%%%%%%%%%%%
    % Initialize parameters
    %%%%%%%%%%%%%%%%%%%%%%
    vRAEWeights = NM_initializeRAEParameters(CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);

    index_list_train = cell2mat(cTrainData');
    freq_train = histc(index_list_train,1:size(We,2));
    
    freq_train = freq_train/sum(freq_train);
        
    CONFIG_strParams.RAEParams.nCategorySize=1;% for multinomial distributions this would be >1
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
        
    [vRAEWeights, cost] = minFunc( @(p)UNSUP_trainRAE(p, CONFIG_strParams.RAEParams.nAlphaCat, CONFIG_strParams.RAEParams.nCategorySize,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        CONFIG_strParams.RAEParams.nLambda, We, cTrainData, vTrainTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime), ...
        vRAEWeights, CONFIG_strParams.RAEParams.Options);
    
    
    [W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);
    
    save(['../output/ATB/savedParams_CV' num2str(CONFIG_strParams.RAEParams.CVNUM) '.mat'],'vRAEWeights','CONFIG_strParams.RAEParams','CONFIG_strParams.RAEParams.Options');
    
    [vSoftmaxWeights] = SUP_trainSoftmaxWithRAE(cTrainData, vTrainTargets, cTrainKids, vInitWeights, nDictionaryLength);
        
    % Train perofrmance
    [nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score, vTrainPredictedTargets] = TST_computeClassificationErrorRAE(cTrainData, vTrainTargets, vSoftmaxWeights, vRAEWeights, nDictionaryLength, 'Training');

    % Test performance
    [nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score, vTestPredictedTargets] = TST_computeClassificationErrorRAE(cTestData, vTestTargets, vSoftmaxWeights, vRAEWeights, nDictionaryLength, 'Testing');

    % Print results    
    fid = fopen(CONFIG_strParams.sResultsFile,'a');
    fprintf(fid,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.lambda(1)),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(CONFIG_strParams.RAEParams.maxIter)]);

    fprintf(fid,',train,%f,%f,%f,%f',nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score);
    fprintf(fid,',test,%f,%f,%f,%f',nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score);

    fprintf(1,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.lambda(1)),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(options.maxIter)]);

    fprintf(1,',train,%f,%f,%f,%f',nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score);
    fprintf(1,',test,%f,%f,%f,%f',nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score);

    fclose(fid);    

end % end function