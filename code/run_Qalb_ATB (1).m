clear, clc, close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESS QALB AND ATB VOCABULARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To change the number of sentences parse from Qalb, go into preprocess_Qalb_ATB.m and change nSentences.
% Max. nSentences = 566000
preprocess_ATB;
preprocess_Qalb_ATB;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN RAE TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainTestRAE_Qalb_ATB;