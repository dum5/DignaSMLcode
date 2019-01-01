clear all
close all
clc

%In this version the following has been updated
% - Patient selection has changed according to what we agreed on in Sept 2018
% - Regressions are performed on normalized vectors, since BM on the non-normalized data depends on
%   magnitude in the stroke group (rho=-0.55, p=0.046).
% - We use the first 5 strides to characterize feedback-generated activity
% - The data table for individual subjects will be generated with all 16
%   subjects, such that different selections are possible in subsequent
%   analyses (set allSubFlag to 1)
% - Analyses on group median data are performed with allSubFlag at 0,
%   subject selection depends on speedMatchFlag


[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)

speedMatchFlag=1;
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

ep=defineEpochs({'BASE','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 nstrides -40 nstrides],[eE eE eE eE],[eL eL eL eL],summethod);
baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);

%extract data for stroke and controls separately
padWithNaNFlag=false;

[CdataEMG,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
[CBB,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);
CdataEMG=CdataEMG-CBB; %Removing base

[SdataEMG,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
[SBB,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);
SdataEMG=SdataEMG-SBB; %Removing base

%replace SOL muscles PT 5 with zeros to minimize effect of loose sensor
labels2=labels(:);
Index = find(contains(labels2,'SOL'));%find all Soleus muscle data in the labels
ptIdx=find(contains(strokesNames,'P0005'));
SdataEMG(Index,:,ptIdx)=0;%I checked this and it indeed removes all the large peaks from the subject data, regardles of which subs are selected

%Flipping EMG:
CdataEMG=reshape(flipEMGdata(reshape(CdataEMG,size(labels,1),size(labels,2),size(CdataEMG,2),size(CdataEMG,3)),1,2),numel(labels),size(CdataEMG,2),size(CdataEMG,3));
SdataEMG=reshape(flipEMGdata(reshape(SdataEMG,size(labels,1),size(labels,2),size(SdataEMG,2),size(SdataEMG,3)),1,2),numel(labels),size(SdataEMG,2),size(SdataEMG,3));

%% Get all the eA, lA, eP vectors
shortNames={'lB','eA','lA','eP'};
longNames={'BASE','eA','lA','eP'};
for i=1:length(shortNames)
    aux=squeeze(CdataEMG(:,strcmp(ep.Properties.ObsNames,longNames{i}),:));
    eval([shortNames{i} '_C=aux;']);
    
    aux=squeeze(SdataEMG(:,strcmp(ep.Properties.ObsNames,longNames{i}),:));
    eval([shortNames{i} '_S=aux;']);
end
clear aux

nsub=size(eA_C,2);

emptycol=NaN(nsub,1);
emptycol2=cell(size(emptycol));

AmpControls=table(emptycol2,emptycol2,emptycol,emptycol,emptycol,emptycol,'VariableNames',{'group','sub','eA','lA','eP_lA','eP'});
AmpStroke=table(emptycol2,emptycol2,emptycol,emptycol,emptycol,emptycol,'VariableNames',{'group','sub','eA','lA','eP_lA','eP'});

for sj=1:nsub
        AmpControls.group(sj)={'Control'};
        AmpStroke.group(sj)={'Stroke'};
        ccode = controlsNames(sj);
        scode = strokesNames(sj);
        AmpControls.sub(sj)=ccode;
        AmpStroke.sub(sj)=scode;
        
        AmpControls.eA(sj)=norm(eA_C(:,sj));
        AmpStroke.eA(sj)=norm(eA_S(:,sj));
        AmpControls.lA(sj)=norm(lA_C(:,sj));
        AmpStroke.lA(sj)=norm(lA_S(:,sj));
        AmpControls.eP_lA(sj)=norm(eP_C(:,sj)-lA_C(:,sj));
        AmpStroke.eP_lA(sj)=norm(eP_S(:,sj)-lA_S(:,sj));
        AmpControls.eP(sj)=norm(eP_C(:,sj));
        AmpStroke.eP(sj)=norm(eP_S(:,sj));
end


if speedMatchFlag==0;
    AmpControlsFull=AmpControls;
    AmpStrokeFull=AmpStroke;
    save([matDataDir,'AmpDataFull'],'AmpControlsFull','AmpStrokeFull');
elseif speedMatchFlag==1
    AmpControlsSpM=AmpControls;
    AmpStrokeSpM=AmpStroke;
    save([matDataDir,'AmpDataSpM'],'AmpControlsSpM','AmpStrokeSpM');
end
