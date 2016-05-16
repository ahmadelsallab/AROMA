function Tree = NM_forwardPropRAE_Bare(allKids, W1,W2,W3,W4,b1,b2,b3, Wcat, bcat, alpha_cat, updateWcat, beta, words_embedded, hiddenSize, sl, freq, f, f_prime)

collapsed_sentence = 1:sl;
Tree = tree2;
Tree.pp = zeros((2*sl-1),1);
Tree.nodeScores = zeros(2*sl-1,1);
Tree.nodeNames = 1:(2*sl-1);
Tree.kids = zeros(2*sl-1,2);
Tree.numkids = ones(2*sl-1,1);
Tree.node_y1c1 = zeros(hiddenSize,2*sl-1);
Tree.node_y2c2 = zeros(hiddenSize,2*sl-1);
Tree.freq = zeros(2*sl-1,1);
Tree.nodeFeatures = [words_embedded zeros(hiddenSize, sl-1)];
Tree.nodeFeatures_unnormalized = [words_embedded zeros(hiddenSize, sl-1)];
Tree.nodeDelta_out1 = zeros(hiddenSize,2*sl-1);
Tree.nodeDelta_out2 = zeros(hiddenSize,2*sl-1);
Tree.parentDelta = zeros(hiddenSize,2*sl-1);

% Reconstruction Error
for j=1:sl-1

    [~, size2] = size(words_embedded);
    c1 = words_embedded(:,1:end-1);
    c2 = words_embedded(:,2:end);

    freq1 = freq(1:end-1);
    freq2 = freq(2:end);

    p = f(W1*c1 + W2*c2 + b1(:,ones(size2-1,1)));
    p_norm1 = bsxfun(@rdivide,p,sqrt(sum(p.^2,1)));

    y1_unnormalized = f(W3*p_norm1 + b2(:,ones(size2-1,1)));
    y2_unnormalized = f(W4*p_norm1 + b3(:,ones(size2-1,1)));

    y1 = bsxfun(@rdivide,y1_unnormalized,sqrt(sum(y1_unnormalized.^2,1)));
    y2 = bsxfun(@rdivide,y2_unnormalized,sqrt(sum(y2_unnormalized.^2,1)));

    y1c1 = alpha_cat*(y1-c1);
    y2c2 = alpha_cat*(y2-c2);

    % Eq. (4) in the paper: reconstruction error
    J = 1/2*sum((y1c1).*(y1-c1) + (y2c2).*(y2-c2));

    % finding the pair with smallest reconstruction error for constructing tree
    global CONFIG_strParams;
     if(CONFIG_strParams.bKnownParsing)
        % The min. position are already known from the parser
         J_minpos_2 = allKids(j,2);
         %J_minpos = allKids(j,1);
         J_minpos = J_minpos_2 - 1;
        % The min. score is at the min. position from the parser.
        % Note that; the two positions from the parser are guaranteed to be always successive as in case of the greedy RAE algorihtm.
        % So always, J_minpos_2 = J_minpos + 1
         J_min = J(J_minpos);
     else
         [J_min J_minpos] = min(J);
     end

     %[J_min J_minpos] = min(J);
%          J_minpos = 1;
%          J_min = J(1);

    % Append to the parse file
    if(CONFIG_strParams.bPrintParseTree)
        file_parse = '..\data\parses.txt';
        fid_parse = fopen(file_parse, 'a+', 'n', 'UTF-8');
        fprintf(fid_parse, ['[' num2str(J_minpos) ',' num2str(J_minpos+1) '], ' num2str(J_min)'\n']);
        fclose(fid_parse);
    end
    Tree.node_y1c1(:,sl+j) = y1c1(:,J_minpos);
    Tree.node_y2c2(:,sl+j) = y2c2(:,J_minpos);
    Tree.nodeDelta_out1(:,sl+j) = f_prime(y1_unnormalized(:,J_minpos)) * y1c1(:,J_minpos);
    Tree.nodeDelta_out2(:,sl+j) = f_prime(y2_unnormalized(:,J_minpos)) * y2c2(:,J_minpos);

    words_embedded(:,J_minpos+1)=[];
    words_embedded(:,J_minpos)=p_norm1(:,J_minpos);
    Tree.nodeFeatures(:, sl+j) = p_norm1(:,J_minpos);
    Tree.nodeFeatures_unnormalized(:, sl+j) = p(:,J_minpos);
    Tree.nodeScores(sl+j) = J_min;
    Tree.pp(collapsed_sentence(J_minpos)) = sl+j;
    Tree.pp(collapsed_sentence(J_minpos+1)) = sl+j;


     if(CONFIG_strParams.bKnownParsing)
         Tree.kids(sl+j,:) = [collapsed_sentence(J_minpos) collapsed_sentence(J_minpos_2)];
     else
         Tree.kids(sl+j,:) = [collapsed_sentence(J_minpos) collapsed_sentence(J_minpos+1)];
     end

    %Tree.kids(sl+j,:) = [collapsed_sentence(J_minpos) collapsed_sentence(J_minpos+1)];
    Tree.numkids(sl+j) = Tree.numkids(Tree.kids(sl+j,1)) + Tree.numkids(Tree.kids(sl+j,2));
    % freq(J_minpos+1) = [];
    % freq(J_minpos) = (Tree.numkids(Tree.kids(sl+j,1))*freq1(J_minpos) + Tree.numkids(Tree.kids(sl+j,2))*freq2(J_minpos))/(Tree.numkids(Tree.kids(sl+j,1))+Tree.numkids(Tree.kids(sl+j,2)));

    % collapsed_sentence(J_minpos+1)=[];
    % collapsed_sentence(J_minpos)=sl+j;       

   if(CONFIG_strParams.bKnownParsing)
         freq(J_minpos_2) = [];
         freq(J_minpos) = (Tree.numkids(Tree.kids(sl+j,1))*freq1(J_minpos) + Tree.numkids(Tree.kids(sl+j,2))*freq2(J_minpos))/(Tree.numkids(Tree.kids(sl+j,1))+Tree.numkids(Tree.kids(sl+j,2)));

         collapsed_sentence(J_minpos_2)=[];
         collapsed_sentence(J_minpos)=sl+j;

   else
         freq(J_minpos+1) = [];
         freq(J_minpos) = (Tree.numkids(Tree.kids(sl+j,1))*freq1(J_minpos) + Tree.numkids(Tree.kids(sl+j,2))*freq2(J_minpos))/(Tree.numkids(Tree.kids(sl+j,1))+Tree.numkids(Tree.kids(sl+j,2)));

         collapsed_sentence(J_minpos+1)=[];
         collapsed_sentence(J_minpos)=sl+j;
    end
end
end
