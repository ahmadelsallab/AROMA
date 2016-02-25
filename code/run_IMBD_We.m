clear, clc, close all;

global bKnownParses;
bKnownParses = 1;
global bPrintParseTrees;
bPrintParseTrees = 1;
global parseTreesWorkspace;
parseTreesWorkspace = '..\data\IMDB_We\parse_trees.mat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_IMDB_We;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_IMDB_We;