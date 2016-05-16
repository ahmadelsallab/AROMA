clear, clc, close all;

global bKnownParses;
bKnownParses = 1;
global bPrintParseTree;
bPrintParseTree = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_ATB_for_RAE;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_ATB;