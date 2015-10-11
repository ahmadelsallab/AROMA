% This function is reponsible of setting all the configuration parameters.
% The output of this  function is a global structure CONFIG_strParams, so that any component needs to read a parameter it can access it.
function CONFIG_setConfigParams()
    global CONFIG_strParams;
    
    % Set the path to the classifier, which is the same path in case of RAE
    CONFIG_strParams.sDefaultClassifierPath = pwd;
    
    % In case of 'RAE', although RAE by itself is not a classifier, but the application is built to test the discovered features by RAE on a classification task using softmax. So in case you just to train an unsupervised RAE, then just set all the labels to zeros, then when the training is over, just use the NM_getFeaturesRAE
    CONFIG_setConfigParams.eClassifierType = 'RAE';
    
    % Configuration of the dataset to be used
    % ATB_Senti_RAE
    CONFIG_strParams.sDataset = 'ATB_Senti_RAE';
    
    % Split the input data 'uniform' or 'random' 'CrossValidation' 'KnownSplit
    CONFIG_strParams.sSplitCriteria = 'random';
    
        % In case of KnownSplit, then set the TRAIN/TEST ranges
        CONFIG_strParams.vTrainRange = [237:end];
        CONFIG_strParams.vTestRange = [1:236];
    
    % Ration of train to test factor ratio
    CONFIG_strParams.nTrainToTestFactor = 10; % Nearly examples are train
    
    % When a vocabulary is known, or obtained from a separate embedding network, set this parameter to 1.
    % For raw RAE, it's just 0.
    CONFIG_strParams.bKnownVocabulary = 0;
        % In case of known parsing, this is the FULL path to the .mat file of the vocabulary
        CONFIG_strParams.sVocabularyFile = '../data/ATB/vocab.mat';
    
    % Full path to the raw txt dataset. Each line is a separate case.
    CONFIG_strParams.sSupervisedDataSetPath = get(handles.sSupervisedDataSetPath, 'String');
     
    % Full path to the annotations associated with the sSupervisedDataSetPath
    CONFIG_strParams.sAnnotationsFilePath = get(handles.sAnnotationsFilePath, 'String');
     
    % The max number of iterations in RAE training
    CONFIG_strParams.nMaxIter  = eval(get(handles.nMaxIter, 'String'));
     
    % Flag to indicate whether separate embedding block is needed
    CONFIG_strParams.bWordEmbedding = get(handles.bWordEmbedding, 'Value');

          % The acitvation used in word embedding training
          contents = get(handles.sActivationfunction,'String'); 
          CONFIG_strParams.sActivationfunction = contents{get(handles.sActivationfunction,'Value')};
          
          % Embedding size
          CONFIG_strParams.nEmbeddingSize = eval(get(handles.nEmbeddingSize, 'String'));
          
          % The widths of layers. In case of list, explicit '[ ]' must be
          % put
          CONFIG_strParams.vLayersSizes = eval(get(handles.vLayersSizes, 'String'));
          
          % N-gram validity We
          CONFIG_strParams.bNgramValidWe = get(handles.bNgramValidWe, 'Value');
              
              % The name of N-gram validity workspace
              CONFIG_strParams.sNgramValidWorkspaceName = '../data/ATB_We/final_net.mat';
              
              % The path to the unsupervised dataset (Qalb for example)
              CONFIG_strParams.sUnsupervisedWeDatasetPath = get(handles.sUnsupervisedWeDatasetPath, 'String');

              % The max. number of lines to parse from the unsupervised dataset (Qalb for example)
              CONFIG_strParams.nMaxNumLines = eval(get(handles.nMaxNumLines, 'String'));
          
          % blexiconembedding embedding
          CONFIG_strParams.bLexiconEmbedding = get(handles.bLexiconEmbedding, 'Value');
            
            % The name of the embedding workspace
            CONFIG_strParams.sLexiconEmbeddingWorkspaceName = '../data/ATB_ArSenL_Embedding/final_net_ArSenL_embedding.mat';
            % Flag to indicate if we need to include the objective score in
            % case of sentiment
            CONFIG_strParams.bLexiconEmbeddingObjectiveScoreIncluded = get(handles.bLexiconEmbeddingObjectiveScoreIncluded, 'Value');
            
            % Path to indices file mapped to bLexiconEmbedding entries
            CONFIG_strParams.sIndicesFilePath = get(handles.sIndicesFilePath, 'String');
            
            % Path to sVocabularyFilePath file
            CONFIG_strParams.sVocabularyFilePath = get(handles.sVocabularyFilePath, 'String');
            
        % Flag to indicate to merge bLexiconEmbedding with word embedding
        CONFIG_strParams.bMergeLexiconNgram = get(handles.bMergeLexiconNgram, 'Value');

            % Flag to indicate to merge at features 
            CONFIG_strParams.sMergeOption = (get(get(handles.sMergeOption,'SelectedObject'),'Tag'));
                
       % Flag to indicate if separate parser was used to get ready parse
       % trees
       CONFIG_strParams.bKnownParsing = get(handles.bKnownParsing, 'Value');
            % Get the path to the known parse trees
            CONFIG_strParams.sParseFilePath = get(handles.sParseFilePath, 'String');

        %%%%%%%%%%%%%%%%%%%%%%
        % RAE Hyperparameters
        %%%%%%%%%%%%%%%%%%%%%%
        % set this to 1 to train the model and to 0 for just testing the RAE features (and directly training the classifier)
        CONFIG_strParams.RAEParams.trainModel = 1;

        % node and word size
        CONFIG_strParams.RAEParams.nEmbeddingSize = CONFIG_strParams.nEmbeddingSize;

        % Relative weighting of reconstruction error and categorization error
        CONFIG_strParams.RAEParams.nAlphaCat = 0.2;

        % Regularization: nLambda = [lambdaW, lambdaL, lambdaCat, lambdaLRAE];
        CONFIG_strParams.RAEParams.nLambda = [1e-05, 0.0001, 1e-07, 0.01];

        % weight of classifier cost on nonterminals
        CONFIG_strParams.RAEParams.nBeta=0.5;

        CONFIG_strParams.RAEParams.sActivationFunction = @norm1tanh;
        CONFIG_strParams.RAEParams.sActivationFunctionPrime = @norm1tanh_prime;

        CONFIG_strParams.RAEParams.CVNUM = 1;
        
        % parameters for the optimizer
        CONFIG_strParams.RAEParams.Options.Method = 'lbfgs';
        CONFIG_strParams.RAEParams.Options.display = 'on';
        CONFIG_strParams.RAEParams.Options.maxIter = CONFIG_strParams.nMaxIter;

        disp(CONFIG_strParams.RAEParams);
        disp(CONFIG_strParams.RAEParams.Options);