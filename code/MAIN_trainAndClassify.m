% Function:
% The main entry point to train and test Generic Deep ANN
% Inputs:
% None
% Output:
% None
function MAIN_trainAndClassify()    
    rand('state',0);
    % Load configurations
    global CONFIG_strParams;
    
    fprintf(1, 'Converting input files...\n');
	% Check the dataset used
	switch(CONFIG_strParams.sDataset)
        case 'ATB_Senti_RAE'
        	% The output of conversion is saved in CONFIG_strParams.sInputDataWorkspace
			[cData, vTargets, cKids, nDictionaryLength] = DCONV_convertATB_Senti_RAE();
            
        case 'Movie_Reviews'
            % TBD
            %[cData, vTargets, cKids] = DCONV_convertMovie_Reviews();
		otherwise
			% Do nothing
	end
	
	
    
    fprintf(1, 'Conversion done successfuly\n');
    
	fprintf(1, 'Splitting dataset into train and test sets...\n');
	[cTestData, vTestTargets, cTrainData, vTrainTargets, cTrainKids, cTestKids] = TTS_formTrainTestSets(cData, vTargets, cKids);
    
% 	switch (CONFIG_strParams.sInputFormat)
% 		case 'MatlabWorkspaceReadyTestTrainSplit'
% 			%load(CONFIG_strParams.sInputDataWorkspace);
% 			DPREP_strData.cTestData = cTestData;
% 			DPREP_strData.vTestTargets = vTestTargets;
% 			DPREP_strData.cTrainData = cTrainData;
% 			DPREP_strData.vTrainTargets = vTrainTargets;
%             clear cTestData vTestTargets cTrainData vTrainTargets;
%         %case 'CrossVal'
%             %TTS_formTrainTestSets_CV()
%         otherwise
% 			% Split into train and test sets
% 			[DPREP_strData.cTestData, DPREP_strData.vTestTargets, DPREP_strData.cTrainData, DPREP_strData.vTrainTargets] =... 
% 				TTS_formTrainTestSets(DPREP_strData.mFeatures,...
% 									  DPREP_strData.mTargets,...
% 									  CONFIG_strParams.sSplitCriteria,...
% 									  CONFIG_strParams.nTrainToTestFactor);
%                 
%                 %Save split data
%                 save(CONFIG_strParams.sInputDataWorkspace, '-struct', 'DPREP_strData', '-append',...
%                      'cTestData',...
%                      'vTestTargets',...
%                      'cTrainData',...
%                      'vTrainTargets');
%                 
%                 if(strcmp(CONFIG_strParams.sMemorySavingMode, 'ON'))
%                     % clear DPREP_strData.mFeatures DPREP_strData.mTargets;
%                     DPREP_strData.mFeatures = [];
%                     DPREP_strData.mTargets = [];
%                 end
%          
%     end
%     
	fprintf(1, 'Splitting done successfully\n');

    % Load auto label data if enabled
 	%[DPREP_strData.vTrainTargets, DPREP_strData.mAutoLabels] = DPREP_autoLabel(DPREP_strData.vTrainTargets, CONFIG_strParams);
 
	fprintf(1, 'Start learning process\n');
	switch(CONFIG_strParams.eClassifierType)
        case 'RAE'
            LM_startLearningProcessRAE(cTestData, vTestTargets, cTrainData, vTrainTargets, cTrainKids, cTestKids, nDictionaryLength);
             
	end % end switch
	fprintf(1, 'Learning process performed successfuly\n'); 
% 
% 
% 	if(CONFIG_strParams.bTestOnIndependentTestSet == 1)
% 		
% 		% Open log file
% 		hFidLog = fopen(CONFIG_strParams.sIndependentDataSetLogFile,'w');
% 		fprintf(1, 'Testing on independent data set...\n');
% 		fprintf(hFidLog, 'Testing on independent data set...\n');				
% 		
% 		fprintf(1, 'Converting input files...\n');
%     
% 		switch (CONFIG_strParams.sInputFormatOfIndependentTestSet)
% 			case 'MATLAB'
% 				% Convert raw data to matlab vars
% 				[mIndependentDataSetFeatures, mIndependentDataSetTargets] = DCONV_convertMatlabInput_Indepdataset_Binary();
% 			case 'TxtFile'
% 				% Convert raw data to matlab vars
% 				[mIndependentDataSetFeatures, mIndependentDataSetTargets] = DCONV_convert(CONFIG_strParams.sIndependentTestSetFeaturesFilePath);
% 			otherwise
% 				% Convert raw data to matlab vars
% 				[mIndependentDataSetFeatures, mIndependentDataSetTargets] = DCONV_convert(CONFIG_strParams.sIndependentTestSetFeaturesFilePath);
% 				
% 		end
% 
% 		% Save converted data
% 		save(CONFIG_strParams.sInputDataWorkspace,  '-append', 'mIndependentDataSetFeatures', 'mIndependentDataSetTargets');
% 		
% 		fprintf(1, 'Conversion done successfuly\n');
% 	
% 		[nErr, nConfusionErr, nErrRate, nConfusionErrRate] = TST_computeClassificationErr(hFidLog, mIndependentDataSetFeatures, mIndependentDataSetTargets, NM_strNetParams, SVM_strParams, CONFIG_strParams);
% 		
% 		fprintf(1, 'Testing on independent data set done successfuly\n');
% 		fprintf(hFidLog, 'Testing on independent data set done successfuly\n');
% 		
% 		fclose(hFidLog);
% 		
% 		% Save the current configuration in the error performance workspace
% 		save(CONFIG_strParams.sNameofErrWorkspace, '-append', 'nErr', 'nConfusionErr', 'nErrRate', 'nConfusionErrRate');
	end
end