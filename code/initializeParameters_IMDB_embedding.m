function theta = initializeParameters_IMDB_embedding(hiddenSize, visibleSize, cat_size)

% Initialize parameters randomly based on layer sizes.
r  = sqrt(6) / sqrt(hiddenSize+visibleSize+1);   % we'll choose weights uniformly from the interval [-r, r]
W1 = rand(hiddenSize, visibleSize) * 2 * r - r;
W2 = rand(hiddenSize, visibleSize) * 2 * r - r;
W3 = rand(visibleSize, hiddenSize) * 2 * r - r;
W4 = rand(visibleSize, hiddenSize) * 2 * r - r;

%We = 1e-3*(rand(hiddenSize, dictionary_length)*2*r-r);
load('../data/IMDB_SentiWordNet_Embedding/final_net_SentiWordNet_embedding.mat');
We = NM_strNetParams.cWeights{1};
We = We';

Wcat = rand(cat_size, hiddenSize) * 2 * r - r;

b1 = zeros(hiddenSize, 1);
b2 = zeros(visibleSize, 1);
b3 = zeros(visibleSize, 1);
bcat = zeros(cat_size, 1);

% Convert weights and bias gradients to the vector form.
% This step will "unroll" (flatten and concatenate together) all
% your parameters into a vector, which can then be used with minFunc.

theta = [W1(:) ; W2(:) ;  W3(:) ; W4(:); b1(:) ; b2(:) ; b3(:); Wcat(:); bcat(:); We(:)];
