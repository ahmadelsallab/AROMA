clear, clc;

% Build the vocab cell array
txtFileName = '..\..\Datasets\Qalb\Qalb compiled.txt';

[words, allSStr, allSNum] = buildVocab_Qalb(txtFileName);

fid = fopen('vocab_Qalb.txt', 'w', 'n', 'UTF-8');
for i = 1 : length(words)
    fprintf(fid, '%s\n', words{i});
end
fclose(fid);
words_Qalb = words;
save('vocab_Qalb.mat', 'words_Qalb');
save preprocess.mat;