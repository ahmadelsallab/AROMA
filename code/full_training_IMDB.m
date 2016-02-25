clear, clc, close all;


DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\';

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(DBNPath);

run_SentiWordNet_Embedding;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);
run_IMDB_We;
DBNPath = '..\..\..\..\Code\sentimentanalysis\classifiers\Configurations\';
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd(DBNPath);

% The output files are generated in the folder IMDB_SentiWordNet_We
% we have to move them to the folders IMDB_SentiWordNet_Embedding and
% IMDB_SentiWordNet_We and rename them.
copyfile(['vocab_SentiWordNet_Embedding.mat'], [RAEPath '\data\IMDB_SentiWordNet_Embedding\']);
copyfile(['vocab_We.mat'], [RAEPath '\data\IMDB_We\']);
%movefile([RAEPath '\data\IMDB_We\vocab_SentiWordNet_Embedding.mat'], [RAEPath '\data\IMDB_We\vocab_We.mat']);
copyfile(['final_net_We.mat'], [RAEPath '\data\IMDB_We\']);
movefile([RAEPath '\data\IMDB_We\final_net_We.mat'], [RAEPath '\data\IMDB_We\final_net.mat']);
copyfile(['final_net_SentiWordNet_embedding.mat'], [RAEPath '\data\IMDB_SentiWordNet_Embedding\']);
movefile([RAEPath '\data\IMDB_SentiWordNet_Embedding\final_net_SentiWordNet_embedding.mat'], [RAEPath '\data\IMDB_SentiWordNet_Embedding\final_net.mat']);
copyfile(['input_data_SentiWordNet_Embedding_1.mat'], [RAEPath '\data\IMDB_SentiWordNet_Embedding\']);
copyfile(['input_data_We_2.mat'], [RAEPath '\data\IMDB_We\']);

%%%%%%%%%%%%%%%%%%%%%%%%% RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% SentiWordNet EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%
cd([RAEPath '\code\']);
run_SentiWordNet_Embedding;
training_instances_SentiWordNet_Embedding = training_instances;
testing_instances_SentiWordNet_Embedding = testing_instances;
save('..\..\..\..\OMA\Code\RAE\data\IMDB_SentiWordNet_Embedding', 'training_instances_SentiWordNet_Embedding', 'testing_instances_SentiWordNet_Embedding', 'training_labels', 'testing_labels');

%%%%%%%%%%%%%%%%%%%%%%%%% Word EMBEDDING TRAINING %%%%%%%%%%%%%%%%%%%%
RAEPath = '..\..\..\..\OMA\Code\RAE\';
cd([RAEPath '\code\']);
run_IMDB_We;
training_instances_We = training_instances;
testing_instances_We = testing_instances;
save('..\..\..\..\OMA\Code\RAE\data\IMDB_We', 'training_instances_We', 'testing_instances_We', 'training_labels', 'testing_labels');

%%%%%%%%%%%%%%%%%%%%%%%%% Softmax %%%%%%%%%%%%%%%%%%%%
load('..\..\..\..\OMA\Code\RAE\data\IMDB_SentiWordNet_Embedding', 'training_instances_SentiWordNet_Embedding', 'testing_instances_SentiWordNet_Embedding', 'training_labels', 'testing_labels');
load('..\..\..\..\OMA\Code\RAE\data\IMDB_We', 'training_instances_We', 'testing_instances_We');
softmax_Decision_Level;