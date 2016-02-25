clear, clc;

% Build the vocab cell array
%txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
%indicesFileName = '..\..\Datasets\ArSenL\indices.txt';

indicesFileName = '..\..\Datasets\IMDB\IMDB2000Indices';
txtFileName = '..\..\Datasets\IMDB\IMDB2000Lemmas';
annotationsFileName = '..\..\Datasets\IMDB\IMDB2000Annotations.txt';
knownParseFileName = '..\..\Datasets\IMDB\IMDB2000CombinedNodesIndices';
global CONFIG_strParamsGUI;
if(~isempty(CONFIG_strParamsGUI))
    txtFileName = CONFIG_strParamsGUI.sSupervisedDataSetPath;
    indicesFileName = CONFIG_strParamsGUI.sIndicesFilePath;
    annotationsFileName = CONFIG_strParamsGUI.sAnnotationsFilePath;
	knownParseFileName = CONFIG_strParamsGUI.sKnownParseFileName

end
[words, allSStr, allSNum] = buildVocab_SentiWordNet_Embedding_Ready(txtFileName, indicesFileName, annotationsFileName, knownParseFileName);

% fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
% for i = 1 : length(words)
    % fprintf(fid, '%s\n', words{i});
% end
% fclose(fid);
% save('vocab.mat', 'words');
save preprocess_SentiWordNet_Embedding.mat;