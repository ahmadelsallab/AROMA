clear, clc;

% Build the vocab cell array
txtFileName = '..\..\Datasets\Qalb\Qalb compiled.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QALB VOCAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[words_Qalb, allSStr_Qalb, allSNum_Qalb] = buildVocab_Qalb(txtFileName);
   % Open the file in UTF-8
    fid_Qalb = fopen(txtFileName,'r','n','UTF-8');
    % Get the sentences line by line
    line = fgets(fid_Qalb);
    %data = {};
    words = {};
    num = 1;
    allSStr = {};
    nSentences = 10000;
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
        line = fgets(fid_Qalb);
        save(['preprocess_Qalb_ATB' num2str(nSentences) '.mat'], 'allSStr', 'words');
    end
    
%load preprocess_Qalb_ATB

    % Make unique vocabulary
    words_Qalb = unique(words');
    %wordMap = containers.Map(words,1:length(words));
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QALB ATB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the vocab cell array
txtFileName = '..\..\Datasets\ATB\input\ATB1v3_UTF8.txt';
annotationsFileName = '..\..\Datasets\ATB\annotations.txt';

%[words_ATB, allSStr_ATB, allSNum_ATB] = buildVocab(txtFileName, annotationsFileName);
    % Open the file in UTF-8
    fid_ATB = fopen(txtFileName,'r','n','UTF-8');
    labels = csvread(annotationsFileName);
    
    file_pos = 'rt-polarity.pos';
    fid_pos = fopen(file_pos, 'w', 'n', 'UTF-8');

    file_neg = 'rt-polarity.neg';
    fid_neg = fopen(file_neg, 'w', 'n', 'UTF-8')

    % Get the sentences line by line

    line = fgets(fid_ATB);
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
        
        % Get the words of each line
        %lineWords = textscan(line,'%s','delimiter',' ');
        if(labels(num) == 1)
            fprintf(fid_pos, line);
            lineWords = splitLine(line);
            allSStr_pos{num_pos} = lineWords';
            num_pos = num_pos + 1;
            words = [words; lineWords];
        elseif(labels(num) == 2)
            fprintf(fid_neg, line);
            lineWords = splitLine(line);
            allSStr_neg{num_neg} = lineWords';
            num_neg = num_neg + 1;
            words = [words; lineWords];
        end
        num = num + 1;
        line = fgets(fid_ATB);
    end
    


    % Make unique vocabulary
    words_ATB = unique(words');

words = [words_Qalb words_ATB];
words = unique(words);
wordMap = containers.Map(words,1:length(words));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SCORE QALB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SCORE ATB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
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
    save('rt-polarity_pos_binarized.mat','allSNum','allSStr');
	allSNum_Pos = allSNum;
	
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
    save('rt-polarity_neg_binarized.mat','allSNum','allSStr');
	allSNum_Neg = allSNum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MERGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
allSNum_Qalb_ATB = [allSNum_Qalb allSNum_Pos allSNum_Neg];
allSStr_Qalb_ATB = [allSStr_Qalb allSStr_pos allSStr_neg];
save('rt-polarity_Qalb_ATB_binarized.mat','allSNum_Qalb_ATB','allSStr_Qalb_ATB');

fid_Voc = fopen('vocab_Qalb_ATB.txt', 'w', 'n', 'UTF-8');
for i = 1 : length(words)
    fprintf(fid_Voc, '%s\n', words{i});
end

    % Close read and write files
fclose(fid_ATB);
fclose(fid_Qalb);
fclose(fid_pos);
fclose(fid_neg);
fclose(fid_Voc);
save('../data/Qalb/vocab_Qalb_ATB.mat', 'words');
save(['preprocess_Qalb_ATB' num2str(nSentences) '.mat']);
