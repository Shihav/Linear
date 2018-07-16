clear all
close all
clc

% load 'wiki-news-300d-1M.vec'
% 
% filename = "glove.6B.300d";
% if exist(filename + '.mat', 'file') ~= 2
%     emb = readWordEmbedding(filename + '.txt');
%     save(filename + '.mat', 'emb', '-v7.3');
% else
%     load(filename + '.mat')
% end

emb=fastTextWordEmbedding;
v_king = word2vec(emb,'king')';
q_queen = word2vec(emb,'queen')';
q_coffee = word2vec(emb,'coffee')';
whos v_king

src='C:\ENS\the-news-website\Data';
out1=rdir([src '\**\*.xlsx']);
% out1(10)=[];
data=[];
for kin=1:numel(out1)


filename = out1(kin).name;
datat = readtable(filename,'TextType','string');
data=[data;datat];
end
head(data)

[C,IA,IC] = unique(data.URL,'stable')
data=data(IA,:);


idx = strlength(data.URL) == 0;
data(idx,:) = [];
data.Section = categorical(data.Section);
figure
h = histogram(data.Section);
xlabel("Class")
ylabel("Frequency")
title("Class Distribution")
data.Description

documents = preprocessWeatherNarratives(data.Text);
documents(1:5)

bag = bagOfNgrams(documents)

figure
wordcloud(bag);
title("Weather Reports: Preprocessed Bigrams")

mdl = fitlda(bag,10);
figure
for i = 1:4
    subplot(2,2,i)
    wordcloud(mdl,i);
    title("LDA Topic " + i)
end

cleanTextData = erasePunctuation(data.Text);
documents2 = tokenizedDocument(cleanTextData);

bag = bagOfNgrams(documents2,'NGramLengths',3);

figure
wordcloud(bag);
title("Weather Reports: Trigrams")

tbl = topkngrams(bag,10)


documentLengths = doclength(documents);
figure
histogram(documentLengths)
title("Document Lengths")
xlabel("Length")
ylabel("Number of Documents")

sequenceLength = 500;
documentsTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),documents);

XTrain = doc2sequence(emb,documentsTruncatedTrain);