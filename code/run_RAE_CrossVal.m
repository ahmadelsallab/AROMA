clear, clc, close all;

fprintf(1, 'Configuring...\n');

% Start Configuration
CONFIG_setConfigParams_RAE()
global CONFIG_strParams;
for i = 1 : CONFIG_strParams.nTrainToTestFactor
           
    CONFIG_strParams.RAEParams.CVNUM = i;
    fprintf(1, 'Configuration done successfuly\n');

    % Change directory to go there
    cd(CONFIG_strParams.sDefaultClassifierPath);

    if(CONFIG_strParams.bConvertWord2Vec)
        load_word_2_vec;
    end

    % Call main entry function of the classifier
    MAIN_trainAndClassify();
end