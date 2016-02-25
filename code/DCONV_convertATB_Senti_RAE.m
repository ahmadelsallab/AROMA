% Function: Converts input ATB files into cData and cRawData and vocab
% Inputs:
% CONFIG_strParamsGUI: Reference to the configurations parameters structure
% Output:
% cData: the binarized data (cData)
% vTargets: the corresponding vTargets (vTargets)
% cKids: the parse tree in case CONFIG_strParams.bKnownParses is 1
function [cData, vTargets, cKids, nDictionaryLength] = DCONV_convertATB_Senti_RAE()
    
    % Load configurations
    global CONFIG_strParams;
    sTxtFileName = CONFIG_strParams.sSupervisedDataSetPath;
    sIndicesFileName = CONFIG_strParams.sIndicesFileName;
    sAnnotationsFileName = CONFIG_strParams.sAnnotationsFilePath;
    sKnownParseFileName = CONFIG_strParams.sParseFilePath;
    sDirName = CONFIG_strParams.sDataDirectory;

    % Open the raw text file in UTF-8
    fid = fopen(sTxtFileName,'r','n','UTF-8');
    
    % Load the vTargets
    vTargets = csvread(sAnnotationsFileName);
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
    bKnownParses = CONFIG_strParams.bKnownParses;
    if(bKnownParses)
        cKids = DPREP_readTreeParses(sKnownParseFileName);
    end
    
    fprintf(1, 'Start reading the input file...');
    while sLine > 0        
        
        if(bReadyIndices)
            sLine = strtrim(sLine);
            % CSV files lines end with 0
            vNonZero = find(nIndices(ctrNum,:) == 0);
            vNonZero = vNonZero(1);
            % Indices are zero based, while embedding lookup table is 1 based,
            % so we add 1 here
            vLineIndices = nIndices(ctrNum, 1 : vNonZero - 1) + 1;
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
        ctrNum = ctrNum + 1;
        sLine = fgetl(fid);

    end
    fprintf(1, 'Finished reading %d lines', num2str(ctrNum-1));
    
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

        cData = cRawData;
    else
        fprintf(1, 'Start vocabulary scoring...');
        % Make unique vocabulary
        if(CONFIG_strParams.bKnownVocabulary)
            % In case the vocabulary is mandated, we just load it
            load(CONFIG_strParams.sVocabularyFile, 'cWords')
        else
            cWords = unique(cWords);        
        end
        wordMap = containers.Map(cWords,1:length(cWords));
        
        % Now score for each sentence the nIndices of cWords
        
        cData = {};
        for lineIdx = 1 : size(cRawData, 2)
            lineWordsIndices = [];
            actualWordIdx = 1;
            for wordIdx = 1 : size(cRawData{lineIdx}, 2)
                % The following check must succeed in case of all dataset words are in the vocabulary. So actualWordIx = wordIdx.
                % In case of knownVocabulary, only the words in the vocabulary will be scored and others are skipped.
                if(isKey(wordMap, cRawData{lineIdx}{wordIdx}))
                    lineWordsIndices(actualWordIdx) = wordMap(cRawData{lineIdx}{wordIdx});
                    actualWordIdx = actualWordIdx + 1;
                end
            end
            cData{lineIdx} = lineWordsIndices;
        end
        fprintf(1, 'Vocabulary scoring done');
        % Close the files
        fclose(fid);
    
        nDictionaryLength = length(cWords);
    end
end % end function
