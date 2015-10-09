% This function is reponsible of setting all the configuration parameters.
% The output of this  function is a global structure CONFIG_strParams, so that any component needs to read a parameter it can access it.
function CONFIG_setConfigParams()
    global CONFIG_strParams;
    
    % Set the path to the classifier, which is the same path in case of RAE
    CONFIG_strParams.sDefaultClassifierPath = pwd;
    
    % Configuration of the dataset to be used
    % ATB_Senti_RAE
    CONFIG_strParams.sDataset = 'ATB_Senti_RAE';
    
    % Split the input data 'uniform' or 'random'
    CONFIG_strParams.sSplitCriteria = 'random';
    
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
          
              % The path to the unsupervised dataset (Qalb for example)
              CONFIG_strParams.sUnsupervisedWeDatasetPath = get(handles.sUnsupervisedWeDatasetPath, 'String');

              % The max. number of lines to parse from the unsupervised dataset (Qalb for example)
              CONFIG_strParams.nMaxNumLines = eval(get(handles.nMaxNumLines, 'String'));
          
          % blexiconembedding embedding
          CONFIG_strParams.bLexiconEmbedding = get(handles.bLexiconEmbedding, 'Value');
          
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
