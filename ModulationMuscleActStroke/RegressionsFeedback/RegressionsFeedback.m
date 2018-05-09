clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007


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

ep=defineEpochs({'BASE','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 15 -40 15],[eE eE eE eE],[eL eL eL eL],'nanmean');
baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');

%extract data for stroke and controls separately
padWithNaNFlag=false;

[CdataEMG,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
[CBB,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);
CdataEMG=CdataEMG-CBB; %Removing base

[SdataEMG,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,ep,padWithNaNFlag);
[SBB,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,baseEp,padWithNaNFlag);
SdataEMG=SdataEMG-SBB; %Removing base

%Flipping EMG:
CdataEMG=reshape(flipEMGdata(reshape(CdataEMG,size(labels,1),size(labels,2),size(CdataEMG,2),size(CdataEMG,3)),1,2),numel(labels),size(CdataEMG,2),size(CdataEMG,3));
SdataEMG=reshape(flipEMGdata(reshape(SdataEMG,size(labels,1),size(labels,2),size(SdataEMG,2),size(SdataEMG,3)),1,2),numel(labels),size(SdataEMG,2),size(SdataEMG,3));

%% Get all the eA, lA, eP vectors
shortNames={'lB','eA','lA','eP'};
longNames={'BASE','eA','lA','eP'}
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

%% Do group analysis:
rob='off';

ttC=table(-mean(eA_C,2), mean(eAT_C,2), -mean(lA_C,2), mean(eP_C,2)-mean(lA_C,2),'VariableNames',{'eA','eAT','lA','eP_lA'});
ttS=table(-mean(eA_S,2), mean(eAT_S,2), -mean(lA_S,2), mean(eP_S,2)-mean(lA_S,2),'VariableNames',{'eA','eAT','lA','eP_lA'});

CmodelFit1a=fitlm(ttC,'eP_lA~eAT-1','RobustOpts',rob)
Clearn1a=CmodelFit1a.Coefficients.Estimate;
Clearn1aCI=CmodelFit1a.coefCI;
Cr21a=uncenteredRsquared(CmodelFit1a);
Cr21a=Cr21a.uncentered;
%disp(['Uncentered R^2=' num2str(Cr21a,3)])

SmodelFit1a=fitlm(ttS,'eP_lA~eAT-1','RobustOpts',rob)
Slearn1a=SmodelFit1a.Coefficients.Estimate;
Slearn1aCI=SmodelFit1a.coefCI;
Sr21a=uncenteredRsquared(SmodelFit1a);
Sr21a=Sr21a.uncentered;
%disp(['Uncentered R^2=' num2str(Sr21a,3)])

%% Individual models::
rob='off'; %These models can't be fit robustly (doesn't converge)
%First: repeat the model(s) above on each subject:
clear CmodelFitAll* ClearnAll* SmodelFitAll* SlearnAll* 

for i=1:size(eA_C,2)
    ttAll=table(-eA_C(:,i), eAT_C(:,i), -lA_C(:,i), eP_C(:,i)-lA_C(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    CmodelFitAll1a{i}=fitlm(ttAll,'eP_lA~eAT-1','RobustOpts',rob);
    ClearnAll1a(i,:)=CmodelFitAll1a{i}.Coefficients.Estimate;
    aux=uncenteredRsquared(CmodelFitAll1a{i});
    Cr2All1a(i)=aux.uncentered;    
end

for i=1:size(eA_S,2)
    ttAll=table(-eA_S(:,i), eAT_S(:,i), -lA_S(:,i), eP_S(:,i)-lA_S(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    SmodelFitAll1a{i}=fitlm(ttAll,'eP_lA~eAT-1','RobustOpts',rob);
    SlearnAll1a(i,:)=SmodelFitAll1a{i}.Coefficients.Estimate;
    aux=uncenteredRsquared(SmodelFitAll1a{i});
    Sr2All1a(i)=aux.uncentered;    
end
save([matDataDir,'RegressionResults.mat'],'Clearn1a','Clearn1aCI','Slearn1a','Slearn1aCI','ClearnAll1a','SlearnAll1a');


figure
set(gcf,'Color',[1 1 1])
x=[1,2];
subplot(2,3,1)
hold on
bar(x,[Clearn1a Slearn1a],'FaceColor',[0.5 0.5 0.5])
errorbar(x,[Clearn1a Slearn1a],[diff(Clearn1aCI)/2 diff(Slearn1aCI)/2],'Color','k','LineWidth',2,'LineStyle','none')
set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{''},'FontSize',16)
ylabel('\beta_M group regression')
title('ADAPTATION OF FEEDBACK RESPONSES')

subplot(2,3,4)
hold on
bar(x,nanmean([ClearnAll1a SlearnAll1a]),'FaceColor',[0.5 0.5 0.5])
errorbar(x,nanmean([ClearnAll1a SlearnAll1a]),nanstd([ClearnAll1a SlearnAll1a])./sqrt(15),'Color','k','LineWidth',2,'LineStyle','none')
set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},'FontSize',16)
ylabel('\beta_M individual regressions')



