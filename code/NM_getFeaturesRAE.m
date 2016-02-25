function features = NM_getFeaturesRAE(words_reIndexed,beta,We,We2,W1,W2,W3,W4,b1,b2,b3,Wcat,bcat,alpha_cat,...
   embedding_size, freq, func, func_prime, training, kids)

    % flag
    % 1 - top node only
    % 2 - average of all nodes

    num_examples = length(words_reIndexed);

    features1 = zeros(num_examples, embedding_size);
    features2 = zeros(num_examples, embedding_size);

    features = zeros(num_examples, embedding_size, 2);
    global CONFIG_strParams;

    loc_bKnownParses = CONFIG_strParams.bKnownParsing;

    global bPrintParseTree;
    loc_bPrintParseTree = bPrintParseTree;
    %parfor ii = 1:num_examples;
    for ii = 1:num_examples;
        words_rI = words_reIndexed{ii};
        nn = length(words_rI);

        freq_here = freq(words_rI);

        L = We(:, words_rI);
        if training == 1
            words_embedded = We2(:, words_rI) + L;
        else
            words_embedded = L;
        end
        
	
    if(loc_bPrintParseTree)
		% Start new sentence line
		file_parse = '..\data\parses.txt';
		fid_parse = fopen(file_parse, 'a+', 'n', 'UTF-8');
		fprintf(fid_parse, ['SENTENCE [' num2str(ii) ']\n']);
		fclose(fid_parse);    
	end  
        if(loc_bKnownParses)
            
            Tree = NM_forwardPropRAE_Bare(kids{ii}, W1,W2,W3,W4,b1,b2,b3, Wcat, bcat, alpha_cat, 0,beta, words_embedded, ...
                embedding_size, nn, freq_here, func, func_prime);
        else
            Tree = NM_forwardPropRAE_Bare([], W1,W2,W3,W4,b1,b2,b3, Wcat, bcat, alpha_cat, 0,beta, words_embedded, ...
                embedding_size, nn, freq_here, func, func_prime);          
        end
        
    
    if(loc_bPrintParseTree)
		% Add enter after the sentence
		fid_parse = fopen(file_parse, 'a+', 'n', 'UTF-8');
		fprintf(fid_parse, ['\n']);
		fclose(fid_parse);
	end
        
        if nn>1
            features1(ii,:) = Tree.nodeFeatures(:,end)';

            tempFeatures = zeros(2*nn-1, embedding_size);
            for i=1:2*nn-1
                tempFeatures(i,:) = Tree.nodeFeatures(:,i)';
            end
            features2(ii,:) = sum(tempFeatures)/(2*nn-1);
        elseif nn==1
            features1(ii,:) = Tree.nodeFeatures(:,1);
            features2(ii,:) = Tree.nodeFeatures(:,1);
        else
            features1(ii,:) = zeros(hiddenSize,1);
            features2(ii,:) = zeros(hiddenSize,1);
        end

    end
    features(:,:,1) = features1;
    features(:,:,2) = features2;
end