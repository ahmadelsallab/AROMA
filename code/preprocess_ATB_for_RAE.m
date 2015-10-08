clear, clc;

% Build the vocab cell array
%txtFileName = '..\..\Datasets\ATB\input\ATB1v3_UTF8.txt';%..\..\Datasets\ArSenL\corpus lemmas.txt
%annotationsFileName = '..\..\Datasets\ATB\annotations.txt';%..\..\Datasets\ArSenL\annotation_sentiment.txt
%txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
txtFileName = '..\..\Datasets\ATB\punctuations_handled\ATB (preprocessed tokens).txt';
annotationsFileName = '..\..\Datasets\ArSenL\annotation_sentiment.txt';
knownParseFileName = '..\..\Datasets\ATB\stanford parser\token-level\atb (combined nodes indices, tokens).txt';
global CONFIG_strParamsGUI;
if(~isempty(CONFIG_strParamsGUI))
    txtFileName = CONFIG_strParamsGUI.sSupervisedDataSetPath;
    annotationsFileName = CONFIG_strParamsGUI.sAnnotationsFilePath;
end
dirName = ['..\data\ATB\'];   
% Open the file in UTF-8
fid = fopen(txtFileName,'r','n','UTF-8');
labels = csvread(annotationsFileName);

file_pos = [dirName '\rt-polarity.pos'];
fid_pos = fopen(file_pos, 'w', 'n', 'UTF-8');

file_neg = [dirName '\rt-polarity.neg'];
fid_neg = fopen(file_neg, 'w', 'n', 'UTF-8');

% Get the sentences line by line

%line = fgets(fid);
line = fgetl(fid);
% while strcmp(line(end),' ')||strcmp(line(end),'.')
%     line(end) = [];
% end

%data = {};
words = {};
allSStr_pos = {};
allSStr_neg = {};
allKids_pos = {};
allKids_neg = {};

num = 1;
num_pos = 1;
num_neg = 1;

global bKnownParses;
if(bKnownParses)
    allKids = readTreeParses(knownParseFileName);
end

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
        fprintf(fid_pos, '\n');
        
        %lineWords = splitLine(line);
        
        line=strtrim(line);
        lineWords = textscan(line,'%s','delimiter',' ');
        lineWords = lineWords{1,1};
        
        lineWords = regexp(line,' ','split');
        lineWords = lineWords';
        
        allSStr_pos{num_pos} = lineWords';
        %allSStr_pos{num_pos} = lineWords;
        global bKnownParses;
        if(bKnownParses)
            allKids_pos{num_pos} = allKids{num};
        end
        num_pos = num_pos + 1;
        words = [words; lineWords];
    elseif(labels(num) == 2)
        fprintf(fid_neg, line);
        fprintf(fid_neg, '\n');
        %lineWords = splitLine(line);
        line=strtrim(line);
        lineWords = textscan(line,'%s','delimiter',' ');
        lineWords = lineWords{1,1};
        
        lineWords = regexp(line,' ','split');
        lineWords = lineWords';
                
        allSStr_neg{num_neg} = lineWords';
        global bKnownParses;
        if(bKnownParses)
            allKids_neg{num_neg} = allKids{num};
        end
        num_neg = num_neg + 1;
        words = [words; lineWords];
    end
    num = num + 1;
    %line = fgets(fid);
    line = fgetl(fid);
%     while strcmp(line(end),' ')||strcmp(line(end),'.')
%         line(end) = [];
%     end

end

% Print the vocab.txt file
fid_vocab = fopen([dirName '\vocab.txt'], 'w', 'n', 'UTF-8');
for i = 1 : length(words)
    fprintf(fid_vocab, '%s\n', words{i});
end




% Make unique vocabulary
words = unique(words);
wordMap = containers.Map(words,1:length(words));
% Save the vocab workspace
save([dirName '\vocab.mat'], 'words');

% Now score for each sentence the indices of words

% Positive workspace
allSStr = allSStr_pos;
allSNum = {};
for lineIdx = 1 : size(allSStr, 2)
    lineWordsIndices = [];
    for wordIdx = 1 : size(allSStr{lineIdx}, 2)
        lineWordsIndices(wordIdx) = wordMap(allSStr{lineIdx}{wordIdx});
    end
    allSNum{lineIdx} = lineWordsIndices;
end
% Save the positive workspace
save([dirName '\rt-polarity_pos_binarized.mat'],'allSNum','allSStr', 'allKids_pos');

% Negative workspace
allSStr = allSStr_neg;
allSNum = {};
for lineIdx = 1 : size(allSStr, 2)
    lineWordsIndices = [];
    for wordIdx = 1 : size(allSStr{lineIdx}, 2)
        lineWordsIndices(wordIdx) = wordMap(allSStr{lineIdx}{wordIdx});
    end
    allSNum{lineIdx} = lineWordsIndices;
end
% Save the positive workspace
save([dirName '\rt-polarity_neg_binarized.mat'],'allSNum','allSStr', 'allKids_neg');

save ([dirName '\preprocess.mat']);

% Close read and write files
fclose(fid);
fclose(fid_vocab);
fclose(fid_pos);
fclose(fid_neg);