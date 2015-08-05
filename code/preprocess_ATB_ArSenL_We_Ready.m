clear, clc;

% Build the vocab cell array
txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
indicesFileName = '..\..\Datasets\ArSenL\indices.txt';
annotationsFileName = '..\..\Datasets\ArSenL\annotation_sentiment.txt';

[words, allSStr, allSNum] = buildVocab_ArSenL_Embedding_Ready(txtFileName, indicesFileName, annotationsFileName);

% fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
% for i = 1 : length(words)
    % fprintf(fid, '%s\n', words{i});
% end
% fclose(fid);
% save('vocab.mat', 'words');
save preprocess_ArSenL_We.mat;