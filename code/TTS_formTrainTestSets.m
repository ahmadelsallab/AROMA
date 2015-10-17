% Function:
% Forms the train and test sets out of the raw data given. The criteria of
% split is defined in the inputs
% Inputs:
% cData: the input non split data
% vTargets: Raw targets. 

% Output:
% cTestData: Test features. 
% vTestTargets: Test targetss.
% cTrainData: Train features. 
% vTrainTargets: Train targets. 
function [cTestData, vTestTargets, mcTrainData, vTrainTargets, cTrainKids, cTestKids] = TTS_formTrainTestSets(cData, vTargets, cKids)
    
    % Load configurations
    global CONFIG_strParams;
    sCriteria = CONFIG_strParams.sSplitCriteria;
    nTrainToTestFactor = CONFIG_strParams.nTrainToTestFactor;
    
    % Initialize the matrices
    vTestTargets = [];
    cTestData = [];
    vTrainTargets = [];
    cTrainData = [];
    cTestKids = [];
    cTrainKids = [];
    
    % Randomize if criteria is random
    if strcmp(sCriteria, 'random')
        rand('state',0); %so we know the permutation of the training data
        randomorder=randperm(size(cData,1));       
    end % end if

    for b = 1 : size(cData,1)
        fprintf(1, 'Splitting example %d\n', b);
        % Read the raw features and targets according to split criteria
        if strcmp(sCriteria, 'random')
            mLocFeatures = cData(randomorder(b), :);
            mLocTargets = vTargets(randomorder(b), :);
            if(CONFIG_strParams.bKnownParsing)
                mLocKids = cKids(randomorder(b), :);
            end
            % Feed test and train sets according to the ratio configured
            if (mod(b-1, nTrainToTestFactor) == 0)	
                vTestTargets = [vTestTargets; mLocTargets];
                cTestData = [cTestData; mLocFeatures];
                if(CONFIG_strParams.bKnownParsing)
                    cTestKids = [cTestKids; mLocKids];
                end
            else
                vTrainTargets = [vTrainTargets; mLocTargets];
                cTrainData = [cTrainData; mLocFeatures];
                if(CONFIG_strParams.bKnownParsing)
                    cTrainKids = [cTrainKids; mLocKids];
                end
            end; % end if-else
        elseif strcmp(sCriteria, 'uniform')
            mLocFeatures = cData(b, :);
            mLocTargets = vTargets(b, :);
            if(CONFIG_strParams.bKnownParsing)
                mLocKids = cKids(b, :);
            end
            
            % Feed test and train sets according to the ratio configured
            if (mod(b-1, nTrainToTestFactor) == 0)	
                vTestTargets = [vTestTargets; mLocTargets];
                cTestData = [cTestData; mLocFeatures];
                if(CONFIG_strParams.bKnownParsing)
                    cTestKids = [cTestKids; mLocKids];
                end
            else
                vTrainTargets = [vTrainTargets; mLocTargets];
                cTrainData = [cTrainData; mLocFeatures];
                if(CONFIG_strParams.bKnownParsing)
                    cTrainKids = [cTrainKids; mLocKids];
                end
            end; % end if-else
            
        elseif strcmp(sCriteria, 'CrossValidation')
            cv_obj = cvpartition(vTargets,'kfold',nTrainToTestFactor);            
            %load('../data/ATB/cv_obj');
            train_ind = cv_obj.training(params.CVNUM);
            test_ind = cv_obj.test(params.CVNUM);
           
            vTestTargets = cData(test_ind,:);
            cTestData = vTargets(test_ind,:);
            vTrainTargets = vTargets(train_ind,:);
            cTrainData = cData(train_ind,:);
            if(CONFIG_strParams.bKnownParsing)
                cTestKids = cKids(test_ind, :);
                cTrainKids = cKids(train_ind, :);
            end
            
        elseif strcmp(sCriteria, 'KnownSplit')

            train_ind = zeros(1180, 1);
            train_ind(237:end) = 1;
            train_ind = logical(full_train_ind);
            
            test_ind = zeros(1180, 1);
            test_ind(1:236) = 1;
            test_ind = logical(test_ind);
            
            vTestTargets = cData(test_ind,:);
            cTestData = vTargets(test_ind,:);
            vTrainTargets = vTargets(train_ind,:);
            cTrainData = cData(train_ind,:);
            if(CONFIG_strParams.bKnownParsing)
                cTestKids = cKids(test_ind, :);
                cTrainKids = cKids(train_ind, :);
            end
        end % end if-elseif
        

    end; % end for
    save(CONFIG_strParams.sDataSplitWorkspace, 'cTestData', 'vTestTargets', 'cTrainData', 'vTrainTargets', 'cTrainKids', 'cTestKids');
end % end function