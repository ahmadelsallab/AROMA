% This function is is obtaining the top level activations of a given RAE. It differs from NM_getFeaturesRAE in that it takes vectorial RAE parameters.
% Inputs: 
% cTrainData: training data
% vTrainTargets: training labels
% cTrainKids: kids for training in case of known tree parses
% vRAEWeights: the weights as initialized by RAEParams
% Output:
% mTopLevelActivations: the  top level activations of the RAE = features

function [mTopLevelActivations] = NM_feedFwdRAE(cTrainData, vRAEWeights, nDictionaryLength)
% Load configurations
global CONFIG_strParams;

% Decode the weights
[W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Get features by forward propagating and finding structure for all train and test sentences...')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in this setting, we take the top node's vector and the average of all vectors in the tree as a concatenated feature vector

index_list_train = cell2mat(cTrainData');
freq_train = histc(index_list_train,1:size(We,2));

freq_train = freq_train/sum(freq_train);


if(CONFIG_strParams.bKnownParsing)
    fulltraining_instances = NM_getFeatures(cTrainData,0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,CONFIG_strParams.RAEParams.nAlphaCat,CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        vTrainTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, 1,cTrainKids);
        
else
    fulltraining_instances = NM_getFeatures(allSNum(train_ind),0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,CONFIG_strParams.RAEParams.nAlphaCat,CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        labels(:,train_ind), freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, 1, []);

    
end

[t1 t2 t3] = size(fulltraining_instances);
mTopLevelActivations = reshape(fulltraining_instances,t1, t2*t3);

