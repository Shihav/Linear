clear all;close all;clc
% 
% %% loading default word to vector table

%% We need to have a word to vector conversion table to load (which is normally learned by deep learning analyzing wiki pidia and twitter at Glove website).
%% In matlab they have a default one much lighter. Which we are now loading 
%% loading default word to vector table
emb=fastTextWordEmbedding;
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
%% Reading the save articles (Loading some samples articles)
srcin='..\Data';
out1=rdir([srcin '\**\*.xlsx']);
data=[];
for kin=1:numel(out1)
filename = out1(kin).name;
datat = readtable(filename,'TextType','string');
data=[data;datat];
end
%head(data);

%% Removing duplicate articles
[~,IA,~] = unique(data.URL,'stable');
data=data(IA,:);
idx = strlength(data.URL) == 0;
data(idx,:) = [];

%% Here we will initially analyze 95% of the text to generate the already formed dataset. and 5% to look for any new potential timelines
rndidx=randperm(size(data,1));
mainid=rndidx(1:round(length(rndidx)*.95));
newid=rndidx(round(length(rndidx)*.95)+1:end);

ndata=data;
data=data(mainid,:); %old data
ndata=ndata(newid,:); %new data

%% Preprocessing articles descriptions
% this step included prepressing the documents for removing stop words,
% prepositions, punctuations etc.
documents = preprocessWeatherNarratives(data.Text);

%% Limiting text size in each articles
% we could limit the main text of the atricles to a certain length if it is
% too big. These are not really necessary to
% do
sequenceLength = 1500;
documentsTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),documents);

%% Convertice articles to numbers
% now we convert the whole text of each articles into numbers
XTrain = doc2sequence(emb,documentsTruncatedTrain);

%% Preprocessing articles titles  
% The word Description is actually used to represent titles here. It is a
% bit confusing sometimes.
    desk = preprocessWeatherNarratives(data.Description);

%% Limiting text size in each articles tilte
% we limit the title to maximum 50 words. These are not really necessary to
% do
sequenceLength = 50;
deskTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),desk);

%% Convertice articles title to numbers
deskTrain = doc2sequence(emb,deskTruncatedTrain);

%% we keep the unprocessed words of the title to make the timelines look more realistic
Titles = preprocessWeatherNarratives(data.Description);
%Titles = deskTrain;

%% We are looking for 2 word or 3 word phrases that are unique and more frequent that normalized threshold values

bag2 = bagOfNgrams(Titles,'NgramLengths',2);
bag2 = removeInfrequentNgrams(bag2,ceil(0.02*size(Titles,1)/2)+1);
val2=topkngrams(bag2, size(bag2.Ngrams,1)+1)

% bag1 = bagOfNgrams(Titles,'NgramLengths',1);
% bag1 = removeInfrequentNgrams(bag1,ceil(0.02*size(Titles,1)/.5));
% topkngrams(bag1, size(bag1.Ngrams,1))

bag3 = bagOfNgrams(Titles,'NgramLengths',3);
bag3 = removeInfrequentNgrams(bag3,ceil(0.02*size(Titles,1)/4)+1);
val3=topkngrams(bag3, size(bag3.Ngrams,1)+1)

Alookfor=[];
kin2=1;
for kin=1:size(val2.Ngram,1)
    phs=[val2.Ngram{kin,1} ' ' val2.Ngram{kin,2}];  
    Alookfor{kin2,1}=phs;
    kin2=kin2+1;
end

for kin=1:size(val3.Ngram,1)
    phs=[val3.Ngram{kin,1} ' ' val3.Ngram{kin,2} ' ' val3.Ngram{kin,3}];  
    Alookfor{kin2,1}=phs;
    kin2=kin2+1;
end

%% Making the final list of timeline expressions
%% define search key word or expression
for sc=1:kin2-1
lookfor=Alookfor{sc,1}

%% for each of the found times now will find the relavent texts from the old database
%% preprocess search key word or expression
swordall = preprocessWeatherNarratives(lookfor);
sword=swordall.Vocabulary;
np=numel(sword);
words = sword;
    idx = ~ismember(emb,words); %% here we remove the words that is not in the conversion dictionary
    words(idx) = [];
    C = word2vec(emb,words)';
    
%% distance from text   
    dmat=[];
    for kin=1:numel(XTrain)
        doc=XTrain{kin};
        dv=pdist2(C',doc'); % findiing the distance from each articles to the search key words
        dvs=sort(dv,2);
%         mean(dv,2)
        dmat(kin,:)= mean(dvs(:,1:round(.25*size(dv,2))),2)';    % best 25% similar word distance is taken and the mean of the,m is the final output    
    end    

%% distance from title is done in the similar way ike the main text 
dmat2=[];
    for kin=1:numel(deskTrain)
        doc=deskTrain{kin};
        dv=pdist2(C',doc');
        dvs=sort(dv,2);
        dmat2(kin,:)= mean(dvs(:,1:round(.3*size(dv,2))),2)'; % best 30% similar word distance is taken and the mean of the,m is the final output           
    end    

%% Removing duplicate articles   
    [C,IA,IC] = unique(data.Description,'stable');
dataF=data(IA,:);
dmat2=dmat2(IA,:);
dmat=dmat(IA,:);

%% Final distance score based on titles and description
score=(mean(dmat2,2)*.65+mean(dmat,2)*.35);

%% Keeping articles less than a threshold
idx3=find(score<=2);

%% Printing selected articles URL
unique(dataF.Description(idx3))

end


%%
%% getting new data %%
%%


%% Preprocessing articles descriptions
ndocuments = preprocessWeatherNarratives(ndata.Text);

%% Limiting text size in each articles
sequenceLength = 1500;
ndocumentsTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),ndocuments);

%% Convertice articles to numbers
nXTrain = doc2sequence(emb,ndocumentsTruncatedTrain);

%% Preprocessing articles titles  
    ndesk = preprocessWeatherNarratives(ndata.Description);

%% Limiting text size in each articles tilte
sequenceLength = 50;
ndeskTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),ndesk);

%% Convertice articles title to numbers
ndeskTrain = doc2sequence(emb,ndeskTruncatedTrain);

%% Everything now similarly done of the new 5% articles as described ourlier in a normalized fashion, so it should give any possible new timeline if occurs.
nTitles = preprocessWeatherNarratives(ndata.Description);

nbag2 = bagOfNgrams(nTitles,'NgramLengths',2);
nbag2 = removeInfrequentNgrams(nbag2,ceil(0.02*size(nTitles,1)/2)+1);
nval2 = topkngrams(nbag2, size(nbag2.Ngrams,1)+1)

nbag3 = bagOfNgrams(nTitles,'NgramLengths',3);
nbag3 = removeInfrequentNgrams(nbag3,ceil(0.02*size(nTitles,1)/4)+1);
nval3 = topkngrams(nbag3, size(nbag3.Ngrams,1)+1)

nAlookfor=[];
kin2=1;
for kin=1:size(nval2.Ngram,1)
    phs=[nval2.Ngram{kin,1} ' ' nval2.Ngram{kin,2}];  
    nAlookfor{kin2,1}=phs;
    kin2=kin2+1;
end

for kin=1:size(nval3.Ngram,1)
    phs=[nval3.Ngram{kin,1} ' ' nval3.Ngram{kin,2} ' ' nval3.Ngram{kin,3}];  
    nAlookfor{kin2,1}=phs;
    kin2=kin2+1;
end

%% define search key word or expression
for sc=1:kin2-1
lookfor=nAlookfor{sc,1}
%% preprocess search key word or expression
swordall = preprocessWeatherNarratives(lookfor);
sword=swordall.Vocabulary;
np=numel(sword);
words = sword;
    idx = ~ismember(emb,words);
    words(idx) = [];
    C = word2vec(emb,words)';
    
%% distance from text   
    ndmat=[];
    for kin=1:numel(nXTrain)
        doc=nXTrain{kin};
        dv=pdist2(C',doc');
        dvs=sort(dv,2);
%         mean(dv,2)
        ndmat(kin,:)= mean(dvs(:,1:round(.25*size(dv,2))),2)';        
    end    

%% distance from title    
ndmat2=[];
    for kin=1:numel(ndeskTrain)
        doc=ndeskTrain{kin};
        dv=pdist2(C',doc');
        dvs=sort(dv,2);
        ndmat2(kin,:)= mean(dvs(:,1:round(.3*size(dv,2))),2)';          
    end    

%% Removing duplicate articles   
    [C,IA,IC] = unique(ndata.Description,'stable');
ndataF=ndata(IA,:);
ndmat2=ndmat2(IA,:);
ndmat=ndmat(IA,:);

%% Final distance score based on titles and description
score=(mean(ndmat2,2)*.65+mean(ndmat,2)*.35);

%% Keeping articles less than a threshold
idx3=find(score<=2);

%% Printing selected articles URL
unique(ndataF.Description(idx3))

end
