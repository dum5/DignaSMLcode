clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

speedMatchFlag=0;
%removeP03Flag=1;
groupMedianFlag=1;
nstrides=5;
%pIdx=[1:2 4:15];
%cIdx=[1:15];
summethod='nanmedian';

%selection of subjects is as follows: subjects 3 are always removed
%(patients and controls)



if speedMatchFlag
%     strokesNames=strcat('P00',{'01','02','05','08','09','10','13','14','15'});%P016 removed %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
%     %controlsNames=strcat('C00',{'01','02','04','05','06','09','10','12','16'}); %C07 removed%Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s
%     controlsNames=strcat('C00',{'02','04','05','06','07','09','10','12','16'}); %C07 removed%Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s
    
strokesNames=strcat('P00',{'01','02','05','08','09','10','13','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsNames=strcat('C00',{'02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s



    pIdx=[1:9];%all subjects listed above
    cIdx=[1:9];
else
   controlsNames={'C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
   %controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
    
    %patient 3 will be exlcuded later, otherwise the table messes up
    strokesNames={'P0001','P0002','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
    
    pIdx=[1:14];
    cIdx=[1:14];
    
    
end

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
SdataEMG(Index,:,ptIdx)=0;
   
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

%generate table for each subject
ttCall=table;
for c=cIdx
    ttCall.eA(:,c)=eA_C(:,c);
    ttCall.eAnorm(:,c)=eA_C(:,c)./norm(eA_C(:,c));
    ttCall.eAT(:,c)=eAT_C(:,c);
    ttCall.eATnorm(:,c)=eAT_C(:,c)./norm(eAT_C(:,c));
    ttCall.eP_lA(:,c)=eP_C(:,c)-lA_C(:,c);
    ttCall.eP_lAnorm(:,c)=ttCall.eP_lA(:,c)./norm(ttCall.eP_lA(:,c));    
end
ttSall=table;
for c=pIdx
    ttSall.eA(:,c)=eA_S(:,c);
    ttSall.eAnorm(:,c)=eA_S(:,c)./norm(eA_S(:,c));
    ttSall.eAT(:,c)=eAT_S(:,c);
    ttSall.eATnorm(:,c)=eAT_S(:,c)./norm(eAT_S(:,c));
    ttSall.eP_lA(:,c)=eP_S(:,c)-lA_S(:,c);
    ttSall.eP_lAnorm(:,c)=ttSall.eP_lA(:,c)./norm(ttSall.eP_lA(:,c));    
end

CmodelFit1a=fitlm(ttC,'eP_lAnorm~eAnorm-1','RobustOpts',rob);
Clearn1a=CmodelFit1a.Coefficients.Estimate;
Clearn1aCI=CmodelFit1a.coefCI;
Cr1a=uncenteredRsquared(CmodelFit1a);
Cr1a=Cr1a.uncentered;

CmodelFit1b=fitlm(ttC,'eP_lAnorm~eATnorm-1','RobustOpts',rob);
Clearn1b=CmodelFit1b.Coefficients.Estimate;
Clearn1bCI=CmodelFit1b.coefCI;
Cr1b=uncenteredRsquared(CmodelFit1b);
Cr1b=Cr1b.uncentered;

CmodelFit2=fitlm(ttC,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
Clearn2=CmodelFit2.Coefficients.Estimate;
Clearn2CI=CmodelFit2.coefCI;
Cr2=uncenteredRsquared(CmodelFit2);
Cr2=Cr2.uncentered;


CmodelFit3a=fitlm(ttC,'eP_lA~eA-1','RobustOpts',rob);
Clearn3a=CmodelFit3a.Coefficients.Estimate;
Clearn3aCI=CmodelFit3a.coefCI;
Cr3a=uncenteredRsquared(CmodelFit3a);
Cr3a=Cr3a.uncentered;

CmodelFit3b=fitlm(ttC,'eP_lA~eAT-1','RobustOpts',rob);
Clearn3b=CmodelFit3b.Coefficients.Estimate;
Clearn3bCI=CmodelFit3b.coefCI;
Cr3b=uncenteredRsquared(CmodelFit3b);
Cr3b=Cr3b.uncentered;

CmodelFit4=fitlm(ttC,'eP_lA~eA+eAT-1','RobustOpts',rob);
Clearn4=CmodelFit4.Coefficients.Estimate;
Clearn4CI=CmodelFit4.coefCI;
Cr4=uncenteredRsquared(CmodelFit4);
Cr4=Cr4.uncentered;



SmodelFit1a=fitlm(ttS,'eP_lAnorm~eAnorm-1','RobustOpts',rob);
Slearn1a=SmodelFit1a.Coefficients.Estimate;
Slearn1aCI=SmodelFit1a.coefCI;
Sr1a=uncenteredRsquared(SmodelFit1a);
Sr1a=Sr1a.uncentered;

SmodelFit1b=fitlm(ttS,'eP_lAnorm~eATnorm-1','RobustOpts',rob);
Slearn1b=SmodelFit1b.Coefficients.Estimate;
Slearn1bCI=SmodelFit1b.coefCI;
Sr1b=uncenteredRsquared(SmodelFit1b);
Sr1b=Sr1b.uncentered;


SmodelFit2=fitlm(ttS,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
Slearn2=SmodelFit2.Coefficients.Estimate;
Slearn2CI=SmodelFit2.coefCI;
Sr2=uncenteredRsquared(SmodelFit2);
Sr2=Sr2.uncentered;


SmodelFit3a=fitlm(ttS,'eP_lA~eA-1','RobustOpts',rob);
Slearn3a=SmodelFit3a.Coefficients.Estimate;
Slearn3aCI=SmodelFit3a.coefCI;
Sr3a=uncenteredRsquared(SmodelFit3a);
Sr3a=Sr3a.uncentered;

SmodelFit3b=fitlm(ttS,'eP_lA~eAT-1','RobustOpts',rob);
Slearn3b=SmodelFit3b.Coefficients.Estimate;
Slearn3bCI=SmodelFit3b.coefCI;
Sr3b=uncenteredRsquared(SmodelFit3b);
Sr3b=Sr3b.uncentered;

SmodelFit4=fitlm(ttS,'eP_lA~eA+eAT-1','RobustOpts',rob);
Slearn4=SmodelFit4.Coefficients.Estimate;
Slearn4CI=SmodelFit4.coefCI;
Sr4=uncenteredRsquared(SmodelFit4);
Sr4=Sr4.uncentered;

% figure
% subplot(2,2,1)
% hold on
% bar([1 3.5],[Clearn1a Clearn1b],'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],[Slearn1a Slearn1b],'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% plot([1 1],Clearn1aCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([3.5 3.5],Clearn1bCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([2 2],Slearn1aCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([4.5 4.5],Slearn1bCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('Norm Vectors, single regressions')
% if Clearn1aCI(2)<Slearn1aCI(1)
%     plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if Clearn1bCI(1)>Slearn1bCI(2)
%     plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,2)
% IdxBM=find(strcmp(CmodelFit2.PredictorNames,'eATnorm'),1,'first');
% IdxBS=find(strcmp(CmodelFit2.PredictorNames,'eAnorm'),1,'first');
% hold on
% bar([1 3.5],[Clearn2([IdxBS,IdxBM])],'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],[Slearn2([IdxBS,IdxBM])],'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% plot([1 1],Clearn2CI(IdxBS,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([3.5 3.5],Clearn2CI(IdxBM,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([2 2],Slearn2CI(IdxBS,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([4.5 4.5],Slearn2CI(IdxBM,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('Norm Vectors, combined regression')
% if Clearn2CI(IdxBS,2)<Slearn2CI(IdxBS,1)
%     plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if Clearn2CI(IdxBM,1)>Slearn2CI(IdxBM,2)
%     plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,3)
% hold on
% bar([1 3.5],[Clearn3a Clearn3b],'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],[Slearn3a Slearn3b],'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% plot([1 1],Clearn3aCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([3.5 3.5],Clearn3bCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([2 2],Slearn3aCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([4.5 4.5],Slearn3bCI,'Color',[0.5 0.5 0.5],'LineWidth',2)
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('NonNormalized, single regressions')
% if Clearn3aCI(2)<Slearn3aCI(1)
%     plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if Clearn3bCI(1)>Slearn3bCI(2)
%     plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,4)
% IdxBM=find(strcmp(CmodelFit4.PredictorNames,'eAT'),1,'first');
% IdxBS=find(strcmp(CmodelFit4.PredictorNames,'eA'),1,'first');
% hold on
% bar([1 3.5],[Clearn4([IdxBS,IdxBM])],'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],[Slearn4([IdxBS,IdxBM])],'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% plot([1 1],Clearn4CI(IdxBS,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([3.5 3.5],Clearn4CI(IdxBM,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([2 2],Slearn4CI(IdxBS,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% plot([4.5 4.5],Slearn4CI(IdxBM,:),'Color',[0.5 0.5 0.5],'LineWidth',2)
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('NonNormalized, combined regressions')
% if Clearn4CI(IdxBS,2)<Slearn4CI(IdxBS,1)
%     plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if Clearn4CI(IdxBM,1)>Slearn4CI(IdxBM,2)
%     plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end

%individual regressions to be implemented
Clearn1All=NaN(length(cIdx),2);
Clearn2All=NaN(length(cIdx),2);
Clearn3All=NaN(length(cIdx),2);
Clearn4All=NaN(length(cIdx),2);

Slearn1All=NaN(length(pIdx),2);
Slearn2All=NaN(length(pIdx),2);
Slearn3All=NaN(length(pIdx),2);
Slearn4All=NaN(length(pIdx),2);

CMagn=NaN(length(cIdx),2);%eA first col, eP-LA second col
SMagn=NaN(length(pIdx),2);


%warning, cIdx can only be consecutive number, otherwise indexing does not
%work
for i=1:length(cIdx)
    ttAll=table(-eA_C(:,i), eAT_C(:,i), -lA_C(:,i), eP_C(:,i)-lA_C(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    ttAll.eAnorm=ttAll.eA./norm(ttAll.eA);
    ttAll.eATnorm=ttAll.eAT./norm(ttAll.eAT);
    ttAll.eP_lAnorm=ttAll.eP_lA./norm(ttAll.eP_lA);
    
    %option 1 cosine analysis
    dt=fitlm(ttAll,'eP_lAnorm~eAnorm-1','RobustOpts',rob);
    Clearn1All(i,1)=dt.Coefficients.Estimate;clear dt
    
    dt=fitlm(ttAll,'eP_lAnorm~eATnorm-1','RobustOpts',rob);
    Clearn1All(i,2)=dt.Coefficients.Estimate;clear dt
    
    %option 2 normalized vecors combined regression
    
    dt=fitlm(ttAll,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
    IdxBS=find(strcmp(dt.PredictorNames,'eAnorm'),1,'first');
    IdxBM=find(strcmp(dt.PredictorNames,'eATnorm'),1,'first');
    Clearn2All(i,1)=dt.Coefficients.Estimate(IdxBS);
    Clearn2All(i,2)=dt.Coefficients.Estimate(IdxBM);clear dt IdxBS IdxBM
    
    %option 3 single regressors
    dt=fitlm(ttAll,'eP_lA~eA-1','RobustOpts',rob);
    Clearn3All(i,1)=dt.Coefficients.Estimate;clear dt
    
    dt=fitlm(ttAll,'eP_lA~eAT-1','RobustOpts',rob);
    Clearn3All(i,2)=dt.Coefficients.Estimate;clear dt
    
    %option 4 combined regression
    
    dt=fitlm(ttAll,'eP_lA~eA+eAT-1','RobustOpts',rob);
    IdxBS=find(strcmp(dt.PredictorNames,'eA'),1,'first');
    IdxBM=find(strcmp(dt.PredictorNames,'eAT'),1,'first');
    Clearn4All(i,1)=dt.Coefficients.Estimate(IdxBS);
    Clearn4All(i,2)=dt.Coefficients.Estimate(IdxBM);clear dt IdxBS IdxBM 
    
    CMagn(i,1)=norm(ttAll.eA);
    CMagn(i,2)=norm(ttAll.eP_lA);
    clear ttAll
end

for i=1:length(pIdx)
    ttAll=table(-eA_S(:,i), eAT_S(:,i), -lA_S(:,i), eP_S(:,i)-lA_S(:,i),'VariableNames',{'eA','eAT','lA','eP_lA'});
    ttAll.eAnorm=ttAll.eA./norm(ttAll.eA);
    ttAll.eATnorm=ttAll.eAT./norm(ttAll.eAT);
    ttAll.eP_lAnorm=ttAll.eP_lA./norm(ttAll.eP_lA);
    
    %option 1 cosine analysis
    dt=fitlm(ttAll,'eP_lAnorm~eAnorm-1','RobustOpts',rob);
    Slearn1All(i,1)=dt.Coefficients.Estimate;clear dt
    
    dt=fitlm(ttAll,'eP_lAnorm~eATnorm-1','RobustOpts',rob);
    Slearn1All(i,2)=dt.Coefficients.Estimate;clear dt
    
    %option 2 normalized vecors combined regression
    
    dt=fitlm(ttAll,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
    IdxBS=find(strcmp(dt.PredictorNames,'eAnorm'),1,'first');
    IdxBM=find(strcmp(dt.PredictorNames,'eATnorm'),1,'first');
    Slearn2All(i,1)=dt.Coefficients.Estimate(IdxBS);
    Slearn2All(i,2)=dt.Coefficients.Estimate(IdxBM);clear dt IdxBS IdxBM
    
    %option 3 single regressors
    dt=fitlm(ttAll,'eP_lA~eA-1','RobustOpts',rob);
    Slearn3All(i,1)=dt.Coefficients.Estimate;clear dt
    
    dt=fitlm(ttAll,'eP_lA~eAT-1','RobustOpts',rob);
    Slearn3All(i,2)=dt.Coefficients.Estimate;clear dt
    
    %option 4 combined regression
    
    dt=fitlm(ttAll,'eP_lA~eA+eAT-1','RobustOpts',rob);
    IdxBS=find(strcmp(dt.PredictorNames,'eA'),1,'first');
    IdxBM=find(strcmp(dt.PredictorNames,'eAT'),1,'first');
    Slearn4All(i,1)=dt.Coefficients.Estimate(IdxBS);
    Slearn4All(i,2)=dt.Coefficients.Estimate(IdxBM);clear dt IdxBS IdxBM 
    
    SMagn(i,1)=norm(ttAll.eA);
    SMagn(i,2)=norm(ttAll.eP_lA);
    clear ttAll
end
% 
% figure
% subplot(2,2,1)
% hold on
% bar([1 3.5],nanmedian(Clearn1All),'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],nanmedian(Slearn1All),'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% errorbar([1 3.5],nanmedian(Clearn1All),iqr(Clearn1All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% errorbar([2 4.5],nanmedian(Slearn1All),iqr(Slearn1All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('Norm Vectors, single regressions')
% [p1,h1]=ranksum(Clearn1All(:,1),Slearn1All(:,1));
% [p2,h2]=ranksum(Clearn1All(:,2),Slearn1All(:,2));
% if p1<0.05
%       plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if p2<0.05
%       plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,2)
% hold on
% bar([1 3.5],nanmedian(Clearn2All),'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],nanmedian(Slearn2All),'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% errorbar([1 3.5],nanmedian(Clearn2All),iqr(Clearn2All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% errorbar([2 4.5],nanmedian(Slearn2All),iqr(Slearn2All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('Norm Vectors, combined regressions')
% [p1,h1]=ranksum(Clearn2All(:,1),Slearn2All(:,1));
% [p2,h2]=ranksum(Clearn2All(:,2),Slearn2All(:,2));
% if p1<0.05
%       plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if p2<0.05
%       plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,3)
% hold on
% bar([1 3.5],nanmedian(Clearn3All),'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],nanmedian(Slearn3All),'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% errorbar([1 3.5],nanmedian(Clearn3All),iqr(Clearn3All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% errorbar([2 4.5],nanmedian(Slearn3All),iqr(Slearn3All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('Non-normalized single regressions')
% [p1,h1]=ranksum(Clearn3All(:,1),Slearn3All(:,1));
% [p2,h2]=ranksum(Clearn3All(:,2),Slearn3All(:,2));
% if p1<0.05
%       plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if p2<0.05
%       plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end
% 
% subplot(2,2,4)
% hold on
% bar([1 3.5],nanmedian(Clearn4All),'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
% bar([2 4.5],nanmedian(Slearn4All),'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
% errorbar([1 3.5],nanmedian(Clearn4All),iqr(Clearn4All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% errorbar([2 4.5],nanmedian(Slearn4All),iqr(Slearn4All),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5])
% set(gca,'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'});
% title('NonNormalized combined regressions')
% [p1,h1]=ranksum(Clearn4All(:,1),Slearn4All(:,1));
% [p2,h2]=ranksum(Clearn4All(:,2),Slearn4All(:,2));
% if p1<0.05
%       plot([1 2],[0.95 0.95],'-k','LineWidth',2)
% end
% if p2<0.05
%       plot([3.5 4.5],[0.95 0.95],'-k','LineWidth',2)
% end

CMagn(:,3)=CMagn(:,1)-CMagn(:,2);
SMagn(:,3)=SMagn(:,1)-SMagn(:,2);


figure
subplot(2,2,1)
hold on
bar([1 3.5 6],nanmedian(CMagn),'FaceColor',[1 1 1],'LineWidth',2,'BarWidth',0.3)
bar([2 4.5 7],nanmedian(SMagn),'FaceColor',[0 0 0],'LineWidth',2,'BarWidth',0.3)
errorbar([1 3.5 6],nanmedian(CMagn),iqr(CMagn),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5]);
errorbar([2 4.5 7],nanmedian(SMagn),iqr(SMagn),'LineStyle','none','LineWidth',2,'Color',[0.5 0.5 0.5]);
[p1,h1]=ranksum(CMagn(:,1),SMagn(:,1));
[p2,h2]=ranksum(CMagn(:,2),SMagn(:,2));
[p3,h3]=ranksum(CMagn(:,3),SMagn(:,3));
lims=get(gca,'YLim');upperL=lims(2)*0.9;
if p1<0.05
      plot([1 2],[upperL upperL],'-k','LineWidth',2)
end
if p2<0.05
      plot([3.5 4.5],[upperL upperL],'-k','LineWidth',2)
end
if p3<0.05
      plot([6 7],[upperL upperL],'-k','LineWidth',2)
end
set(gca,'XLim',[0.5 7.5],'XTick',[1.5 4 6.5],'XTickLabel',{'||earlyA||','||earlyP-lateA||','deltaMagn'})

% 
% 
% 
% 
% load([matDataDir,'bioData'])
% clear ageC ageS;
% for c=1:length(groups{1}.adaptData)
%     ageC(c,1)=groups{1}.adaptData{c}.getSubjectAgeAtExperimentDate;
%     ageS(c,1)=groups{2}.adaptData{c}.getSubjectAgeAtExperimentDate;
%     genderC{c}=groups{1}.adaptData{c}.subData.sex;
%     genderS{c}=groups{2}.adaptData{c}.subData.sex;
%     affSide{c}=groups{2}.adaptData{c}.subData.affectedSide;
% end
% 
% %patient 7 and control 7 are not included
% FMselect=FM([1:6,8:16]);
% velSselect=velsS([1:6,8:16]);
% velCselect=velsC([7,2:6,8:16]);
% 
% tALL=table;
% tALL.group=cell(30,1);tALL.aff=cell(30,1);tALL.sens=NaN(30,1);
% tALL.group(1:15,1)={'control'};
% tALL.group(16:30,1)={'stroke'};
% tALL.group=nominal(tALL.group);
% tALL.gender=[genderC';genderS'];
% tALL.age=[ageC; ageS];
% tALL.aff(16:30)=affSide';
% tALL.vel=[velCselect';velSselect'];
% tALL.FM=[repmat(34,15,1);FMselect'];
% tALL.BS=[ClearnAll1a(:,1);SlearnAll1a(:,1)];
% tALL.BM=[ClearnAll1a(:,2);SlearnAll1a(:,2)];
% tALL.R2=[Cr2All1a;Sr2All1a];
% tALL.sens(16:30)=[3.61 3.61 2.83 2.83 6.65 3.61 3.61 6.65 2.83 6.65 4.56 3.61 3.61 3.61 6.65]';
% tALL.eAMagn=[eAMagnC;eAMagnS];
% tALL.ePMagn=[ePMagnC;ePMagnS];
% tALL.ePBMagn=[ePBMagnC;ePBMagnS];
% tALL.lAMagn=[lAMagnC;lAMagnS];
% tALL.cs=[csc;css];
% tALL.cm=[cmc;cms];
% 
% 
% answer = questdlg('Save results to mat file?');
% switch answer
% case 'Yes'
%     save([matDataDir,'RegressionResults.mat'],'Clearn1a','Clearn1aCI','Slearn1a','Slearn1aCI','tALL');
%     disp('matfile saved')
%     case 'No'
%         disp('data not saved')
% end
% 
% 
% % 
% % figure
% % set(gcf,'Color',[1 1 1])
% % x=[1,2];
% % subplot(2,3,1)
% % hold on
% % bar(x,[Clearn1a Slearn1a],'FaceColor',[0.5 0.5 0.5])
% % errorbar(x,[Clearn1a Slearn1a],[diff(Clearn1aCI)/2 diff(Slearn1aCI)/2],'Color','k','LineWidth',2,'LineStyle','none')
% % set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{''},'FontSize',16)
% % ylabel('\beta_M group regression')
% % title('ADAPTATION OF FEEDBACK RESPONSES')
% % 
% % subplot(2,3,4)
% % hold on
% % bar(x,nanmean([ClearnAll1a SlearnAll1a]),'FaceColor',[0.5 0.5 0.5])
% % errorbar(x,nanmean([ClearnAll1a SlearnAll1a]),nanstd([ClearnAll1a SlearnAll1a])./sqrt(15),'Color','k','LineWidth',2,'LineStyle','none')
% % set(gca,'XLim',[0.5 2.5],'YLim',[0 1],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},'FontSize',16)
% % ylabel('\beta_M individual regressions')
% % 
% 
% clear t TStroke TControl
% t=tALL;
% t.group=nominal(t.group);
% TStroke=t(t.group=='stroke',:);
% TControl=t(t.group=='control',:);
% Clearn1aCI
% Slearn1aCI
% 
% [h,p]=ranksum(TControl.cm,TStroke.cm)
% [h,p]=ranksum(TControl.cs,TStroke.cs)
% 
figure
set(gcf,'Color',[1 1 1]','Units','inches','Position',[0 0 10 10]);
subplot(3,3,1)
[a]=plotCor(gca,SMagn(:,1),Slearn4All(:,1),CMagn(:,1),Clearn4All(:,1));
ylabel('\beta_S');title('||EarlyA||')
subplot(3,3,2)
[a]=plotCor(gca,SMagn(:,2),Slearn4All(:,1),CMagn(:,2),Clearn4All(:,1));
title('||EarlyP-LateA||')
subplot(3,3,3)
[a]=plotCor(gca,SMagn(:,3),Slearn4All(:,1),CMagn(:,3),Clearn4All(:,1));
title('||deltaMagn||')

subplot(3,3,4)
[a]=plotCor(gca,SMagn(:,1),Slearn4All(:,2),CMagn(:,1),Clearn4All(:,2));
ylabel('\beta_M');
subplot(3,3,5)
[a]=plotCor(gca,SMagn(:,2),Slearn4All(:,2),CMagn(:,2),Clearn4All(:,2));
subplot(3,3,6)
[a]=plotCor(gca,SMagn(:,3),Slearn4All(:,2),CMagn(:,3),Clearn4All(:,2));






function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
hold(ax)
a=[];

if nargin>3
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    %tc=text(ax,0,yl(2)+3*diff(yl)/10,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
    if pc(2)<0.05
    [r,slope,intercept] = regression(xDataC,yDataC,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2','Color',[0.7 0.7 0.7])
    clear r slope intercept x pred
    end
end
plot(ax,xDataS,yDataS,'ok','MarkerFaceColor',[0 0 0])
[rhos,ps]=corr([xDataS,yDataS],'Type','Spearman');
%ts=text(ax,0,yl(2)+diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end
yl=get(ax,'YLim');
xl=get(ax,'XLim');
tc=text(ax,0,yl(2)+1.5*diff(yl)/10,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax,0,yl(2)+diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
   % keyboard
end
 
 
 
