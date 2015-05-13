
load('../data/Qalb/vocab_Qalb_ATB.mat','words')

useTrees = 0;

% randomly initialize We
%sizeWe = [50  268810];
sizeWe = [50  length(words)];
r  = 0.05;   % we'll choose weights uniformly from the interval [-r, r]
We = rand(sizeWe) * 2 * r - r;


% these files also contain parse trees which we do not help in our experiments
%load('../data/rt-polaritydata/rt-polarity_pos_binarized.mat','allSNum','allSStr');
load('../data/Qalb/rt-polarity_Qalb_ATB_binarized.mat','allSNum_Qalb_ATB','allSStr_Qalb_ATB');
allSNum = allSNum_Qalb_ATB;
allSStr = allSStr_Qalb_ATB;



num_examples = length(allSNum_Qalb_ATB);
wordMap = containers.Map(words,1:length(words));


words_indexed = cell(num_examples,1);
words_reIndexed = cell(num_examples,1);

words_embedded = cell(num_examples,1);
sentence_length = cell(num_examples,1);

for i=1:num_examples
    if mod(i,1000)==0
        disp([num2str(i) '/' num2str(num_examples)]);
    end
    
    words_indexed{i} = allSNum{i};
    
    words_embedded{i} = We(:,words_indexed{i});
    sentence_length{i} = length(words_indexed{i});
    
end

index_list = cell2mat(words_indexed');
unq = sort(index_list);
freq = histc(index_list,unq);
unq(freq==0) = [];
freq(freq==0) = [];

reIndexMap = containers.Map(unq,1:length(unq));
words2 = words(unq);

parfor i=1:num_examples
    words_reIndexed{i} = arrayfun(@(x) reIndexMap(x), words_indexed{i});
end

We2 = We(:, unq);

allSNum = words_reIndexed;


isnonZero = ones(1,length(allSNum));
allSNum_Qalb_ATB = allSNum;
save(preProFile_Qalb_ATB,'We2','allSNum_Qalb_ATB','unq','isnonZero');
