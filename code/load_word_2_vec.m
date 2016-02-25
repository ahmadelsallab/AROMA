vocab_file_name = '..\..\Datasets\Embedding files\Qalb_ATB\50\minCount_5\vocab_atb_qalb50.tok';
vocab_workspace = '..\..\Datasets\Embedding files\Qalb_ATB\50\vocab.mat';
word_vecotrs_file_name = '..\..\Datasets\Embedding files\Qalb_ATB\50\minCount_5\vectors_atb_qalb50.tok';
emebdding_workspace = '..\..\Datasets\Embedding files\Qalb_ATB\50\We.mat';

%%%% Load vocabulary %%%%%%%
fprintf('Loading vocabulary\n');
vocab_file = fopen(vocab_file_name);

word = fgetl(vocab_file);

cWords = {};
count = 1;
while(word > 0)
    
   cWords = [cWords; word]; 
   word = fgetl(vocab_file);
   fprintf(1, 'Reading word number %d\n', count);
   count = count + 1;
   
end

save(vocab_workspace, 'cWords');


%%%%%% Load vectors %%%%%
fprintf('Loading word vectors\n');
vectors = load(word_vecotrs_file_name);
vectors = [vectors; rand(1, size(vectors, 2))];
NM_strNetParams.cWeights{1} = vectors;
save(emebdding_workspace, 'NM_strNetParams');