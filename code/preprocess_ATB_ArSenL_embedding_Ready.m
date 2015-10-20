clear, clc;

% Build the vocab cell array
%txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
%indicesFileName = '..\..\Datasets\ArSenL\indices.txt';
txtFileName = '..\..\Datasets\ArSenL\ArSenL RAE\No separate embedding (token-level)\ATB lemmas (tokens).txt';
indicesFileName = '..\..\Datasets\ArSenL\ArSenL RAE\No separate embedding (token-level)\ATB indices (tokens).txt';

annotationsFileName = '..\..\Datasets\ArSenL\annotation_sentiment.txt';
global CONFIG_strParamsGUI;
if(~isempty(CONFIG_strParamsGUI))
    txtFileName = CONFIG_strParamsGUI.sSupervisedDataSetPath;
    indicesFileName = CONFIG_strParamsGUI.sIndicesFilePath;
    annotationsFileName = CONFIG_strParamsGUI.sAnnotationsFilePath;

end
[words, allSStr, allSNum] = buildVocab_ArSenL_Embedding_Ready(txtFileName, indicesFileName, annotationsFileName);

% fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
% for i = 1 : length(words)
    % fprintf(fid, '%s\n', words{i});
% end
% fclose(fid);
% save('vocab.mat', 'words');
save preprocess_ArSenL_Embedding.mat;