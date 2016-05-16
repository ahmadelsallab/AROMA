clear, clc;

% Build the vocab cell array
%txtFileName = '..\..\Datasets\ATB\input\ATB1v3_UTF8.txt';
%annotationsFileName = '..\..\Datasets\ATB\annotations.txt';
%txtFileName = '..\..\Datasets\ArSenL\corpus lemmas.txt';
%txtFileName = '..\..\Datasets\ArSenL\ArSenL RAE\No separate embedding (token-level)\ATB lemmas (tokens).txt';
%annotationsFileName = '..\..\Datasets\ArSenL\annotation_sentiment.txt';
%txtFileName = '..\..\Datasets\Eshrag\ArabicTweets (token-level).txt';
%txtFileName = '..\..\Datasets\ATB\punctuations_handled\ATB (preprocessed tokens).txt';
%annotationsFileName = '..\..\Datasets\Eshrag\annotation_sentiment.txt';
%knownParseFileName = '..\..\Datasets\ATB\stanford parser\word-level\atb (combined nodes indices, words).txt';

txtFileName = '..\..\Datasets\ATB\experiments\corpus preprocessed\ATB (preprocessed tokens).txt';
indicesFileName = '..\..\Datasets\ATB\experiments\files for arsenl embedding\separate embedding (token-level)\ATB indices (tokens).txt';

annotationsFileName = '..\..\Datasets\ATB\experiments\annotation_sentiment.txt';
knownParseFileName = '..\..\Datasets\ATB\experiments\files for experiments with stanford parses\token-level\atb (combined nodes indices, tokens).txt';

global CONFIG_strParamsGUI;
if(~isempty(CONFIG_strParamsGUI))
    txtFileName = CONFIG_strParamsGUI.sSupervisedDataSetPath;
    annotationsFileName = CONFIG_strParamsGUI.sAnnotationsFilePath;
	annotationsFileName = CONFIG_strParamsGUI.sKnownParseFileName;
end
[words, allSStr, allSNum] = buildVocab_We(txtFileName, annotationsFileName, knownParseFileName);

% fid = fopen('vocab.txt', 'w', 'n', 'UTF-8');
% for i = 1 : length(words)
    % fprintf(fid, '%s\n', words{i});
% end
% fclose(fid);
% save('vocab.mat', 'words');
save preprocess_We.mat;