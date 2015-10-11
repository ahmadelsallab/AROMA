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
    sAnnotationsFileName = CONFIG_strParams.sAnnotationsFilePath;
    sKnownParseFileName = CONFIG_strParams.sParseFilePath;
    sDirName = CONFIG_strParams.sDataDirectory;

    % Open the raw text file in UTF-8
    fid = fopen(sTxtFileName,'r','n','UTF-8');
    
    % Load the vTargets
    vTargets = csvread(sAnnotationsFileName);
    
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
        
        % Get the sLine cWords
        cLineWords = regexp(sLine,' ','split');
        cLineWords = cLineWords';        
        cRawData{ctrNum} = cLineWords';
    
        % Add the sLine cWords
        cWords = [cWords; cLineWords];
        
        % Get next sLine
        ctrNum = ctrNum + 1;
        sLine = fgetl(fid);

    end
    fprintf(1, 'Finished reading %d lines', num2str(ctrNum-1));
    
    fprintf(1, 'Start vocabulary scoring...');
    % Make unique vocabulary
    if(CONFIG_strParams.bKnownVocabulary)
        % In case the vocabulary is mandated, we just load it
        load(CONFIG_strParams.sVocabularyFile, 'cWords')
    else
        cWords = unique(cWords);        
    end
    wordMap = containers.Map(cWords,1:length(cWords));
    
    % Now score for each sentence the indices of cWords
    cData = {};
    for lineIdx = 1 : size(cRawData, 2)
        lineWordsIndices = [];
        for wordIdx = 1 : size(cRawData{lineIdx}, 2)
            lineWordsIndices(wordIdx) = wordMap(cRawData{lineIdx}{wordIdx});
        end
        cData{lineIdx} = lineWordsIndices;
    end
    fprintf(1, 'Vocabulary scoring done');
    % Close the files
    fclose(fid);
    
    nDictionaryLength = length(cWords);

end % end function
