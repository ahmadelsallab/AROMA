clear, clc, close all;


DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\';

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(DBNPath);
% Set bReadyVocab = 0; inside run_ArSenL_We-->run_We 
% so that the word embedding training is done without ArSenL lexicon
run_ArSenL_We;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);

% The output files are generated in the folder ATB_ArSenL_We
% we have to move them to the folders ATB_ArSenL_Embedding and
% ATB_ArSenL_We and rename them.
copyfile(['vocab_ArSenL_Embedding.mat'], [RAEPath '\data\ATB_ArSenL_Embedding\']);
copyfile(['vocab_We.mat'], [RAEPath '\data\ATB_We\']);
%movefile([RAEPath '\data\ATB_We\vocab_ArSenL_Embedding.mat'], [RAEPath '\data\ATB_We\vocab_We.mat']);
copyfile(['final_net_We.mat'], [RAEPath '\data\ATB_We\']);
%movefile([RAEPath '\data\ATB_We\final_net_We.mat'], [RAEPath '\data\ATB_We\final_net.mat']);
copyfile(['final_net_ArSenL_embedding.mat'], [RAEPath '\data\ATB_ArSenL_Embedding\']);
%movefile([RAEPath '\data\ATB_ArSenL_Embedding\final_net_ArSenL_embedding.mat'], [RAEPath '\data\ATB_ArSenL_Embedding\final_net.mat']);
copyfile(['input_data_ArSenL_Embedding_1.mat'], [RAEPath '\data\ATB_ArSenL_Embedding\']);
copyfile(['input_data_We_2.mat'], [RAEPath '\data\ATB_We\']);

%%%%%%%%%%%%%%%%%%%%%%%%% RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% ArSenL EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%
cd([RAEPath '\code\']);
run_ArSenL_Embedding;
training_instances_ArSenL_Embedding = training_instances;
testing_instances_ArSenL_Embedding = testing_instances;
save('..\..\..\..\OMA\Code\RAE\data\ATB_ArSenL_Embedding', 'training_instances_ArSenL_Embedding', 'testing_instances_ArSenL_Embedding', 'training_labels', 'testing_labels');

%%%%%%%%%%%%%%%%%%%%%%%%% Word EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd([RAEPath '\code\']);
run_ATB_We;
training_instances_We = training_instances;
testing_instances_We = testing_instances;
save('..\..\..\..\OMA\Code\RAE\data\ATB_We', 'training_instances_We', 'testing_instances_We', 'training_labels', 'testing_labels');

%%%%%%%%%%%%%%%%%%%%%%%%% Softmax %%%%%%%%%%%%%%%%%%%%
load('..\..\..\..\OMA\Code\RAE\data\ATB_ArSenL_Embedding', 'training_instances_ArSenL_Embedding', 'testing_instances_ArSenL_Embedding', 'training_labels', 'testing_labels');
load('..\..\..\..\OMA\Code\RAE\data\ATB_We', 'training_instances_We', 'testing_instances_We');
softmax_Decision_Level;