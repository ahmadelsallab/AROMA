function [words, allSStr, allSNum] = buildVocab_Qalb(txtFileName)
    
    % Open the file in UTF-8
    fid = fopen(txtFileName,'r','n','UTF-8');
    % Get the sentences line by line
    line = fgets(fid);
    %data = {};
    words = {};
    num = 1;
    allSStr = {};
    nSentences = 20000;
    % Load the positive and negative instances
    % Save in the positive and negative separate txt files
    % Save positive and negative cell arrays
    % Build the vocabulary
    
    while ((line > 0) & (num < nSentences))
        %data = [data; line];
        fprintf(1, 'Reading line %d\n', num);
        % Get the words of each line
        lineWords = splitLine(line);
        allSStr{num} = lineWords';
        words = [words; lineWords];
        num = num + 1;
        line = fgets(fid);
        save(['preprocess_Qalb_ATB' num2str(nSentences) '.mat'], 'allSStr', 'words');
    end
    
%load preprocess_Qalb_ATB

    % Make unique vocabulary
    words = unique(words');
    wordMap = containers.Map(words,1:length(words));
    
    
    % Now score for each sentence the indices of words
    
    % Workspace
    allSNum = {};
    for lineIdx = 1 : size(allSStr, 2)
        lineWordsIndices = {};
        for wordIdx = 1 : size(allSStr{lineIdx}, 2)
            lineWordsIndices{wordIdx} = wordMap(allSStr{lineIdx}{wordIdx});
        end
        allSNum{lineIdx} = cell2mat(lineWordsIndices);
    end
    % Save the workspace
    allSNum_Qalb = allSNum;
    allSStr_Qalb = allSStr;
    save('rt-polarity_Qalb_binarized.mat','allSNum_Qalb','allSStr_Qalb');
    save('vocab_Qalb.mat', 'words');

    % Close read and write files
    fclose(fid);
end