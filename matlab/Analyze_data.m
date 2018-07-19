%% define search key word or expression
lookfor='Russia';

%% preprocess search key word or expression
swordall = preprocessWeatherNarratives(lookfor);
sword=swordall.Vocabulary;

% sword={'facebook';'scandal'};
np=numel(sword);

words = sword;
    idx = ~ismember(emb,words);
    words(idx) = [];
    C = word2vec(emb,words)';
    dmat=[];
    for kin=1:numel(XTrain)
        doc=XTrain{kin};
        dv=pdist2(C',doc');
        dvs=sort(dv,2);
%         mean(dv,2)
        dmat(kin,:)= mean(dvs(:,1:round(.25*size(dv,2))),2)';        
    end
    
    idx=find(mean(dmat,2)<1.9);
    
%% Preprocessing articles titles  
    desk = preprocessWeatherNarratives(data.Description);

% deskLengths = doclength(desk);
% figure
% histogram(deskLengths)
% title("Document Lengths")
% xlabel("Length")
% ylabel("Number of Documents")

%% Limiting text size in each articles tilte
sequenceLength = 30;
deskTruncatedTrain = docfun(@(words) words(1:min(sequenceLength,end)),desk);

%% Convertice articles title to numbers
deskTrain = doc2sequence(emb,deskTruncatedTrain);

    dmat2=[];
    for kin=1:numel(deskTrain)
        doc=deskTrain{kin};
        dv=pdist2(C',doc');
        dvs=sort(dv,2);
        dmat2(kin,:)= mean(dvs(:,1:round(.3*size(dv,2))),2)';          
    end
    
    idx2=find(min(dmat2,[],2)<1.8);

%% Removing duplicate articles   
%     data.Description
    [C,IA,IC] = unique(data.Description,'stable')
dataF=data(IA,:);
dmat2=dmat2(IA,:);
dmat=dmat(IA,:);
% score=(min(dmat2,[],2)*.5+min(dmat,[],2)*.5);

%% Final distance score based on titles and description
score=(mean(dmat2,2)*.55+mean(dmat,2)*.45);

%% Keeping articles less than a threshold
idx3=find(score<=2.15);

%% Printing selected articles URL
unique(dataF.URL(idx3))
