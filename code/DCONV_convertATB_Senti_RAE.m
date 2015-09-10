% Function: Converts input ATB files into allSNum and allSStr and vocab
% Inputs:
% CONFIG_strParams: Reference to the configurations parameters structure
% Output:
%save(preProFile, 'labels', 'words_reIndexed', 'full_train_ind','train_ind','cv_ind','test_ind','We2','allSNum','unq','isnonZero','test_nums','full_train_nums');
function [mFeatures, mTargets] = DCONV_convertATB_Senti_RAE(CONFIG_strParams)
    % FIX: Merge both
    %preprocess_ATB_for_RAE;
    txtFileName = CONFIG_strParams.sSupervisedDataSetPath;
    annotationsFileName = CONFIG_strParams.sAnnotationsFilePath;

    fid = fopen(txtFileName,'r','n','UTF-8');
    labels_file = csvread(annotationsFileName);
    
    % Get the sentences line by line

    line = fgets(fid);
    %data = {};
    words = {};
    allSStr_pos = {};
    allSStr_neg = {};
    num = 1;
    num_pos = 1;
    num_neg = 1;

    
    % Load the positive and negative instances
    % Save in the positive and negative separate txt files
    % Save positive and negative cell arrays
    % Build the vocabulary
    while line > 0        
        %data = [data; line];

        % Get the words of each line
        %lineWords = textscan(line,'%s','delimiter',' ');
        while strcmp(line(end),' ')||strcmp(line(end),'.')
            line(end) = [];
        end
        
        if(labels_file(num) == 1)
            lineWords = splitLine(line);
            allSStr_pos{num_pos} = lineWords';
            num_pos = num_pos + 1;
            words = [words; lineWords];
        elseif(labels_file(num) == 2)
            lineWords = splitLine(line);
            allSStr_neg{num_neg} = lineWords';
            num_neg = num_neg + 1;
            words = [words; lineWords];
        end
        num = num + 1;
        line = fgets(fid);
    end

    % Make unique vocabulary
    words = unique(words);
    wordMap = containers.Map(words,1:length(words));

    % Now score for each sentence the indices of words
    labels = zeros(1,10^6);
    counter = 0;
    % Positive workspace
    allSNum_pos = {};
    for lineIdx = 1 : size(allSStr, 2)
        lineWordsIndices = [];
        for wordIdx = 1 : size(allSStr{lineIdx}, 2)
            lineWordsIndices(wordIdx) = wordMap(allSStr_pos{lineIdx}{wordIdx});
        end
        allSNum_pos{lineIdx} = lineWordsIndices;
        counter = counter + 1;
        labels(counter) = 1;
    end

    % Negative workspace
    allSNum_neg = {};
    for lineIdx = 1 : size(allSStr, 2)
        lineWordsIndices = [];
        for wordIdx = 1 : size(allSStr{lineIdx}, 2)
            lineWordsIndices(wordIdx) = wordMap(allSStr_neg{lineIdx}{wordIdx});
        end
        allSNum_neg{lineIdx} = lineWordsIndices;
        counter = counter + 1;
        labels(counter) = 0;
    end
    labels(counter+1:end) = [];
    allSNum = [allSNum_pos allSNum_neg];
    mFeatures = allSNum;
    mTargets = labels;
    
    num_examples = counter;
    %read_rtPolarity_ATB;
    useTrees = 0;

    % randomly initialize We
    %sizeWe = [50  268810];
    sizeWe = [50  length(words)];
    r  = 0.05;   % we'll choose weights uniformly from the interval [-r, r]
    We = rand(sizeWe) * 2 * r - r;
    
    training_labels = [];
    testing_labels = [];

    words_indexed = cell(num_examples,1);
    words_reIndexed = cell(num_examples,1);

    %words_embedded = cell(num_examples,1);
    %sentence_length = cell(num_examples,1);

    for i=1:num_examples
        if mod(i,1000)==0
            disp([num2str(i) '/' num2str(num_examples)]);
        end

        words_indexed{i} = allSNum{i};

        %words_embedded{i} = We(:,words_indexed{i});
        %sentence_length{i} = length(words_indexed{i});

    end

    index_list = cell2mat(words_indexed');
    unq = sort(index_list);
%     freq = histc(index_list,unq);
%     unq(freq==0) = [];
%     freq(freq==0) = [];

    reIndexMap = containers.Map(unq,1:length(unq));
    words2 = words(unq);

    parfor i=1:num_examples
        words_reIndexed{i} = arrayfun(@(x) reIndexMap(x), words_indexed{i});
    end

    We2 = We(:, unq);

    cv_obj = cvpartition(labels,'kfold',10);
    save('../data/ATB/cv_obj','cv_obj');
    %load('../data/ATB/cv_obj');
    full_train_ind = cv_obj.training(params.CVNUM);
    full_train_nums = find(full_train_ind);
    test_ind = cv_obj.test(params.CVNUM);
    test_nums = find(test_ind);

    train_ind = full_train_ind;
    cv_ind = test_ind;

    allSNum = words_reIndexed;

    clear sentence_words_temp

    isnonZero = ones(1,length(allSNum));
     

    
    save(preProFile, 'labels', 'words_reIndexed', 'full_train_ind','train_ind','cv_ind','test_ind','We2','allSNum','unq','isnonZero','test_nums','full_train_nums');


end % end function
