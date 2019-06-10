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

ep=defineEpochs({'BASE','eA','lA','eP','eB','lS'},{'TM base','Adaptation','Adaptation','Washout','TM base','short split'},[-40 nstrides -40 nstrides nstrides -8],[eE eE eE eE eE eE],[eL eL eL eL eL eL],summethod);
baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);

%extract data for stroke and controls separately
padWithNaNFlag=false;

[CdataEMG,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
%[CBB,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);

[SdataEMG,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
%[SBB,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);

%NOT NEEDED, BECAUSE BASELINE PT 5 was ok.
%replace SOL muscles PT 5 with zeros to minimize effect of loose sensor
% labels2=labels(:);
% Index = find(contains(labels2,'sSOL'));%find all Soleus muscle data in the labels
% ptIdx=find(contains(strokesNames,'P0005'));
% SdataEMG(Index,:,ptIdx)=NaN;%I checked this and it indeed removes all the large peaks from the subject data, regardles of which subs are selected
% SdataEMG(Index,:,ptIdx)=nanmedian(SdataEMG(Index,:,:),3);

%Flipping EMG:
CdataEMG=reshape(flipEMGdata(reshape(CdataEMG,size(labels,1),size(labels,2),size(CdataEMG,2),size(CdataEMG,3)),1,2),numel(labels),size(CdataEMG,2),size(CdataEMG,3));
SdataEMG=reshape(flipEMGdata(reshape(SdataEMG,size(labels,1),size(labels,2),size(SdataEMG,2),size(SdataEMG,3)),1,2),numel(labels),size(SdataEMG,2),size(SdataEMG,3));

CBB=CdataEMG(:,1,:);
SBB=SdataEMG(:,1,:);

controlsim=NaN(size(CBB,3),1);
for c=1:size(CBB,3)
    controlsim(c,1)=cosine(CBB(1:180,c),CBB(181:360,c));
end

strokesim=NaN(size(SBB,3),1);
for c=1:size(SBB,3)
    strokesim(c,1)=cosine(SBB(1:180,c),SBB(181:360,c));
end

figure
subplot(2,2,1)
hold on
bar([1 2],[nanmedian(controlsim) nanmedian(strokesim)],'FaceColor',[1 1 1],'LineWidth',2)
errorbar([1 2],[nanmedian(controlsim) nanmedian(strokesim)],[iqr(controlsim) iqr(strokesim)],'Color','k','LineStyle','none','LineWidth',2)
plot(1,controlsim,'ok')
plot(2,strokesim,'ok')
set(gca,'XLim',[0.5 2.5],'XTick',[1,2],'XTickLabel',{'Control','Stroke'},'YLim',[0.6 1])
ylabel('BaseEMG_Sym')
title('n=14')



[dummy1,CIdx]=sort(controlsim,'ascend');
[dummy2,SIdx]=sort(strokesim,'descend');


controlSelect=controlsNames(CIdx(1:7));
strokeSelect=strokesNames(SIdx(1:7));


subplot(2,2,2)
hold on
bar([1 2],[nanmedian(dummy1(1:10)) nanmedian(dummy2(1:10))],'FaceColor',[1 1 1],'LineWidth',2)
errorbar([1 2],[nanmedian(dummy1(1:10)) nanmedian(dummy2(1:10))],[iqr(dummy1(1:10)) iqr(dummy2(1:10))],'Color','k','LineStyle','none','LineWidth',2)
plot(1,dummy1(1:10),'ok')
plot(2,dummy2(1:10),'ok')
set(gca,'XLim',[0.5 2.5],'XTick',[1,2],'XTickLabel',{'Control','Stroke'},'YLim',[0.6 1])
title('n=10')


