clear, clc;

% Build the vocab cell array
%txtFileName = '..\..\Datasets\ATB\input\ATB1v3_UTF8.txt';
%annotationsFileName = '..\..\Datasets\ATB\annotations.txt';
%txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
%txtFileName = '..\..\Datasets\ArSenL\ArSenL RAE\No separate embedding (token-level)\ATB lemmas (tokens).txt';
%annotationsFileName = '..\..\Datasets\ArSenL\annotation_sentiment.txt';
txtFileName = '..\..\Datasets\IMDB\IMDB2000Lemmas';
annotationsFileName = '..\..\Datasets\IMDB\IMDB2000Annotations.txt';
knownParseFileName = '..\..\Datasets\IMDB\IMDB2000CombinedNodesIndices';

global CONFIG_strParamsGUI;
if(~isempty(CONFIG_strParamsGUI))
    txtFileName = CONFIG_strParamsGUI.sSupervisedDataSetPath;
    annotationsFileName = CONFIG_strParamsGUI.sAnnotationsFilePath;
	annotationsFileName = CONFIG_strParamsGUI.sKnownParseFileName;
end
[words, allSStr, allSNum] = buildVocab_IMDB_We(txtFileName, annotationsFileName, knownParseFileName);

% fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
% for i = 1 : length(words)
    % fprintf(fid, '%s\n', words{i});
% end
% fclose(fid);
% save('vocab.mat', 'words');
save preprocess_IMDB_We.mat;