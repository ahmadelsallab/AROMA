clear, clc, close all;


DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\';

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(DBNPath);
run_We;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);

copyfile(['vocab_We.mat'], [RAEPath '\data\ATB_We\']);
copyfile(['final_net_We.mat'], [RAEPath '\data\ATB_We\']);
copyfile(['input_data_We_2.mat'], [RAEPath '\data\ATB_We\']);

%%%%%%%%%%%%%%%%%%%%%%%%% RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd([RAEPath '\code\']);
run_ATB_We;