function [words, allSStr, allSNum] = buildVocab_ArSenL_We_Ready(txtFileName, indicesFileName, annotationsFileName)
    
    % Open the file in UTF-8
    fid = fopen(txtFileName,'r','n','UTF-8');
    labels = csvread(annotationsFileName);
    indices = csvread(indicesFileName);
    
    file_pos = '../data/ATB_ArSenL_We/rt-polarity.pos';
    fid_pos = fopen(file_pos, 'w', 'n', 'UTF-8');

    file_neg = '../data/ATB_ArSenL_We/rt-polarity.neg';
    fid_neg = fopen(file_neg, 'w', 'n', 'UTF-8');

    % Get the sentences line by line

    line = fgetl(fid);
    %data = {};
    words = {};
    allSStr_pos = {};
    allSStr_neg = {};
    allSNum_pos = {};
    allSNum_neg = {};
    num = 1;
    num_pos = 1;
    num_neg = 1;

    % Load the positive and negative instances
    % Save in the positive and negative separate txt files
    % Save positive and negative cell arrays
    % Build the vocabulary
    while line > 0        
        %data = [data; line];
        line = strtrim(line);
        % Get the words of each line
        %lineWords = textscan(line,'%s','delimiter',' ');
        
        % CSV files lines end with 0
        non_zero = find(indices(num,:) == 0);
        non_zero = non_zero(1);
        % Indices are zero based, while embedding lookup table is 1 based,
        % so we add 1 here
        line_indices = indices(num, 1 : non_zero - 1);
        if(labels(num) == 1)
            fprintf(fid_pos, [line '\n']);
            %lineWords = splitLine(line);
            lineWords = regexp(line,' ','split');
            lineWords = lineWords';
            allSStr_pos{num_pos} = lineWords';
            allSNum_pos{num_pos} = line_indices;
            num_pos = num_pos + 1;
            words = [words; lineWords];
        elseif(labels(num) == 2)
            fprintf(fid_neg, [line '\n']);
            lineWords = regexp(line,' ','split');
            lineWords = lineWords';
            allSStr_neg{num_neg} = lineWords';
            allSNum_neg{num_neg} = line_indices;
            num_neg = num_neg + 1;
            words = [words; lineWords];
        end
        num = num + 1;
        line = fgetl(fid);
    end
    
    % % Make unique vocabulary
    % words = unique(words');
    load('../data/ATB_ArSenL_We/vocab_ArSenL_Embedding.mat', 'words');    
    
    % Now score for each sentence the indices of words
    
    % Positive workspace
    allSStr = allSStr_pos;
    allSNum = allSNum_pos;

    % Save the positive workspace
    save('../data/ATB_ArSenL_We/rt-polarity_pos_binarized.mat','allSNum','allSStr');

    % Negative workspace
    allSStr = allSStr_neg;
    allSNum = allSNum_neg;

    % Save the positive workspace
    save('../data/ATB_ArSenL_We/rt-polarity_neg_binarized.mat','allSNum','allSStr');

    % Close read and write files
    fclose(fid);
    fclose(fid_pos);
    fclose(fid_neg);
end