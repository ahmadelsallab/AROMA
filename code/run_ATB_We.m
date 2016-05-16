clear, clc, close all;

global bKnownParses;
bKnownParses = 1;
bPrintParseTrees = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_ATB_We;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_ATB_We;