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

speedMatchFlag=0;
allSubFlag=0;%use this flag to generate the table that includes all subjects
%this needs to happen separately, since indices will be messed up ohterwise

groupMedianFlag=1; %do not change
nstrides=5;% do not change
summethod='nanmedian';% do not change
nIt=10000;


SubjectSelection% subjectSelection has moved to different script to avoid mistakes accross scripts

pIdx=1:length(strokesNames);
cIdx=1:length(controlsNames);

%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);

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

ep=defineEpochs({'BASE','eA','lA','eP','slow'},{'TM base','Adaptation','Adaptation','Washout','TM slow'},[-40 nstrides -40 nstrides -40],[eE eE eE eE eE],[eL eL eL eL eL],summethod);
baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);

%extract data for stroke and controls separately
padWithNaNFlag=false;

[CdataEMG,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
[CBB,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);
%CdataEMG=CdataEMG-CBB; %Removing base

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
shortNames={'lB','eA','lA','eP','slow'};
longNames={'BASE','eA','lA','eP','slow'};
for i=1:length(shortNames)
    aux=squeeze(CdataEMG(:,strcmp(ep.Properties.ObsNames,longNames{i}),:));
    eval([shortNames{i} '_C=aux;']);
    
    aux=squeeze(SdataEMG(:,strcmp(ep.Properties.ObsNames,longNames{i}),:));
    eval([shortNames{i} '_S=aux;']);
end
clear aux

%compute eAT
eAT_C=fftshift(eA_C,1);
eAT_S=fftshift(eA_S,1);

fastIdx=find(startsWith(labels,'f'));
slowIdx=find(startsWith(labels,'s'));
ePlA_C=eP_C-lA_C;
ePlA_S=eP_S-lA_S;



%do bootstrap for all vectors
% [Bdata.eAf]=VectorSimBootstrap(eA_C(fastIdx,:),eA_S(fastIdx,:),nIt);
% [Bdata.eAs]=VectorSimBootstrap(eA_C(slowIdx,:),eA_S(slowIdx,:),nIt);
% 
% [Bdata.lAf]=VectorSimBootstrap(lA_C(fastIdx,:),lA_S(fastIdx,:),nIt);
% [Bdata.lAs]=VectorSimBootstrap(lA_C(slowIdx,:),lA_S(slowIdx,:),nIt);
% 
% [Bdata.ePlAf]=VectorSimBootstrap(ePlA_C(fastIdx,:),ePlA_S(fastIdx,:),nIt);
% [Bdata.ePlAs]=VectorSimBootstrap(ePlA_C(slowIdx,:),ePlA_S(slowIdx,:),nIt);
% 
% [Bdata.ePf]=VectorSimBootstrap(eP_C(fastIdx,:),eP_S(fastIdx,:),nIt);
% [Bdata.ePs]=VectorSimBootstrap(eP_C(slowIdx,:),eP_S(slowIdx,:),nIt);

[BdataFast]=VectorSimBootstrap(lB_C(fastIdx,:),slow_C(fastIdx,:),nIt);
[BdataSlow]=VectorSimBootstrap(lB_C(slowIdx,:),slow_C(slowIdx,:),nIt);

binWidth=0.01;BinRange=[-0.5 1];

figure
fullscreen
subplot(2,4,1)
hold on
CompareOverlap(BdataFast,binWidth,BinRange);
%title('FBK_t_i_e_d_-_t_o_-_s_p_l_i_t')
ylabel('fast')

subplot(2,4,2)
hold on
CompareOverlap(BdataSlow,binWidth,BinRange);
ylabel('slow')
%title('FBK_s_p_l_i_t_-_t_o_-_t_i_e_d')

subplot(2,4,3)
hold on
CompareOverlap(Bdata.lAf,binWidth,BinRange);
title('steady state')

subplot(2,4,4)
hold on
CompareOverlap(Bdata.ePf,binWidth,BinRange);
title('after effect')
legend({'Controls','Stroke'})

subplot(2,4,5)
hold on
CompareOverlap(Bdata.eAs,binWidth,BinRange);
ylabel('slow')

subplot(2,4,6)
hold on
CompareOverlap(Bdata.ePlAs,binWidth,BinRange);

subplot(2,4,7)
hold on
CompareOverlap(Bdata.lAs,binWidth,BinRange);

subplot(2,4,8)
hold on
CompareOverlap(Bdata.ePs,binWidth,BinRange);


% 
% %plot([refcosine refcosine],[0 600],'Color','g','LineWidth',2)
% ylabel('number of observations')
% xlabel('cosine between vectors')
% legend({'ControlCosine','DistControl','StrokeCosine','DistStroke','strokeControl14'})
