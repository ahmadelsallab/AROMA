% Function: Converts input ATB files into cData and cRawData and vocab
% Inputs:
% CONFIG_strParamsGUI: Reference to the configurations parameters structure
% Output:
% cData: the binarized data (cData)
% cKids: the parse tree in case CONFIG_strParams.bKnownParses is 1
function [cData, cUnsupervisedData, cKids, cUnsupervisedKids, nDictionaryLength] = DCONV_convertDataset_RAE_Bare()
    
    % Load configurations
    global CONFIG_strParams;
    sTxtFileName = CONFIG_strParams.sSupervisedDataSetPath;
    sUnsupervisedTxtFileName = CONFIG_strParams.sUnsupervisedWeDatasetPath;
    sIndicesFileName = CONFIG_strParams.sIndicesFileName;
    sKnownParseFileName = CONFIG_strParams.sParseFilePath;
    sKnownUnuspervisedParseFileName = CONFIG_strParams.sUnsupervisedParseFilePath;
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Supervised dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open the raw text file in UTF-8
    fid = fopen(sTxtFileName,'r','n','UTF-8');
       
    % Load the mIndices, if ready mIndices file exists.
    if(sIndicesFileName ~= '')
        %mIndices = csvread(sIndicesFileName);
        fid_ind = fopen(sIndicesFileName,'r','n','UTF-8');
        bReadyIndices = 1;
    else
        bReadyIndices = 0;
    end
    
    
    % Get the sentences sLine by sLine
    sLine = fgetl(fid);
    cWords = {};
    cRawData = {};
    ctrNum = 1;
    cKids  = {};
    bKnownParses = CONFIG_strParams.bKnownParsing;
    if(bKnownParses)
        cKids = DPREP_readTreeParses(sKnownParseFileName);
    end
    
    fprintf(1, 'Start reading the input file...\n');
    while sLine > 0        
        
        if(bReadyIndices)
            sLine = strtrim(sLine);
            % CSV files lines end with 0
            %vNonZero = find(mIndices(ctrNum,:) == 0);
            %vNonZero = vNonZero(1);
            % Indices are zero based, while embedding lookup table is 1 based,
            % so we add 1 here
            %vLineIndices = mIndices(ctrNum, 1 : vNonZero - 1) + 1;
            vLineIndices = str2num(fgetl(fid_ind)) + 1;
            cRawData{ctrNum} = vLineIndices;
        else
            
            sLine=strtrim(sLine);
            %cLineWords = textscan(sLine,'%s','delimiter',' ');
            %cLineWords = cLineWords{1,1};
            
            cLineWords = regexp(sLine,' ','split');
            cLineWords = cLineWords';        
            cRawData{ctrNum} = cLineWords';
        
            % Add the sLine cWords
            cWords = [cWords; cLineWords];
        end
        
        % Get next sLine
        fprintf(1, 'Finished reading supervised %d lines\n', ctrNum);
        ctrNum = ctrNum + 1;
        sLine = fgetl(fid);
        
    end
    % Close the files
    fclose(fid);
    
    % Save supervised raw data and words
    cSupervisedWords = cWords;
    cSupervisedRawData = cRawData;
    cSupervisedKids = cKids;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unsupervised dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(sUnsupervisedTxtFileName ~= '')
        % Open the raw text file in UTF-8
        fid = fopen(sUnsupervisedTxtFileName,'r','n','UTF-8'); 
        
        % Get the sentences sLine by sLine
        sLine = fgetl(fid);
        cWords = {};
        cRawData = {};
        ctrNum = 1;
        cKids  = {};
        bKnownParses = CONFIG_strParams.bKnownParses;
        if(bKnownParses)
            cKids = DPREP_readTreeParses(sKnownUnuspervisedParseFileName);
        end
        
        fprintf(1, 'Start reading the unsupervised input file...\n');
        while (sLine > 0 & ctrNum < CONFIG_strParams.nMaxNumLines)       
            
            if(bReadyIndices)
                sLine = strtrim(sLine);
                % CSV files lines end with 0
                %vNonZero = find(mIndices(ctrNum,:) == 0);
                %vNonZero = vNonZero(1);
                % Indices are zero based, while embedding lookup table is 1 based,
                % so we add 1 here
                %vLineIndices = mIndices(ctrNum, 1 : vNonZero - 1) + 1;
                vLineIndices = str2num(fgetl(fid_ind)) + 1;
                cRawData{ctrNum} = vLineIndices;
            else
                % Get the sLine cWords
                cLineWords = regexp(sLine,' ','split');
                cLineWords = cLineWords';        
                cRawData{ctrNum} = cLineWords';
            
                % Add the sLine cWords
                cWords = [cWords; cLineWords];
            end
            
            % Get next sLine
            fprintf(1, 'Finished unsupervised reading %d lines\n', ctrNum);
            ctrNum = ctrNum + 1;
            sLine = fgetl(fid);
            
        end
        
        % Close the files
        fclose(fid);
        
        % Save unsupervised raw data and words
        cUnsupervisedWords = cWords;
        cUnsupervisedRawData = cRawData;
        cUnsupervisedKids = cKids;
    else
        cUnsupervisedWords = {};
        cUnsupervisedRawData = {};
        cUnsupervisedKids = {};
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Indices formation: binarization %%%%%%%%%%%%%%%%%%%%%%
    % Merge vocabularies
    cWords = [cSupervisedWords cUnsupervisedWords];
    
    if(bReadyIndices)
        if (CONFIG_strParams.bNgramValidWe)       
            load(CONFIG_strParams.sNgramValidWorkspaceName, 'NM_strNetParams');
            We = NM_strNetParams.cWeights{1};
            We = We';
            nDictionaryLength = size(We, 2);
        elseif (CONFIG_strParams.bLexiconEmbedding)
            load(CONFIG_strParams.sLexiconEmbeddingWorkspaceName, 'NM_strNetParams');
            We = NM_strNetParams.cWeights{1};
            We = We';   
            nDictionaryLength = size(We, 2);            
        elseif(CONFIG_strParams.bKnownVocabulary)
            load(CONFIG_strParams.sVocabularyFile, 'words');
            nDictionaryLength = length(words);        
        end
    else
        fprintf(1, 'Start vocabulary scoring...\n');
        % Make unique vocabulary
        if(CONFIG_strParams.bKnownVocabulary)
            % In case the vocabulary is mandated, we just load it
            load(CONFIG_strParams.sVocabularyFile, 'cWords');
        else
            cWords = unique(cWords);        
        end
        wordMap = containers.Map(cWords,1:length(cWords));
        
        % Now score for each sentence the mIndices of cWords
        
        %%%%%%%%%%%%%%%%%%% Supervised %%%%%%%%%%%%%%%%%%%%%%%%%
        cData = {};
        cRawData = cSupervisedRawData;
        for lineIdx = 1 : size(cRawData, 2)
            lineWordsIndices = [];
            actualWordIdx = 1;
            for wordIdx = 1 : size(cRawData{lineIdx}, 2)
                % The following check must succeed in case of all dataset words are in the vocabulary. So actualWordIx = wordIdx.
                % In case of knownVocabulary, only the words in the vocabulary will be scored and others are skipped, or initialized random.
                if(isKey(wordMap, cRawData{lineIdx}{wordIdx}))
                    lineWordsIndices(actualWordIdx) = wordMap(cRawData{lineIdx}{wordIdx});
                    actualWordIdx = actualWordIdx + 1;
                elseif(CONFIG_strParams.bUseRandomVectorForOOV)
                    lineWordsIndices(actualWordIdx) = length(wordMap) + 1;
                    actualWordIdx = actualWordIdx + 1;
                end
            end
            cData{lineIdx} = lineWordsIndices;
        end
        cData = cData';
        %%%%%%%%%%%%%%%%%%% Unsupervised %%%%%%%%%%%%%%%%%%%%%%%%%
        cUnsupervisedData = {};
        cRawData = cUnsupervisedRawData;
        for lineIdx = 1 : size(cRawData, 2)
            lineWordsIndices = [];
            actualWordIdx = 1;
            for wordIdx = 1 : size(cRawData{lineIdx}, 2)
                % The following check must succeed in case of all dataset words are in the vocabulary. So actualWordIx = wordIdx.
                % In case of knownVocabulary, only the words in the vocabulary will be scored and others are skipped.
                if(isKey(wordMap, cRawData{lineIdx}{wordIdx}))
                    lineWordsIndices(actualWordIdx) = wordMap(cRawData{lineIdx}{wordIdx});
                    actualWordIdx = actualWordIdx + 1;
                elseif(CONFIG_strParams.bUseRandomVectorForOOV)
                    lineWordsIndices(actualWordIdx) = length(wordMap) + 1;
                    actualWordIdx = actualWordIdx + 1;                    
                end
            end
            cUnsupervisedData{lineIdx} = lineWordsIndices;
        end
        fprintf(1, 'Vocabulary scoring done\n');
        cUnsupervisedData = cUnsupervisedData';
        nDictionaryLength = length(cWords);
    end
end % end function
