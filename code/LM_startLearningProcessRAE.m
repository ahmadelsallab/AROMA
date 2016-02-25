function LM_startLearningProcessRAE(cTestData, vTestTargets, cTrainData, vTrainTargets, cTrainKids, cTestKids, cUnsupervisedData, cUnsupervisedKids, nDictionaryLength)

    % Load minFunc
    addpath(genpath('tools/'))

    % Load configurations
    global CONFIG_strParams;

    %%%%%%%%%%%%%%%%%%%%%%
    % Initialize parameters
    %%%%%%%%%%%%%%%%%%%%%%
    vRAEWeights = NM_initializeRAEParameters(CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);

    [W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);
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
    if(CONFIG_strParams.sUnsupervisedWeDatasetPath ~= '')
        cUnsupervisedTrainData = [cTrainData; cUnsupervisedData];
        cKids = [cTrainKids; cUnsupervisedKids];
    else
        cUnsupervisedTrainData = cTrainData;
        cKids = cTrainKids;
    end
        

    if(CONFIG_strParams.bKnownParsing)
        [vRAEWeights, cost] = minFunc( @(p)UNSUP_trainRAE(p, CONFIG_strParams.RAEParams.nAlphaCat, CONFIG_strParams.RAEParams.nCategorySize,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
            CONFIG_strParams.RAEParams.nLambda, We, cUnsupervisedTrainData, vTrainTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, cKids), ...
            vRAEWeights, CONFIG_strParams.RAEParams.Options);
    else
        [vRAEWeights, cost] = minFunc( @(p)UNSUP_trainRAE(p, CONFIG_strParams.RAEParams.nAlphaCat, CONFIG_strParams.RAEParams.nCategorySize,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
            CONFIG_strParams.RAEParams.nLambda, We, cTrainData, vTrainTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, []), ...
            vRAEWeights, CONFIG_strParams.RAEParams.Options); 
       
    end
    
    [W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);
    
    save(['../output/ATB/savedParams_CV' num2str(CONFIG_strParams.RAEParams.CVNUM) '.mat'],'vRAEWeights','CONFIG_strParams');
    
    [vSoftmaxWeights] = SUP_trainSoftmaxWithRAE(cTrainData, vTrainTargets, cTrainKids, vRAEWeights, nDictionaryLength);
        
    % Train perofrmance
    [nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score, vTrainPredictedTargets] = TST_computeClassificationErrorRAE(cTrainData, vTrainTargets, cTrainKids, vSoftmaxWeights, vRAEWeights, nDictionaryLength, 'Training');

    % Test performance
    [nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score, vTestPredictedTargets] = TST_computeClassificationErrorRAE(cTestData, vTestTargets, cTestKids, vSoftmaxWeights, vRAEWeights, nDictionaryLength, 'Testing');

    % Print results    
    fid = fopen(CONFIG_strParams.sResultsFile,'a');
    fprintf(fid,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.nLambda(1)),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(CONFIG_strParams.nMaxIter)]);

    fprintf(fid,',train,%f,%f,%f,%f',nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score);
    fprintf(fid,',test,%f,%f,%f,%f',nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score);

    fprintf(1,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.nLambda(1)),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(CONFIG_strParams.nMaxIter)]);

    fprintf(1,',train,%f,%f,%f,%f',nTrainAccuracy, nTrainPrecision, nTrainRecall, nTrainF1Score);
    fprintf(1,',test,%f,%f,%f,%f',nTestAccuracy, nTestPrecision, nTestRecall, nTestF1Score);

    fclose(fid);    

    save(CONFIG_strParams.sRAETrainedParamsWorkspace, 'vRAEWeights', 'vSoftmaxWeights', 'nDictionaryLength');
end % end function