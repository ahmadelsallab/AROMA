clear, clc, close all;

fprintf(1, 'Configuring...\n');

% Start Configuration
%CONFIG_setConfigParams_RAE()
CONFIG_setConfigParams_ArSenL_Embedding();
global CONFIG_strParams;
fprintf(1, 'Configuration done successfuly\n');

% Change directory to go there
cd(CONFIG_strParams.sDefaultClassifierPath);

if(CONFIG_strParams.bConvertWord2Vec)
    load_word_2_vec;
end

% Call main entry function of the classifier
MAIN_trainAndClassify();
