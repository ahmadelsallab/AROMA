clear, clc, close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS ATB WITH ARSENL VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preprocess_ATB_ArSenL_We; % Same as preprocess_ATB_ArSenL_embedding_Ready.m




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_ATB_ArSenL_We_Decision_Level_Merge;

%%% Equivalent, to be conformant with the visio diagram
%run_ArSenL_embedding;
%run_ATB_We;
%testRAE_ATB_ArSenL_We_Decision_Level_Merge;