function [nAccuracy, nPrecision, nRecall, nF1Score, vPredictedTargets] = TST_computeClassificationErrorRAE(cData, vTargets, cKids, vSoftmaxWeights, vRAEWeights, nDictionaryLength, sTitle)

% Load configurations
global CONFIG_strParams;

% Decode the weights
[W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = NM_getRAEWeights(1, vRAEWeights, CONFIG_strParams.RAEParams.nEmbeddingSize, CONFIG_strParams.RAEParams.nCategorySize, nDictionaryLength);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Get features by forward propagating and finding structure...')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in this setting, we take the top node's vector and the average of all vectors in the tree as a concatenated feature vector

index_list_train = cell2mat(cData');
freq_train = histc(index_list_train,1:size(We,2));

freq_train = freq_train/sum(freq_train);

if(CONFIG_strParams.bKnownParsing)
    fulltraining_instances = NM_getFeatures(cData,0,...
        We,We,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,CONFIG_strParams.RAEParams.nAlphaCat,CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        vTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, 1,cKids);
else
    fulltraining_instances = NM_getFeatures(cData,0,...
        We,We,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,CONFIG_strParams.RAEParams.nAlphaCat,CONFIG_strParams.RAEParams.nEmbeddingSize, ...
        vTargets, freq_train, CONFIG_strParams.RAEParams.sActivationFunction, CONFIG_strParams.RAEParams.sActivationFunctionPrime, 1, []);   
end


[t1 t2 t3] = size(fulltraining_instances);
training_instances = reshape(fulltraining_instances,t1, t2*t3);

[num_training_instances ~] = size(training_instances);


b = vSoftmaxWeights(end);
W = vSoftmaxWeights(1:end-1)';



dec_val = sigmoid(W*training_instances' + b(:,ones(num_training_instances,1)));
vPredictedTargets = 1*(dec_val > 0.5);
gold = vTargets';
[nPrecision, nRecall, nAccuracy, nF1Score] = TST_getAccuracy(vPredictedTargets, gold);

% Positive class ROC
figure;
xlabel('False positive rate'); ylabel('True positive rate');
title([sTitle ' ROC']);
grid on;
hold on;
[X_perf,Y_perf, T, AUC_pos] = perfcurve(gold,dec_val,1);
AUC_pos
plot(X_perf,Y_perf, 'b');
hold on;
% Negative class ROC
[X_perf,Y_perf, T, AUC_neg] = perfcurve(gold,dec_val,0);
AUC_neg
plot(X_perf,Y_perf, 'r');
legend(['Positive class, AUC = ' num2str(AUC_pos)], ['Negative class, AUC = ' num2str(AUC_neg)])
hold off;
saveas(gcf, [sTitle ' ROC with MaxIter_' num2str(CONFIG_strParams.nMaxIter)], 'fig');


% Prec vs recall
figure;
xlabel('Recall'); ylabel('Precision');
title([sTitle ' ROC']);
grid on;
hold on;
[X_perf,Y_perf, T, AUC_pos] = perfcurve(gold,dec_val,1, 'XCrit', 'reca', 'YCrit', 'prec');
AUC_pos

plot(X_perf,Y_perf, 'b');
hold on;
% Negative class ROC
[X_perf,Y_perf, T, AUC_neg] = perfcurve(gold,dec_val,0, 'XCrit', 'reca', 'YCrit', 'prec');
AUC_neg
plot(X_perf,Y_perf, 'r');
legend(['Positive class, AUC = ' num2str(AUC_pos)], ['Negative class, AUC = ' num2str(AUC_neg)])
hold off;
saveas(gcf, [sTitle ' Prec_Rec ROC with MaxIter_' num2str(CONFIG_strParams.nMaxIter)], 'fig');

nAccuracy
