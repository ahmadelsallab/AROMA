clear, clc;

% Build the vocab cell array
txtFileName = '..\..\Datasets\ATB\input\ATB1v3_UTF8.txt';
annotationsFileName = '..\..\Datasets\ATB\annotations.txt';

[words, allSStr, allSNum] = buildVocab(txtFileName, annotationsFileName);

fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
for i = 1 : length(words)
    fprintf(fid, '%s\n', words{i});
end
fclose(fid);
save('../data/ATB/vocab.mat', 'words');
save preprocess.mat;