function [nAccuracy, nPrecision, nRecall, nF1Score, vPredictedTargets] = TST_computeClassificationErrorSoftmax(mData, vTargets,vSoftmaxWeights, sTitle)

    % Load configurations
    global CONFIG_strParams;

    [num_training_instances ~] = size(mData);


    b = vSoftmaxWeights(end);
    W = vSoftmaxWeights(1:end-1)';



    dec_val = sigmoid(W*mData' + b(:,ones(num_training_instances,1)));
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
    saveas(gcf, [sTitle ' ROC with MaxIter_' num2str(options.maxIter)], 'fig');


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
    saveas(gcf, [sTitle ' Prec_Rec ROC with MaxIter_' num2str(options.maxIter)], 'fig');

    nAccuracy
end
