function Tree = forwardPropRAE(allKids, W1,W2,W3,W4,b1,b2,b3, Wcat, bcat, alpha_cat, updateWcat, beta, words_embedded, label, hiddenSize, sl, freq, f, f_prime)

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

	if updateWcat
		% Classification Error
		nodeUnder = ones(2*sl-1,1);
		
		for i = sl+1:2*sl-1
			kids = allKids(i,:);
			n1 = nodeUnder(kids(1));
			n2 = nodeUnder(kids(2));
			nodeUnder(i) = n1+n2;
		end
		
		[cat_size, ~] = size(Wcat);
		Tree.catDelta = zeros(cat_size, 2*sl-1);
		Tree.catDelta_out = zeros(hiddenSize,2*sl-1);
		
		% classifier on single words
		sm = sigmoid(Wcat*words_embedded + bcat);
		lbl_sm = (1-alpha_cat).*(label(:,ones(sl,1)) - sm);
		Tree.nodeScores(1:sl) = 1/2*(lbl_sm.*(label(:,ones(sl,1)) - sm));
		Tree.catDelta(:, 1:sl) = -(lbl_sm).*sigmoid_prime(sm);
		
		
		
		for i = sl+1:2*sl-1
			
			kids = allKids(i,:);
			
			c1 = Tree.nodeFeatures(:,kids(1));
			c2 = Tree.nodeFeatures(:,kids(2));
			
			% Eq. (2) in the paper: p = f(W(1)[c1; c2] + b(1))
			p = f(W1*c1 + W2*c2 + b1);
			
			% See last paragraph in Section 2.3
			p_norm1 = p./norm(p);
			
			% Eq. (7) in the paper (for special case of 1d label)
			sm = sigmoid(Wcat*p_norm1 + bcat);
			
			lbl_sm = beta * (1-alpha_cat).*(label - sm);
			Tree.catDelta(:, i) = -(lbl_sm).*sigmoid_prime(sm);
			J = 1/2*(lbl_sm'*(label - sm));
			
			Tree.nodeFeatures(:,i) = p_norm1;
			Tree.nodeFeatures_unnormalized(:,i) = p;
			Tree.nodeScores(i) = J;
			Tree.numkids = nodeUnder;
			
		end
		
		Tree.kids = allKids;
		
	else
		
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
			global bKnownParses;
			 if(bKnownParses)
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
			global bPrintParseTree;
			if(bPrintParseTree)
				file_parse = '..\data\parses.txt';
				fid_parse = fopen(file_parse, 'a+', 'n', 'UTF-8');
				fprintf(fid_parse, ['[' num2str(J_minpos) ',' num2str(J_minpos+1) '], ' num2str(J_min) '\n']);
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
			
			 global bKnownParses;
			 if(bKnownParses)
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
		   global bKnownParses;
		   if(bKnownParses)
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
	global bPrintParseTree;
	global parseTreesWorkspace;
	if(bPrintParseTree)
		
		if ~exist(parseTreesWorkspace,'file')
			parse_trees = {};
			parse_trees = [parse_trees; Tree];
			save(parseTreesWorkspace, '-v7.3', 'parse_trees');
		else
			load(parseTreesWorkspace);
			parse_trees = [parse_trees; Tree];
			save(parseTreesWorkspace, '-v7.3', 'parse_trees');
		end
	end
end
