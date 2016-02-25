function vTheta = NM_initializeRAEParameters(nHiddenSize, nVisibleSize, nCatSize, nDictionaryLength)

% Initialize parameters randomly based on layer sizes.
r  = sqrt(6) / sqrt(nHiddenSize+nVisibleSize+1);   % we'll choose weights uniformly from the interval [-r, r]
W1 = rand(nHiddenSize, nVisibleSize) * 2 * r - r;
W2 = rand(nHiddenSize, nVisibleSize) * 2 * r - r;
W3 = rand(nVisibleSize, nHiddenSize) * 2 * r - r;
W4 = rand(nVisibleSize, nHiddenSize) * 2 * r - r;



global CONFIG_strParams;
if (CONFIG_strParams.bNgramValidWe)
    
    load(CONFIG_strParams.sNgramValidWorkspaceName, 'NM_strNetParams');
    We = NM_strNetParams.cWeights{1};
    We = We';
elseif (CONFIG_strParams.bLexiconEmbedding)

    load(CONFIG_strParams.sLexiconEmbeddingWorkspaceName, 'NM_strNetParams');
    We = NM_strNetParams.cWeights{1};
    We = We';
else
    We = 1e-3*(rand(nHiddenSize, nDictionaryLength)*2*r-r);    
end

Wcat = rand(nCatSize, nHiddenSize) * 2 * r - r;

b1 = zeros(nHiddenSize, 1);
b2 = zeros(nVisibleSize, 1);
b3 = zeros(nVisibleSize, 1);
bcat = zeros(nCatSize, 1);

% Convert weights and bias gradients to the vector form.
% This step will "unroll" (flatten and concatenate together) all
% your parameters into a vector, which can then be used with minFunc.

vTheta = [W1(:) ; W2(:) ;  W3(:) ; W4(:); b1(:) ; b2(:) ; b3(:); Wcat(:); bcat(:); We(:)];
