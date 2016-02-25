clear, clc, close all;

global bKnownParses;
bKnownParses = 1;
global bPrintParseTree;
bPrintParseTree = 0;
global parseTreesWorkspace;
parseTreesWorkspace = '..\data\IMDB_SentiWordNet_Embedding\parse_trees.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_IMDB_SentiWordNet_embedding_Ready;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_IMDB_SentiWordNet_embedding;