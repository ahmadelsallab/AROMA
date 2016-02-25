clear, clc, close all;


DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\';

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(DBNPath);
run_We;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);

copyfile(['vocab_We.mat'], [RAEPath '\data\ATB_We\'], 'f');
copyfile(['final_net_We.mat'], [RAEPath '\data\ATB_We\'], 'f');
copyfile(['input_data_We_2.mat'], [RAEPath '\data\ATB_We\'], 'f');
movefile([RAEPath '\data\ATB_We\final_net_We.mat'], [RAEPath '\data\ATB_We\final_net.mat'], 'f');

%%%%%%%%%%%%%%%%%%%%%%%%% RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd([RAEPath '\code\']);
run_ATB_We;