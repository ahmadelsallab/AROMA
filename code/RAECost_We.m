function [cost_total,grad_total] = RAECost_We(theta, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
    lambda, We_orig, data_cell, labels, freq_orig, data_cell_We, freq_orig_We, sent_freq, f, f_prime)

[~, ~, ~, ~, ~, ~, ~, Wcat, bcat, We] = getW(1, theta, hiddenSize, cat_size, dictionary_length);

szWe = length(We(:));
szbcat = length(bcat(:));
szWcat = length(Wcat(:));
theta1 = theta;
theta1(end-szWe+1:end) = We;
theta1(end-szWe-szbcat-szWcat+1:end-szWe) = [];


theta2 = theta;
theta2(end-szWe+1:end) = We_orig(:) + We(:);
lambda2 = lambda;
lambda(3) = lambda2(4);
lambda(4) = lambda2(3);

% disp('DEBUGGING: DELETE AFTERWARDS')
% data_cell=data_cell(1:2);
labels_We = 0.*ones(length(data_cell_We), 1);
labels_We = labels_We';

% [costRAE, gradRAE, allKids] = computeCostAndGradRAE([], theta1, 0, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
%     (alpha_cat)*lambda, We_orig , [data_cell_We; data_cell], [labels_We labels], [freq_orig_We; freq_orig], f, f_prime);
% 
% 
% WegradRAE = gradRAE(end-szWe+1:end);
% gradRAE(end-szWe+1:end) = 0;
% gradRAE = [gradRAE; zeros(szbcat+szWcat,1)];
% gradRAE(end-szWe+1:end) = WegradRAE;

% 
[costRAE_We, gradRAE_We] = computeCostAndGradRAE([], theta1, 0, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
    (alpha_cat)*lambda, We_orig , data_cell_We, labels_We, freq_orig_We, f, f_prime, 1);


WegradRAE_We = gradRAE_We(end-szWe+1:end);
gradRAE_We(end-szWe+1:end) = 0;
gradRAE_We = [gradRAE_We; zeros(szbcat+szWcat,1)];
gradRAE_We(end-szWe+1:end) = WegradRAE_We;


[costRAE, gradRAE, allKids] = computeCostAndGradRAE([], theta1, 0, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
    (alpha_cat)*lambda, We_orig , data_cell, labels, freq_orig, f, f_prime, 0);


WegradRAE = gradRAE(end-szWe+1:end);
gradRAE(end-szWe+1:end) = 0;
gradRAE = [gradRAE; zeros(szbcat+szWcat,1)];
gradRAE(end-szWe+1:end) = WegradRAE;




% [costSUP, gradSUP] = computeCostAndGradRAE(allKids(length(labels_We)+1:end,:), theta2, 1, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
%     (1-alpha_cat)*lambda2, zeros(size(We_orig)), data_cell, labels, freq_orig, f, f_prime);
[costSUP, gradSUP] = computeCostAndGradRAE(allKids, theta2, 1, alpha_cat, cat_size, beta, dictionary_length, hiddenSize, ...
    (1-alpha_cat)*lambda2, zeros(size(We_orig)), data_cell, labels, freq_orig, f, f_prime, 0);

cost_total =  costRAE_We + costRAE + costSUP;
grad_total =  gradRAE_We + gradRAE + gradSUP;


% cost_total =  costRAE + costSUP;
% grad_total =  gradRAE + gradSUP;
