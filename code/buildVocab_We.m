function [words, allSStr, allSNum] = buildVocab_We(txtFileName, annotationsFileName)
    
    % Open the file in UTF-8
    fid = fopen(txtFileName,'r','n','UTF-8');
    labels = csvread(annotationsFileName);
    
    file_pos = '../data/ATB_We/rt-polarity.pos';
    fid_pos = fopen(file_pos, 'w', 'n', 'UTF-8');

    file_neg = '../data/ATB_We/rt-polarity.neg';
    fid_neg = fopen(file_neg, 'w', 'n', 'UTF-8');

    % Get the sentences line by line

    line = fgetl(fid);
    %data = {};
    words = {};
    allSStr_pos = {};
    allSStr_neg = {};
    num = 1;
    num_pos = 1;
    num_neg = 1;

    % Load the positive and negative instances
    % Save in the positive and negative separate txt files
    % Save positive and negative cell arrays
    % Build the vocabulary
    while line > 0        
        %data = [data; line];
        line  =strtrim(line);
        % Get the words of each line
        %lineWords = textscan(line,'%s','delimiter',' ');
        if(labels(num) == 1)
            fprintf(fid_pos, line);
            fprintf(fid_pos, '\n');
            %lineWords = splitLine(line);
            lineWords = regexp(line,' ','split');
            lineWords = lineWords';
            allSStr_pos{num_pos} = lineWords';
            num_pos = num_pos + 1;
            words = [words; lineWords];
        elseif(labels(num) == 2)
            fprintf(fid_neg, line);
            fprintf(fid_neg, '\n');
            %lineWords = splitLine(line);
            lineWords = regexp(line,' ','split');
            lineWords = lineWords';
            allSStr_neg{num_neg} = lineWords';
            num_neg = num_neg + 1;
            words = [words; lineWords];
        end
        num = num + 1;
        line = fgetl(fid);
    end
    


    % % Make unique vocabulary
    % words = unique(words');
    load('../data/ATB_We/vocab_We.mat', 'words');
    wordMap = containers.Map(words,1:length(words));
    
    
    % Now score for each sentence the indices of words
    
    % Positive workspace
    allSStr = allSStr_pos;
    allSNum = {};
    for lineIdx = 1 : size(allSStr, 2)
        lineWordsIndices = {};
        for wordIdx = 1 : size(allSStr{lineIdx}, 2)
            lineWordsIndices{wordIdx} = wordMap(allSStr{lineIdx}{wordIdx});
        end
        allSNum{lineIdx} = cell2mat(lineWordsIndices);
    end
    % Save the positive workspace
    save('../data/ATB_We/rt-polarity_pos_binarized.mat','allSNum','allSStr');

    % Negative workspace
    allSStr = allSStr_neg;
    allSNum = {};
    for lineIdx = 1 : size(allSStr, 2)
        lineWordsIndices = {};
        for wordIdx = 1 : size(allSStr{lineIdx}, 2)
            lineWordsIndices{wordIdx} = wordMap(allSStr{lineIdx}{wordIdx});
        end
        allSNum{lineIdx} = cell2mat(lineWordsIndices);
    end
    % Save the positive workspace
    save('../data/ATB_We/rt-polarity_neg_binarized.mat','allSNum','allSStr');

    % Close read and write files
    fclose(fid);
    fclose(fid_pos);
    fclose(fid_neg);
end