function LM_startLearningProcessRAE_Bare(cTrainData, cTrainKids, cUnsupervisedData, cUnsupervisedKids, nDictionaryLength)

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
        [vRAEWeights, cost] = minFunc( @(p)UNSUP_trainRAE_Bare(p, CONFIG_strParams.RAEParams.nAlphaCat, CONFIG_strParams.RAEParams.nCategorySize,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
            CONFIG_strParams.RAEParams.nLambda, We, cUnsupervisedTrainData, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, cKids), ...
            vRAEWeights, CONFIG_strParams.RAEParams.Options);
    else
        [vRAEWeights, cost] = minFunc( @(p)UNSUP_trainRAE_Bare(p, CONFIG_strParams.RAEParams.nAlphaCat, CONFIG_strParams.RAEParams.nCategorySize,CONFIG_strParams.RAEParams.nBeta, nDictionaryLength, CONFIG_strParams.RAEParams.nEmbeddingSize, ...
            CONFIG_strParams.RAEParams.nLambda, We, cTrainData, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, []), ...
            vRAEWeights, CONFIG_strParams.RAEParams.Options);    
    end
    
    [W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);
    
    save(['../output/RDI/savedParams_CV' num2str(CONFIG_strParams.RAEParams.CVNUM) '.mat'],'-v7.3','vRAEWeights', 'nDictionaryLength');
      
    [mTopLevelActivations] = NM_feedFwdRAE(cTrainData, vRAEWeights, nDictionaryLength);
    
    save(CONFIG_strParams.sRAERepresentationsWorkspace, '-v7.3', 'mTopLevelActivations');
    % Print results    
    fid = fopen(CONFIG_strParams.sResultsFile,'a');
    fprintf(fid,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.nLambda),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(CONFIG_strParams.RAEParams.Options.maxIter)]);


    fprintf(1,CONFIG_strParams.sExperimentPurpose,[num2str(CONFIG_strParams.RAEParams.CVNUM),',',num2str(1),',',num2str(CONFIG_strParams.RAEParams.nEmbeddingSize),',',num2str(CONFIG_strParams.RAEParams.nLambda),',' , ...
        ',num2str(CONFIG_strParams.RAEParams.nAlphaCat),' , num2str(CONFIG_strParams.RAEParams.Options.maxIter)]);


    fclose(fid);    

    save(CONFIG_strParams.sRAETrainedParamsWorkspace, 'vRAEWeights', 'nDictionaryLength');
end % end function