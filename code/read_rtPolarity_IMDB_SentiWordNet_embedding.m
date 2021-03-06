
%load('../data/rt-polaritydata/vocab.mat','words')
load('../data/IMDB_SentiWordNet_Embedding/vocab_SentiWordNet_Embedding.mat','words')

useTrees = 0;

% randomly initialize We
%sizeWe = [50  268810];
%sizeWe = [50  length(words)];
%r  = 0.05;   % we'll choose weights uniformly from the interval [-r, r]
%We = rand(sizeWe) * 2 * r - r;
load('../data/IMDB_SentiWordNet_Embedding/final_net_SentiWordNet_embedding.mat');
We = NM_strNetParams.cWeights{1};
We = We';
sizeWe = size(We);


%file1 = '../data/rt-polaritydata/rt-polarity.pos';
file1 = '../data/IMDB_SentiWordNet_Embedding/rt-polarity.pos';
fid1 = fopen(file1);

%file2 = '../data/rt-polaritydata/rt-polarity.neg';
file2 = '../data/IMDB_SentiWordNet_Embedding/rt-polarity.neg';
fid2 = fopen(file2);
%%% NEW
%file = '../data/IMDB_SentiWordNet_Embedding/rt-polarity.all';
%fid = fopen(file);
%%%

% these files also contain parse trees which we do not help in our experiments
%load('../data/rt-polaritydata/rt-polarity_pos_binarized.mat','allSNum','allSStr');
load('../data/IMDB_SentiWordNet_Embedding/rt-polarity_pos_binarized.mat','allSNum','allSStr');
allSNum_pos = allSNum;
allSStr_pos = allSStr;

%load('../data/rt-polaritydata/rt-polarity_neg_binarized.mat','allSNum','allSStr');
load('../data/IMDB_SentiWordNet_Embedding/rt-polarity_neg_binarized.mat','allSNum','allSStr');
allSNum = [allSNum_pos allSNum];
allSStr = [allSStr_pos allSStr];
clear allSNum_pos;
clear allSStr_pos;


% %  Upon inspection these need manual editing:
% allSStr{5919} = {'obvious'};
% allSNum{5919} = 4722;
% 
% allSStr{6550} = {'horrible'};
% allSNum{6550} = 20144;
% 
% allSStr{9801} = {'crummy'};
% allSNum{9801} = 241212;

training_labels = [];
testing_labels = [];

tic
labels = zeros(1,10^6);
sentence_words = cell(1,10^5);
counter = 0;

%%% NEW
while ~feof(fid1)
    
    tempstr = fgetl(fid1);
    while strcmp(tempstr(end),' ')||strcmp(tempstr(end),'.')
        tempstr(end) = [];
    end
    counter = counter + 1;
    sentence_words{counter} = regexp(tempstr,' ','split');
    labels(counter) = 1;
end

while ~feof(fid2)
    
    tempstr = fgetl(fid2);
    while strcmp(tempstr(end),' ')||strcmp(tempstr(end),'.')
        tempstr(end) = [];
    end
    counter = counter + 1;
    sentence_words{counter} = regexp(tempstr,' ','split');
    labels(counter) = 0;
    
end

% 
% while ~feof(fid)
%     
%     tempstr = fgetl(fid);
%     while strcmp(tempstr(end),' ')||strcmp(tempstr(end),'.')
%         tempstr(end) = [];
%     end
%     counter = counter + 1;
%     sentence_words{counter} = regexp(tempstr,' ','split');
%     labels(counter) = 1;
% end
%%%
sentence_words(counter+1:end) = [];
labels(counter+1:end) = [];
toc

num_examples = counter;
wordMap = containers.Map(words,1:length(words));

%%% NEW
% load('../data/IMDB_SentiWordNet_Embedding/rt-polarity_binarized.mat','allSNum','allSStr', 'labels');
%%%
global bKnownParses;
if(bKnownParses)
    load('../data/IMDB_SentiWordNet_Embedding/rt-polarity_pos_binarized.mat','allKids_pos');
    load('../data/IMDB_SentiWordNet_Embedding/rt-polarity_neg_binarized.mat','allKids_neg');
    allKids = [allKids_pos allKids_neg];
    clear allKids_pos;
    clear allKids_neg;

end
% wordMap('elipsiseelliippssiiss') = wordMap('...');
% wordMap('smilessmmiillee') = (uint32(wordMap.Count) + 1);   %end-4
% We = [We We(:,wordMap('smile'))];
% wordMap('frownffrroowwnn') = (uint32(wordMap.Count) + 1);   %end-3
% We = [We We(:,wordMap('frown'))];
% wordMap('haha') = (uint32(wordMap.Count) + 1);      %end-2
% We = [We We(:,wordMap('laugh'))];
% wordMap('hahaha') = (uint32(wordMap.Count));        %end-2
% We = [We We(:,wordMap('laugh'))];
% wordMap('hahahaha') = (uint32(wordMap.Count));      %end-2
% We = [We We(:,wordMap('laugh'))];
% wordMap('hahahahaha') = (uint32(wordMap.Count));    %end-2
% We = [We We(:,wordMap('laugh'))];
% wordMap('hehe') = (uint32(wordMap.Count) + 1);      %end-1
% We = [We We(:,wordMap('laugh'))];
% wordMap('hehehe') = (uint32(wordMap.Count));        %end-1
% We = [We We(:,wordMap('laugh'))];
% wordMap('hehehehe') = (uint32(wordMap.Count));      %end-1
% We = [We We(:,wordMap('laugh'))];
% wordMap('hehehehehe') = (uint32(wordMap.Count));    %end-1
% We = [We We(:,wordMap('laugh'))];
% wordMap('lol') = (uint32(wordMap.Count) + 1);       %end
% We = [We We(:,wordMap('laugh'))];
% wordMap('lolol') = (uint32(wordMap.Count));         %end
% We = [We We(:,wordMap('laugh'))];
% words = [words {'elipsiseelliippssiiss'} {'smilessmmiillee'} {'frownffrroowwnn'} {'haha'} {'hahaha'} {'hahahaha'} {'hahahahaha'} {'hehe'} {'hehehe'} {'hehehehe'} {'hehehehehe'} {'lol'} {'lolol'}];

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

%We2 = We(:, unq);
We2 = We;

cv_obj = cvpartition(labels,'kfold',10);
save('../data/IMDB_SentiWordNet_Embedding/cv_obj','cv_obj');
load('../data/IMDB_SentiWordNet_Embedding/cv_obj', 'cv_obj');
full_train_ind = cv_obj.training(params.CVNUM);
full_train_nums = find(full_train_ind);

%%% NEW
% full_train_ind = zeros(1180, 1);
% full_train_ind(237:end) = 1;
% full_train_ind = logical(full_train_ind);
% full_train_nums = find(full_train_ind);
%%%

test_ind = cv_obj.test(params.CVNUM);
test_nums = find(test_ind);

%%% NEW
% test_ind = zeros(1180, 1);
% test_ind(1:236) = 1;
% test_ind = logical(test_ind);
% test_nums = find(test_ind);
%%%


train_ind = full_train_ind;
cv_ind = test_ind;

allSNum = words_reIndexed;

%clear sentence_words_temp

isnonZero = ones(1,length(allSNum));

global bKnownParses;
if(bKnownParses)
    save(preProFile, 'labels', 'words_reIndexed', 'full_train_ind','train_ind','cv_ind','test_ind','We2','allSNum','unq','isnonZero','test_nums','full_train_nums', 'allKids');
else
    save(preProFile, 'labels', 'words_reIndexed', 'full_train_ind','train_ind','cv_ind','test_ind','We2','allSNum','unq','isnonZero','test_nums','full_train_nums');
end
