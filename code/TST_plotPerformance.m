
% Concatenate both features coming from Word embedding and ArSenL
testing_instances = [testing_instances_ArSenL_Embedding testing_instances_We];
training_instances = [training_instances_ArSenL_Embedding training_instances_We];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logistic regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cat_size=1;% for multinomial distributions this would be >1
embedding_size = 50;
%%[t1 t2 t3] = size(fulltraining_instances);%% FIX, fulltraining_instances?
% initialize parameters
%theta2 = -0.5+rand(t3*embedding_size*cat_size + cat_size,1);
%theta2 = -0.5+rand(embedding_size*cat_size + cat_size,1);
t3 = 2; % concatenate the top representation with the average representation, so 2 (t3) * embedding_size (=50) = 100
theta2 = -0.5+rand(2*t3*embedding_size*cat_size + cat_size,1);

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
