
theta = opttheta;

[W1, W2, W3, W4, b1, b2, b3, Wcat,bcat, We] = getW(1, theta, params.embedding_size, cat_size, dictionary_length);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Get features by forward propagating and finding structure for all train and test sentences...')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in this setting, we take the top node's vector and the average of all vectors in the tree as a concatenated feature vector
global bKnownParses;
if(bKnownParses)
    fulltraining_instances = getFeatures(allSNum(train_ind),0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,params.alpha_cat,params.embedding_size, ...
        labels(:,train_ind), freq_train, func, func_prime, params.trainModel, allKids(train_ind));

    fulltesting_instances = getFeatures(allSNum(test_ind),0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,params.alpha_cat,params.embedding_size,...
        labels(:,test_ind), freq_test, func, func_prime, params.trainModel, allKids(test_ind));
else
    fulltraining_instances = getFeatures(allSNum(train_ind),0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,params.alpha_cat,params.embedding_size, ...
        labels(:,train_ind), freq_train, func, func_prime, params.trainModel, []);

    fulltesting_instances = getFeatures(allSNum(test_ind),0,...
        We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,params.alpha_cat,params.embedding_size,...
        labels(:,test_ind), freq_test, func, func_prime, params.trainModel, []);
    
end
training_labels = labels(:,train_ind)';
testing_labels = labels(:,test_ind)';


[t1 t2 t3] = size(fulltraining_instances);
training_instances = reshape(fulltraining_instances,t1, t2*t3);
[t1 t2 t3] = size(fulltesting_instances);
testing_instances = reshape(fulltesting_instances,t1,t2*t3);

[num_training_instances ~] = size(training_instances);
[num_testing_instances ~] = size(testing_instances);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logistic regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize parameters
theta2 = -0.5+rand(t3*params.embedding_size*cat_size + cat_size,1);

options2.Method = 'lbfgs';
options2.maxIter = 1000;

% Training
[theta2, cost] = minFunc( @(p) soft_cost(p,training_instances, training_labels, 1e-6),theta2, options2);
b = theta2(end);
W = theta2(1:end-1)';

dec_val = sigmoid(W*training_instances' + b(:,ones(num_training_instances,1)));
pred = 1*(dec_val > 0.5);
gold = training_labels';
[prec_train, recall_train, acc_train, f1_train] = getAccuracy(pred, gold);

% Positive class ROC
figure;
xlabel('False positive rate'); ylabel('True positive rate');
title('Training ROC');
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
saveas(gcf, ['Training ROC with MaxIter_' num2str(options.maxIter)], 'fig');


% Prec vs recall
figure;
xlabel('Recall'); ylabel('Precision');
title('Training ROC');
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
saveas(gcf, ['Prec_Rec_Training ROC with MaxIter_' num2str(options.maxIter)], 'fig');

% Testing
dec_val = sigmoid(W*testing_instances' + b(:,ones(num_testing_instances,1)));
pred = 1*(dec_val > 0.5);
gold = testing_labels';
[prec_test, recall_test, acc_test, f1_test] = getAccuracy(pred, gold);

% Positive class ROC
figure;
xlabel('False positive rate'); ylabel('True positive rate');
title('Testing ROC');
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

saveas(gcf, ['Testing ROC with MaxIter_' num2str(options.maxIter)], 'fig');

% Prec vs recall
figure;
xlabel('Recall'); ylabel('Precision');
title('Testing ROC');
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

saveas(gcf, ['Testing ROC with MaxIter_' num2str(options.maxIter)], 'fig');

acc_train
acc_test

fid = fopen('../output/ATB/resultsRAE.txt','a');
fprintf(fid,[num2str(params.CVNUM),',',num2str(1),',',num2str(params.embedding_size),',',num2str(params.lambda(1)),',' , ...
    ',num2str(params.alpha_cat),' , num2str(options.maxIter)]);

fprintf(fid,',train,%f,%f,%f,%f',acc_train, prec_train, recall_train, f1_train);
fprintf(fid,',test,%f,%f,%f,%f\n',acc_test, prec_test, recall_test, f1_test);


fprintf(1,[num2str(params.CVNUM),',',num2str(1),',',num2str(params.embedding_size),',',num2str(params.lambda(1)),',' , ...
    ',num2str(params.alpha_cat),' , num2str(options.maxIter)]);

fprintf(1,',train,%f,%f,%f,%f',acc_train, prec_train, recall_train, f1_train);
fprintf(1,',test,%f,%f,%f,%f\n',acc_test, prec_test, recall_test, f1_test);
fclose(fid);
