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

refRegressor=[0.6044;0.34992];
controlRefRegressor=[0.58809;0.29598];

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

%compute eAT
eAT_C=fftshift(eA_C,1);
eAT_S=fftshift(eA_S,1);

Stats=nan(2,nIt);
for it=1:nIt
    %Select subjects
    %Step 1: divide group in 2
    dt=1:length(controlsNames);
    csubs=datasample(dt,10,'Replace',false);
    ssubs=datasample(dt,10,'Replace',false);
    
    %Step 2: generate table with flipped data
    ttC=table(-median(eA_C(:,csubs),2), median(eAT_C(:,csubs),2), median(eP_C(:,csubs),2)-median(lA_C(:,csubs),2),'VariableNames',{'eA','eAT','eP_lA'});
    ttS=table(-median(eA_S(:,ssubs),2), median(eAT_S(:,ssubs),2), median(eP_S(:,ssubs),2)-median(lA_S(:,ssubs),2),'VariableNames',{'eA','eAT','eP_lA'});
    
    %% Do regression analysis:
    rob='off';
    %normalizing vectors
    ttC.eATnorm=ttC.eAT./norm(ttC.eAT);
    ttC.eP_lAnorm=ttC.eP_lA./norm(ttC.eP_lA);
    ttC.eAnorm=ttC.eA./norm(ttC.eA);
    
    ttS.eATnorm=ttS.eAT./norm(ttS.eAT);
    ttS.eP_lAnorm=ttS.eP_lA./norm(ttS.eP_lA);
    ttS.eAnorm=ttS.eA./norm(ttS.eA);
    
    %control regression on Normalized vectors
    CmodelFit2=fitlm(ttC,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
    SmodelFit2=fitlm(ttS,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
    
%     if find(startsWith(CmodelFit2.PredictorNames,'eAT'),1,'first')==1
%         vectors(1:2,it)=[CmodelFit2.Coefficients.Estimate(1); CmodelFit2.Coefficients.Estimate(2)];
%     else
%         vectors(1:2,it)=[CmodelFit2.Coefficients.Estimate(2); CmodelFit2.Coefficients.Estimate(1)];
%         
%     end

    [Stats(1,it), Stats(2,it)]=CompareRegressors(CmodelFit2,SmodelFit2,0,2);
    clear ttC ttS CmodelFit2 SmodelFit2
end

