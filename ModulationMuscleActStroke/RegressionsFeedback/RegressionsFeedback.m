clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

%strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
%controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
%strokesNames={'P0001','P0002','P0004','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy


strokesNames=strcat('P00',{'01','02','08','09','10','13','14','15'});%P016 removed %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsNames=strcat('C00',{'01','02','04','05','06','09','10','12','16'}); %C07 removed%Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s


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

%Magnitude analysis
eAMagnC=NaN(15,1);
ePMagnC=NaN(15,1);
eAMagnS=NaN(15,1);
ePMagnS=NaN(15,1);
ePBMagnC=NaN(15,1);
ePBMagnS=NaN(15,1);

for i=1:size(eA_C,2)
    eAMagnC(i,1)=norm(eA_C(:,i));
    ePMagnC(i,1)=norm([eP_C(:,i)-lA_C(:,i)]);
    ePBMagnC(i,1)=norm(eP_C(:,i));
end
for i=1:size(eA_S,2)
    eAMagnS(i,1)=norm(eA_S(:,i));
    ePMagnS(i,1)=norm([eP_S(:,i)-lA_S(:,i)]);
    ePBMagnS(i,1)=norm(eP_S(:,i));
end

load([matDataDir,'bioData'])
clear ageC ageS;
for c=1:length(groups{1}.adaptData)
    ageC(c,1)=groups{1}.adaptData{c}.getSubjectAgeAtExperimentDate;
    ageS(c,1)=groups{2}.adaptData{c}.getSubjectAgeAtExperimentDate;
    genderC{c}=groups{1}.adaptData{c}.subData.sex;
    genderS{c}=groups{2}.adaptData{c}.subData.sex;
    affSide{c}=groups{2}.adaptData{c}.subData.affectedSide;
end


FMselect=FM([1:6,8:16]);
velSselect=velsS([1:6,8:16]);
velCselect=velsC([1:6,8:16]);

tALL=table;
tALL.group=cell(30,1);tALL.aff=cell(30,1);tALL.sens=NaN(30,1);
tALL.group(1:15,1)={'control'};
tALL.group(16:30,1)={'stroke'};
tALL.group=nominal(tALL.group);
tALL.gender=[genderC';genderS'];
tALL.age=[ageC; ageS];
tALL.aff(16:30)=affSide';
tALL.vel=[velCselect';velSselect'];
tALL.FM=[repmat(34,15,1);FMselect'];
tALL.BM=[ClearnAll1a;SlearnAll1a];
tALL.sens(16:30)=[3.61 3.61 2.83 2.83 6.65 3.61 3.61 6.65 2.83 6.65 4.56 3.61 3.61 3.61 6.65]';
tALL.eAMagn=[eAMagnC;eAMagnS];
tALL.ePMagn=[ePMagnC;ePMagnS];
tALL.ePBMagn=[ePBMagnC;ePBMagnS];


%save([matDataDir,'RegressionResults.mat'],'Clearn1a','Clearn1aCI','Slearn1a','Slearn1aCI','tALL');


% 
% figure
% set(gcf,'Color',[1 1 1])
% x=[1,2];
% subplot(2,3,1)
% hold on
% bar(x,[Clearn1a Slearn1a],'FaceColor',[0.5 0.5 0.5])
% errorbar(x,[Clearn1a Slearn1a],[diff(Clearn1aCI)/2 diff(Slearn1aCI)/2],'Color','k','LineWidth',2,'LineStyle','none')
% set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{''},'FontSize',16)
% ylabel('\beta_M group regression')
% title('ADAPTATION OF FEEDBACK RESPONSES')
% 
% subplot(2,3,4)
% hold on
% bar(x,nanmean([ClearnAll1a SlearnAll1a]),'FaceColor',[0.5 0.5 0.5])
% errorbar(x,nanmean([ClearnAll1a SlearnAll1a]),nanstd([ClearnAll1a SlearnAll1a])./sqrt(15),'Color','k','LineWidth',2,'LineStyle','none')
% set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},'FontSize',16)
% ylabel('\beta_M individual regressions')
% 




