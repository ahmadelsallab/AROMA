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
function [cTestData, vTestTargets, cTrainData, vTrainTargets, cTrainKids, cTestKids] = TTS_formTrainTestSets(cData, vTargets, cKids)
    
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


        
        % Read the raw features and targets according to split criteria
        if strcmp(sCriteria, 'random')
            for b = 1 : size(cData,1)
                fprintf(1, 'Splitting example %d\n', b);
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
            end
        elseif strcmp(sCriteria, 'uniform')
            for b = 1 : size(cData,1)
                fprintf(1, 'Splitting example %d\n', b);
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
            end
        elseif strcmp(sCriteria, 'CrossValidation')
            cv_obj = cvpartition(vTargets,'kfold',nTrainToTestFactor);            
            %load('../data/ATB/cv_obj');
            train_ind = cv_obj.training(CONFIG_strParams.RAEParams.CVNUM);
            test_ind = cv_obj.test(CONFIG_strParams.RAEParams.CVNUM);
           
            cTestData= cData(test_ind,:);
            vTestTargets = vTargets(test_ind,:);
            vTrainTargets = vTargets(train_ind,:);
            cTrainData = cData(train_ind,:);
            if(CONFIG_strParams.bKnownParsing)
                cTestKids = cKids(test_ind, :);
                cTrainKids = cKids(train_ind, :);
            end
            
        elseif strcmp(sCriteria, 'KnownSplit')

            train_ind = zeros(CONFIG_strParams.nDatasetSize, 1);
            train_ind(CONFIG_strParams.nTestsetIndex + 1:end) = 1;
            train_ind = logical(full_train_ind);
            
            test_ind = zeros(CONFIG_strParams.nDatasetSize, 1);
            test_ind(1:CONFIG_strParams.nTestsetIndex) = 1;
            test_ind = logical(test_ind);
            
            cTestData = cData(test_ind,:);
            vTestTargets = vTargets(test_ind,:);
            vTrainTargets = vTargets(train_ind,:);
            cTrainData = cData(train_ind,:);
            if(CONFIG_strParams.bKnownParsing)
                cTestKids = cKids(test_ind, :);
                cTrainKids = cKids(train_ind, :);
            end
        end % end if-elseif

    vTrainTargets = vTrainTargets';
    vTestTargets = vTestTargets';
    save(CONFIG_strParams.sDataSplitWorkspace, 'cTestData', 'vTestTargets', 'cTrainData', 'vTrainTargets', 'cTrainKids', 'cTestKids');
end % end function