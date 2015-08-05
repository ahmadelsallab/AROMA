clear, clc, close all;


DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\';

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(DBNPath);
run_ArSenL_We;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);

copyfile(['vocab_ArSenL_Embedding.mat'], [RAEPath '\data\ATB_ArSenL_We\']);
copyfile(['final_net_We.mat'], [RAEPath '\data\ATB_ArSenL_We\']);
copyfile(['final_net_ArSenL_embedding.mat'], [RAEPath '\data\ATB_ArSenL_We\']);
copyfile(['input_data_ArSenL_Embedding_1.mat'], [RAEPath '\data\ATB_ArSenL_We\']);

%%%%%%%%%%%%%%%%%%%%%%%%% RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd([RAEPath '\code\']);
run_ArSenL_We;