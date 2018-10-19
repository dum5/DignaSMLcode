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

%% Do group analysis:
rob='off';

if groupMedianFlag
    ttC=table(-median(eA_C(:,cIdx),2), median(eAT_C(:,cIdx),2), -median(lA_C(:,cIdx),2), median(eP_C(:,cIdx),2)-median(lA_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    %patients that are don't have good data will be removed
    ttS=table(-median(eA_S(:,pIdx),2), median(eAT_S(:,pIdx),2), -median(lA_S(:,pIdx),2), median(eP_S(:,pIdx),2)-median(lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
else
    ttC=table(-mean(eA_C(:,cIdx),2), mean(eAT_C(:,cIdx),2), -mean(lA_C(:,cIdx),2), mean(eP_C(:,cIdx),2)-mean(lA_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    %patients that are don't have good data will be removed
    ttS=table(-mean(eA_S(:,pIdx),2), mean(eAT_S(:,pIdx),2), -mean(lA_S(:,pIdx),2), mean(eP_S(:,pIdx),2)-mean(lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
end


%normalizing vectors
ttC.eATnorm=ttC.eAT./norm(ttC.eAT);
ttC.eP_lAnorm=ttC.eP_lA./norm(ttC.eP_lA);
ttC.eAnorm=ttC.eA./norm(ttC.eA);

ttS.eATnorm=ttS.eAT./norm(ttS.eAT);
ttS.eP_lAnorm=ttS.eP_lA./norm(ttS.eP_lA);
ttS.eAnorm=ttS.eA./norm(ttS.eA);

%do the regression
CmodelFit1a=fitlm(ttC,'eP_lA~eAnorm-1','RobustOpts',rob)
Clearn1a=CmodelFit1a.Coefficients.Estimate;
Clearn1aCI=CmodelFit1a.coefCI;
Cr21a=uncenteredRsquared(CmodelFit1a);
Cr21a=Cr21a.uncentered;
%disp(['Uncentered R^2=' num2str(Cr21a,3)])

CmodelFit1b=fitlm(ttC,'eP_lA~eATnorm-1','RobustOpts',rob)
Clearn1b=CmodelFit1b.Coefficients.Estimate;
Clearn1bCI=CmodelFit1b.coefCI;
Cr21b=uncenteredRsquared(CmodelFit1b);
Cr21b=Cr21b.uncentered;
%disp(['Uncentered R^2=' num2str(Cr21a,3)])



SmodelFit1a=fitlm(ttS,'eP_lA~eAnorm-1','RobustOpts',rob)
Slearn1a=SmodelFit1a.Coefficients.Estimate;
Slearn1aCI=SmodelFit1a.coefCI;
Sr21a=uncenteredRsquared(SmodelFit1a);
Sr21a=Sr21a.uncentered;
%disp(['Uncentered R^2=' num2str(Sr21a,3)])


if speedMatchFlag
    error('Individual analysis not supported for speedMatch');
end

%% Individual models::
rob='off'; %These models can't be fit robustly (doesn't converge)
%First: repeat the model(s) above on each subject:
clear CmodelFitAll* ClearnAll* SmodelFitAll* SlearnAll* 
ClearnAll1a=NaN(16,2);
SlearnAll1a=NaN(16,2);
Cr2All1a=NaN(16,1);
Sr2All1a=NaN(16,1);

for i=cIdx%1:size(eA_C,2)
    ttAll=table(-eA_C(:,i), eAT_C(:,i), -lA_C(:,i), eP_C(:,i)-lA_C(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    CmodelFitAll1a{i}=fitlm(ttAll,'eP_lA~eA+eAT-1','RobustOpts',rob);
    ClearnAll1a(i,:)=CmodelFitAll1a{i}.Coefficients.Estimate';
    aux=uncenteredRsquared(CmodelFitAll1a{i});
    Cr2All1a(i)=aux.uncentered;    
end

for i=pIdx%1:size(eA_S,2)
    ttAll=table(-eA_S(:,i), eAT_S(:,i), -lA_S(:,i), eP_S(:,i)-lA_S(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    SmodelFitAll1a{i}=fitlm(ttAll,'eP_lA~eA+eAT-1','RobustOpts',rob);
    SlearnAll1a(i,:)=SmodelFitAll1a{i}.Coefficients.Estimate';
    aux=uncenteredRsquared(SmodelFitAll1a{i});
    Sr2All1a(i)=aux.uncentered;    
end

%Magnitude analysis
eAMagnC=NaN(16,1);
ePMagnC=NaN(16,1);
eAMagnS=NaN(16,1);
ePMagnS=NaN(16,1);
ePBMagnC=NaN(16,1);
ePBMagnS=NaN(16,1);
lAMagnC=NaN(16,1);
lAMagnS=NaN(15,1);
% csc=NaN(16,1);
% cmc=NaN(16,1);
% css=NaN(16,1);
% cms=NaN(16,1);

for i=cIdx%1:size(eA_C,2)
    eAMagnC(i,1)=norm(eA_C(:,i));
    ePMagnC(i,1)=norm([eP_C(:,i)-lA_C(:,i)]);
    ePBMagnC(i,1)=norm(eP_C(:,i));
    lAMagnC(i,1)=norm(lA_C(:,i));
    csc(i,1)=cosine(eP_C(:,i)-lA_C(:,i),-eA_C(:,i));
    cmc(i,1)=cosine(eP_C(:,i)-lA_C(:,i),eAT_C(:,i));
end
for i=pIdx%1:size(eA_S,2)
    eAMagnS(i,1)=norm(eA_S(:,i));
    ePMagnS(i,1)=norm([eP_S(:,i)-lA_S(:,i)]);
    ePBMagnS(i,1)=norm(eP_S(:,i));
    lAMagnS(i,1)=norm(lA_S(:,i));
    css(i,1)=cosine(eP_S(:,i)-lA_S(:,i),-eA_S(:,i));
    cms(i,1)=cosine(eP_S(:,i)-lA_S(:,i),eAT_S(:,i));
end

% %cosine analysis = is no longer needed here
% cscg=(cosine(mean(eP_C(:,cIdx)-lA_C(:,cIdx),2),-mean(eA_C(:,cIdx),2)));
% cmcg=(cosine(mean(eP_C(:,cIdx)-lA_C(:,cIdx),2),mean(eAT_C(:,cIdx),2)));
% 
% cssg=(cosine(mean(eP_S(:,pIdx)-lA_S(:,pIdx),2),-mean(eA_S(:,pIdx),2)));
% cmsg=(cosine(mean(eP_S(:,pIdx)-lA_S(:,pIdx),2),mean(eAT_S(:,pIdx),2)));


load([matDataDir,'bioData'])
clear ageC ageS;
for c=1:length(groups{1}.adaptData)
    ageC(c,1)=groups{1}.adaptData{c}.getSubjectAgeAtExperimentDate;
    ageS(c,1)=groups{2}.adaptData{c}.getSubjectAgeAtExperimentDate;
    genderC{c}=groups{1}.adaptData{c}.subData.sex;
    genderS{c}=groups{2}.adaptData{c}.subData.sex;
    affSide{c}=groups{2}.adaptData{c}.subData.affectedSide;
end

%Selection of subjects removed
FMselect=FM;
velSselect=velsS;
velCselect=velsC;

tALL=table;
tALL.group=cell(32,1);tALL.aff=cell(32,1);tALL.sens=NaN(32,1);
tALL.group(1:16,1)={'control'};
tALL.group(17:30,1)={'stroke'};
tALL.group=nominal(tALL.group);
tALL.gender=[genderC';genderS'];
tALL.age=[ageC; ageS];
tALL.aff(17:32)=affSide';
tALL.vel=[velCselect';velSselect'];
tALL.FM=[repmat(34,16,1);FMselect'];
tALL.BS=[ClearnAll1a(:,1);SlearnAll1a(:,1)];
tALL.BM=[ClearnAll1a(:,2);SlearnAll1a(:,2)];
tALL.R2=[Cr2All1a;Sr2All1a];
tALL.sens(17:32)=[3.61 3.61 2.83 2.83 6.65 3.61 NaN 3.61 6.65 2.83 6.65 4.56 3.61 3.61 3.61 6.65]';
tALL.eAMagn=[eAMagnC;eAMagnS];
tALL.ePMagn=[ePMagnC;ePMagnS];
tALL.ePBMagn=[ePBMagnC;ePBMagnS];
tALL.lAMagn=[lAMagnC;lAMagnS];
%tALL.cs=[csc;css];
%tALL.cm=[cmc;cms];


answer = questdlg('Save results to mat file?');
switch answer
case 'Yes'
    save([matDataDir,'RegressionResults.mat'],'Clearn1a','Clearn1aCI','Slearn1a','Slearn1aCI','tALL');
    disp('matfile saved')
    case 'No'
        disp('data not saved')
end


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

clear t TStroke TControl
t=tALL;
t.group=nominal(t.group);
TStroke=t(t.group=='stroke',:);
TControl=t(t.group=='control',:);
Clearn1aCI
Slearn1aCI

[h,p]=ranksum(TControl.cm,TStroke.cm)
[h,p]=ranksum(TControl.cs,TStroke.cs)


