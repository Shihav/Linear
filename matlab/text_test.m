% clear all
% close all
% clc
% 
% % load 'wiki-news-300d-1M.vec'
% % 
% filename = "glove.6B.300d";
% if exist(filename + '.mat', 'file') ~= 2
%     emb = readWordEmbedding(filename + '.txt');
%     save(filename + '.mat', 'emb', '-v7.3');
% else
%     load(filename + '.mat')
% end
% v_king = word2vec(emb,'king')';
% q_queen = word2vec(emb,'queen')';
% q_coffee = word2vec(emb,'coffee')';
% whos v_king

src='C:\ENS\the-news-website\Data';
out1=rdir([src '\**\*.xlsx']);
out1(9)=[];
data=[];
for kin=1:numel(out1)


filename = out1(kin).name;
datat = readtable(filename,'TextType','string');
data=[data;datat];
end
head(data)

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

bag = bagOfWords(documents)

bag = removeInfrequentWords(bag,2);
bag = removeEmptyDocuments(bag)

numTopics = 3;
mdl = fitlda(bag,numTopics);

figure;
for topicIdx = 1:3
    subplot(2,2,topicIdx)
    wordcloud(mdl,topicIdx);
    title("Topic: " + topicIdx)
end

newDocument = tokenizedDocument("A tree is downed outside Apple Hill Drive, Natick");
topicMixture = transform(mdl,newDocument);
figure
bar(topicMixture)
xlabel("Topic Index")
ylabel("Probabilitiy")
title("Document Topic Probabilities")

figure
topicMixtures = transform(mdl,documents(1:10));
barh(topicMixtures(1:10,:),'stacked')
xlim([0 1])
title("Topic Mixtures")
xlabel("Topic Probability")
ylabel("Document")