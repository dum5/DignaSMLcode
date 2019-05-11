%clear all
%close all
clc

%[loadName,matDataDir]=uigetfile('*.mat');
%loadName=[matDataDir,loadName]; 
%load(loadName)


[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)

speedMatchFlag=0;
allSubFlag=0;%Needed to run SubjectSelection script
%this needs to happen separately, since indices will be messed up ohterwise

groupMedianFlag=1; %do not change
nstrides=5;% do not change for early epochs
summethod='nanmedian';% do not change

SubjectSelection% subjectSelection has moved to different script to avoid mistakes accross scripts

pIdx=1:length(strokesNames);
cIdx=1:length(controlsNames);

%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);
sNames=strokesNames;
cNames=controlsNames;

%% Get normalized parameters:
%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%mOrder={'TA','SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF'};
nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names

%Renaming normalized parameters, for convenience:
for k=1:length(groups)
    ll=groups{k}.adaptData{1}.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
    groups{k}=groups{k}.renameParams(ll,l2);
end
newLabelPrefix=fliplr(strcat(labelPrefix,'s'));

eE=1;
eL=1;

ep=defineEpochs({'BASE','eA','lA','eP','eB','lS'},{'TM base','Adaptation','Adaptation','Washout','TM base','short split'},[-40 nstrides -40 nstrides nstrides -8],[eE eE eE eE eE eE],[eL eL eL eL eL eL],summethod);
refEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);

%extract data for stroke and controls separately
padWithNaNFlag=false;

for i = 10%1:n_subjects
    adaptDataSubject = groups{2}.adaptData{i}; 
    
%     %
%     
%     ll=adaptDataSubject.data.getLabelsThatMatch('^Norm');
%      l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
%      adaptDataSubject=adaptDataSubject.renameParams(ll,l2);
%      newLabelPrefix=fliplr(strcat(labelPrefix,'s'));
    

    fh=figure('Units','Normalized','OuterPosition',[0 0 1 1]);
    %ph=tight_subplot(2,length(ep)+1,[.03 .005],.04,.04);
    ph=tight_subplot(2,length(ep),[.03 .005],.04,.04);
    
    flip=true;

    adaptDataSubject.plotCheckerboards(newLabelPrefix,ep,fh,ph(1,:),[],flip); %First, plot reference epoch:   
    [~,~,labels,dataE{1},dataRef{1}]=adaptDataSubject.plotCheckerboards(newLabelPrefix,ep,fh,ph(2,:),refEp,flip);%Second, the rest:

    set(ph(:,1),'CLim',[-1 1]);
    set(ph(:,2:end),'YTickLabels',{},'CLim',[-0.5 0.5]);
    set(ph,'FontSize',8)
    pos=get(ph(1,end),'Position');
    axes(ph(1,end))
    colorbar
    set(ph(1,end),'Position',pos);
    
    
end