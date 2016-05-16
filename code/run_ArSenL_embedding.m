clear, clc, close all;

global bKnownParses;
bKnownParses = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_ATB_ArSenL_embedding_Ready;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_ATB_ArSenL_embedding;