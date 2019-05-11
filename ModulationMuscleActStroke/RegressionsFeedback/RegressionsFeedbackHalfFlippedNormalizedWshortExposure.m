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

ep=defineEpochs({'BASE','eA','lA','eP','eB','lS'},{'TM base','Adaptation','Adaptation','Washout','TM base','short split'},[-40 nstrides -40 nstrides nstrides -8],[eE eE eE eE eE eE],[eL eL eL eL eL eL],summethod);
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
Index = find(contains(labels2,'sSOL'));%find all Soleus muscle data in the labels
ptIdx=find(contains(strokesNames,'P0005'));
if ~isempty(ptIdx)
SdataEMG(Index,:,ptIdx)=NaN;%I checked this and it indeed removes all the large peaks from the subject data, regardles of which subs are selected
SdataEMG(Index,:,ptIdx)=nanmedian(SdataEMG(Index,:,:),3);
end
%Flipping EMG:
CdataEMG=reshape(flipEMGdata(reshape(CdataEMG,size(labels,1),size(labels,2),size(CdataEMG,2),size(CdataEMG,3)),1,2),numel(labels),size(CdataEMG,2),size(CdataEMG,3));
SdataEMG=reshape(flipEMGdata(reshape(SdataEMG,size(labels,1),size(labels,2),size(SdataEMG,2),size(SdataEMG,3)),1,2),numel(labels),size(SdataEMG,2),size(SdataEMG,3));

%% Get all the eA, lA, eP vectors, note that eB is right after short exposure
shortNames={'lB','eA','lA','eP','eB','lS'};
longNames={'BASE','eA','lA','eP','eB','lS'};
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
        
        eP_lA_C=eP_C-lA_C;
        eB_lS_C=eB_C-lS_C;
        
        eP_lA_S=eP_S-lA_S;
        eB_lS_S=eB_S-lS_S;
        
        %controls are always their own reference
        ttC=table(-nanmedian(eA_C(:,cIdx),2), nanmedian(eAT_C(:,cIdx),2), -nanmedian(lA_C(:,cIdx),2), nanmedian(eP_lA_C(:,cIdx),2),nanmedian(eB_lS_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA','eB_lS'});
        
        %stroke with themselves as a reference
        ttS=table(-nanmedian(eA_S(:,pIdx),2), nanmedian(eAT_S(:,pIdx),2), -nanmedian(lA_S(:,pIdx),2), nanmedian(eP_lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
       
        %stroke with control reference for eAT
        ttSHalfFlipped=table(-nanmedian(eA_S(:,pIdx),2), nanmedian(eAT_C(:,cIdx),2), -nanmedian(lA_S(:,pIdx),2), nanmedian(eP_lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
        
        
        %this is to account for the fact that pt 11 did not perform the
        %short exposure
        shIdx=find(~isnan(lS_S(1,:)));
        ttSShort=table(-nanmedian(eA_S(:,shIdx),2), nanmedian(eAT_S(:,shIdx),2), -nanmedian(lA_S(:,shIdx),2), nanmedian(eB_lS_S(:,shIdx),2),'VariableNames',{'eA','eAT','lA','eB_lS'});
        
        ttSHalfFlippedShort=table(-nanmedian(eA_S(:,shIdx),2), nanmedian(eAT_C(:,cIdx),2), -nanmedian(lA_S(:,shIdx),2), nanmedian(eB_lS_S(:,shIdx),2),'VariableNames',{'eA','eAT','lA','eB_lS'});
        
        %ttSHalFFlippedShort=
    else
%         ttC=table(-mean(eA_C(:,cIdx),2), mean(eAT_C(:,cIdx),2), -mean(lA_C(:,cIdx),2), mean(eP_C(:,cIdx),2)-mean(lA_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
%         %patients that are don't have good data will be removed
%         ttS=table(-mean(eA_S(:,pIdx),2), mean(eAT_S(:,pIdx),2), -mean(lA_S(:,pIdx),2), mean(eP_S(:,pIdx),2)-mean(lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    end
    
  
   fIds=1:180;
   sIds=181:360;
   
  %create vectors for single leg
   ttCSlow=ttC(sIds,:);  
   ttSSlow=ttS(sIds,:);
   ttSHalfFlippedSlow=ttSHalfFlipped(sIds,:);
   ttSShortSlow=ttSShort(sIds,:);
   ttSHalfFlippedSlowShort=ttSHalfFlippedShort(sIds,:);%subject 11 did not do short exposure, so this subject was not included
   
   ttCFast=ttC(fIds,:);
   ttSFast=ttS(fIds,:);
   ttSHalfFlippedFast=ttSHalfFlipped(fIds,:);
   ttSShortFast=ttSShort(fIds,:);
   ttSHalfFlippedFastShort=ttSHalfFlippedShort(fIds,:);
    
   %normalizing vectors
   ttCSlow=fcnNormTable(ttCSlow);
   ttSSlow=fcnNormTable(ttSSlow);
   ttSHalfFlippedSlow=fcnNormTable(ttSHalfFlippedSlow);
   ttSShortSlow=fcnNormTable(ttSShortSlow);
   ttSHalfFlippedSlowShort=fcnNormTable(ttSHalfFlippedSlowShort);
   
   ttCFast=fcnNormTable(ttCFast);
   ttSFast=fcnNormTable(ttSFast);
   ttSHalfFlippedFast=fcnNormTable(ttSHalfFlippedFast);
   ttSShortFast=fcnNormTable(ttSShortFast);
   ttSHalfFlippedFastShort=fcnNormTable(ttSHalfFlippedFastShort);
   
   
   
  
    %For the full group we only do the slow leg and use the control
    %fast leg as a reference. This is because the non-paretic leg's
    %responses are atypical.
    
    %Control models
    Cmodel1aSlow=fitlm(ttCSlow,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Cmodel1bSlow=fitlm(ttCSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    Cmodel1aFast=fitlm(ttCFast,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Cmodel1bFast=fitlm(ttCFast,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    %Stroke with own ref
    Smodel1aSlow=fitlm(ttSShortSlow,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Smodel1bSlow=fitlm(ttSSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    Smodel1aFast=fitlm(ttSShortFast,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Smodel1bFast=fitlm(ttSFast,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    %Stroke with control ref
    Smodel1aSlowFl=fitlm(ttSHalfFlippedSlowShort,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Smodel1bSlowFl=fitlm(ttSHalfFlippedSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    Smodel1aFastFl=fitlm(ttSHalfFlippedFastShort,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);%short exposure
    Smodel1bFastFl=fitlm(ttSHalfFlippedFast,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);%long exposure 
    
    %%Stroke and control no normalized (onw ref)
     %Control models
    Cmodel2aSlow=fitlm(ttCSlow,'eB_lS~eA+eAT-1','RobustOpts',rob);%short exposure
    Cmodel2bSlow=fitlm(ttCSlow,'eP_lA~eA+eAT-1','RobustOpts',rob);%long exposure 
    
    Cmodel2aFast=fitlm(ttCFast,'eB_lS~eA+eAT-1','RobustOpts',rob);%short exposure
    Cmodel2bFast=fitlm(ttCFast,'eP_lA~eA+eAT-1','RobustOpts',rob);%long exposure 
    
    %Stroke with own ref
    Smodel2aSlow=fitlm(ttSShortSlow,'eB_lS~eA+eAT-1','RobustOpts',rob);%short exposure
    Smodel2bSlow=fitlm(ttSSlow,'eP_lA~eA+eAT-1','RobustOpts',rob);%long exposure 
    
    Smodel2aFast=fitlm(ttSShortFast,'eB_lS~eA+eAT-1','RobustOpts',rob);%short exposure
    Smodel2bFast=fitlm(ttSFast,'eP_lA~eA+eAT-1','RobustOpts',rob);%long exposure 
    
    
%     CmodelFit4=fitlm(ttCSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
%     SmodelFit4=fitlm(ttSHalfFlippedSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
%     CmodelFit2=fitlm(ttCSlow,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
%     SmodelFit2=fitlm(ttSHalfFlippedSlowShort,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
%     ClongR2=uncenteredRsquared(CmodelFit4);ClongR2=ClongR2.uncentered
%     SlongR2=uncenteredRsquared(SmodelFit4);SlongR2=SlongR2.uncentered
%     CshortR2=uncenteredRsquared(CmodelFit2);CshortR2=CshortR2.uncentered
%     SshortR2=uncenteredRsquared(SmodelFit2);SshortR2=SshortR2.uncentered
%     
    
    
    figure;fullscreen;set(gcf,'Color',[1 1 1]);
    
    subplot(2,2,1);hold on;
    aa=CompareElipses(Cmodel1aSlow,Smodel1aSlow);aa=CompareElipses(Cmodel1bSlow,Smodel1bSlow);
    set(gca,'XLim',[0 1],'YLim',[0 1]);%slow leg each group with own ref
    title('Slow Own Ref Normalized')
    grid on
    
    subplot(2,2,2);hold on;
    aa=CompareElipses(Cmodel2aSlow,Smodel2aSlow);aa=CompareElipses(Cmodel2bSlow,Smodel2bSlow);
    set(gca,'XLim',[0 1],'YLim',[0 1]);
    title('Slow Own Ref Not Normalized')
    grid on
    
    subplot(2,2,3);hold on;
    aa=CompareElipses(Cmodel1aFast,Smodel1aFast);aa=CompareElipses(Cmodel1bFast,Smodel1bFast);
    set(gca,'XLim',[0 1],'YLim',[0 1]);%slow leg each group with own ref
    title('Fast Own Ref Normalized')
    grid on
    
    subplot(2,2,4);hold on;
    aa=CompareElipses(Cmodel2aFast,Smodel2aFast);aa=CompareElipses(Cmodel2bFast,Smodel2bFast);
    set(gca,'XLim',[0 1],'YLim',[0 1]);
    title('Fast Own Ref Not Normalized')
    grid on
    
    figure
    subplot (2,2,1)
    hold on
    bar([1,5],[norm(ttCSlow.eA), norm(ttCFast.eA)],'FaceColor',[1 1 1],'BarWidth',0.2)
    bar([2,6],[norm(ttCSlow.eAT), norm(ttCFast.eAT)],'FaceColor',[0.5 0.5 0.5],'BarWidth',0.2)
    bar([3,7],[norm(ttCSlow.eP_lA), norm(ttCFast.eP_lA)],'FaceColor',[0 0 0],'BarWidth',0.2)
    set(gca,'XTick',[2 6],'XTickLabel',{'Slow','Fast'},'XLim',[0.5 7.5])
    title('Amplitude Controls')
    
    subplot (2,2,2)
    hold on
    bar([1,5],[norm(ttSSlow.eA), norm(ttSFast.eA)],'FaceColor',[1 1 1],'BarWidth',0.2)
    bar([2,6],[norm(ttSSlow.eAT), norm(ttSFast.eAT)],'FaceColor',[0.5 0.5 0.5],'BarWidth',0.2)
    bar([3,7],[norm(ttSSlow.eP_lA), norm(ttSFast.eP_lA)],'FaceColor',[0 0 0],'BarWidth',0.2)
    legend('\DeltaEMG_o_n_(_+_)','\DeltaEMG_o_n_(_-_)','\DeltaEMG_o_f_f_(_+_)')
    set(gca,'XTick',[2 6],'XTickLabel',{'Slow','Fast'},'XLim',[0.5 7.5])
    title('Amplitude Stroke')
    
    nsub=length(controlsNames);
    emptycol=NaN(2*nsub,1);
    emptycol2=cell(size(emptycol));
    IndRegressions=table(emptycol2,emptycol2,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,emptycol,...
        'VariableNames',{'group','sub','FM','sBElong','sBAlong','sBEshort','sBAshort','s_longR2','s_shortR2','fBElong','fBAlong','fBEshort','fBAshort','f_shortR2','f_longR2','s_pLong','s_pShort','f_pLong','f_pShort','s_CIlong','s_CIshort','f_CIlong','f_CIshort','vel','age'});
    load bioData ;
    %% Individual models::
    rob='off'; %These models can't be fit robustly (doesn't converge)
    %First: repeat the model(s) above on each subject:
%     clear CmodelFitAll* ClearnAll* SmodelFitAll* SlearnAll*
%     ClearnAll4=NaN(16,2);
%     SlearnAll4=NaN(16,2);
%     Cr2All2=NaN(16,1);
%     Sr2All2=NaN(16,1);
  CosOnOffSlow=emptycol;
  CosOnOffFast=emptycol;
  CosSFeA=emptycol;
  CosSFeP_lA=emptycol;
   % 
    for sj=1:nsub
        IndRegressions.group(sj)={'Control'};
        sjcode = cNames(sj);
        IndRegressions.sub(sj)=sjcode;
        tempCode=cell2mat(sjcode);
        IndRegressions.vel(sj)=velsC(str2num(tempCode(end-2:end)));
        IndRegressions.age(sj)=groups{1}.adaptData{sj}.getSubjectAgeAtExperimentDate/12;
        
        %table for slow leg
        dtSlow=table;
        dtSlow.eA=-eA_C(sIds,sj);
        dtSlow.eAT=eAT_C(sIds,sj);
        dtSlow.eP_lA=eP_C(sIds,sj)-lA_C(sIds,sj);
        dtSlow.eB_lS=eB_lS_C(sIds,sj);
        dtSlow = fcnNormTable(dtSlow);
        
        
        
        %models for slow leg
        %long exposure
        tmod=fitlm(dtSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM=find(strcmp(tmod.PredictorNames,'eATnorm'),1,'first');
        IdxBS=find(strcmp(tmod.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.sBElong(sj)=tmod.Coefficients.Estimate(IdxBS);
        IndRegressions.sBAlong(sj)=tmod.Coefficients.Estimate(IdxBM);
        R2=uncenteredRsquared(tmod);IndRegressions.s_longR2(sj)=R2.uncentered;
        longCI=tmod.coefCI;
        IndRegressions.s_CIlong(sj)=diff(longCI(1,:))/2;
        [IndRegressions.s_pLong(sj),dummy]=coefTest(tmod);
    
        %short exposure
        tmod2=fitlm(dtSlow,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM2=find(strcmp(tmod2.PredictorNames,'eATnorm'),1,'first');
        IdxBS2=find(strcmp(tmod2.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.sBEshort(sj)=tmod2.Coefficients.Estimate(IdxBS2);
        IndRegressions.sBAshort(sj)=tmod2.Coefficients.Estimate(IdxBM2);
        R2=uncenteredRsquared(tmod2);IndRegressions.s_shortR2(sj)=R2.uncentered;
        shortCI=tmod2.coefCI;
        IndRegressions.s_CIshort(sj)=diff(shortCI(1,:))/2;
        [IndRegressions.s_pShort(sj),dummy]=coefTest(tmod2);
        
        clear tmod tmod2 R2 IdxBM IdxBS IdxBM2 IdxBS2 longCI shortCI
        
        %table for fast leg
        dtFast=table;
        dtFast.eA=-eA_C(fIds,sj);
        dtFast.eAT=eAT_C(fIds,sj);
        dtFast.eP_lA=eP_C(fIds,sj)-lA_C(fIds,sj);
        dtFast.eB_lS=eB_lS_C(fIds,sj);
        dtFast = fcnNormTable(dtFast);
        
        %models for fast leg
        %long exposure
        tmod=fitlm(dtFast,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM=find(strcmp(tmod.PredictorNames,'eATnorm'),1,'first');
        IdxBS=find(strcmp(tmod.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.fBElong(sj)=tmod.Coefficients.Estimate(IdxBS);
        IndRegressions.fBAlong(sj)=tmod.Coefficients.Estimate(IdxBM);
        R2=uncenteredRsquared(tmod);IndRegressions.f_longR2(sj)=R2.uncentered;
        longCI=tmod.coefCI;
        IndRegressions.f_CIlong(sj)=diff(longCI(1,:))/2;
        [IndRegressions.f_pLong(sj),dummy]=coefTest(tmod);
    
        %short exposure
        tmod2=fitlm(dtFast,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM2=find(strcmp(tmod2.PredictorNames,'eATnorm'),1,'first');
        IdxBS2=find(strcmp(tmod2.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.fBEshort(sj)=tmod2.Coefficients.Estimate(IdxBS2);
        IndRegressions.fBAshort(sj)=tmod2.Coefficients.Estimate(IdxBM2);
        R2=uncenteredRsquared(tmod2);IndRegressions.f_shortR2(sj)=R2.uncentered;
        shortCI=tmod2.coefCI;
        IndRegressions.f_CIshort(sj)=diff(shortCI(1,:))/2;
        [IndRegressions.f_pShort(sj),dummy]=coefTest(tmod2);
        
        CosOnOffSlow(sj,1)=cosine(-dtSlow.eA,dtSlow.eP_lA); 
        CosOnOffFast(sj,1)=cosine(-dtFast.eA,dtFast.eP_lA);
        CosSFeA(sj,1)=cosine(-dtSlow.eA,-dtFast.eA);
        CosSFeP_lA(sj,1)=cosine(dtSlow.eP_lA,dtFast.eP_lA);
        clear dtFast dtSlow c sjcode tmod IdxBM IdxBS tmod2 IdxBM2 IdxBS2 
    end
    
    for sj=1:nsub
        IndRegressions.group(sj+nsub)={'Stroke'};
        sjcode = sNames(sj);
        IndRegressions.sub(sj+nsub)=sjcode;
        tempCode=cell2mat(sjcode);
        IndRegressions.FM(sj+nsub)=FM(str2num(tempCode(end-2:end)));
        IndRegressions.vel(sj+nsub)=velsS(str2num(tempCode(end-2:end)));
        IndRegressions.age(sj+nsub)=groups{2}.adaptData{sj}.getSubjectAgeAtExperimentDate/12;
        
        
        %table for slow leg
        dtSlow=table;
        dtSlow.eA=-eA_S(sIds,sj);
        dtSlow.eAT=eAT_S(sIds,sj);
        dtSlow.eP_lA=eP_S(sIds,sj)-lA_S(sIds,sj);
        dtSlow.eB_lS=eB_lS_S(sIds,sj);
        dtSlow = fcnNormTable(dtSlow);
        
        %models for slow leg
        %long exposure
        tmod=fitlm(dtSlow,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM=find(strcmp(tmod.PredictorNames,'eATnorm'),1,'first');
        IdxBS=find(strcmp(tmod.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.sBElong(sj+nsub)=tmod.Coefficients.Estimate(IdxBS);
        IndRegressions.sBAlong(sj+nsub)=tmod.Coefficients.Estimate(IdxBM);
        R2=uncenteredRsquared(tmod);IndRegressions.s_longR2(sj+nsub)=R2.uncentered;
        longCI=tmod.coefCI;
        IndRegressions.s_CIlong(sj+nsub)=diff(longCI(1,:))/2;
        [IndRegressions.s_pLong(sj+nsub),dummy]=coefTest(tmod);
    
        %short exposure
        tmod2=fitlm(dtSlow,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM2=find(strcmp(tmod2.PredictorNames,'eATnorm'),1,'first');
        IdxBS2=find(strcmp(tmod2.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.sBEshort(sj+nsub)=tmod2.Coefficients.Estimate(IdxBS2);
        IndRegressions.sBAshort(sj+nsub)=tmod2.Coefficients.Estimate(IdxBM2);
        R2=uncenteredRsquared(tmod2);IndRegressions.s_shortR2(sj+nsub)=R2.uncentered;
        shortCI=tmod2.coefCI;
        IndRegressions.s_CIshort(sj+nsub)=diff(shortCI(1,:))/2;
        try 
            [IndRegressions.s_pShort(sj+nsub),dummy]=coefTest(tmod2);
        catch
           IndRegressions.s_pShort(sj+nsub)=NaN; 
        end
        clear tmod tmod2 R2 IdxBM IdxBS IdxBM2 IdxBS2 longCI shortCI
        
        %table for fast leg
        dtFast=table;
        dtFast.eA=-eA_S(fIds,sj);
        dtFast.eAT=eAT_S(fIds,sj);
        dtFast.eP_lA=eP_S(fIds,sj)-lA_S(fIds,sj);
        dtFast.eB_lS=eB_lS_S(fIds,sj);
        dtFast = fcnNormTable(dtFast);
        
        %models for fast leg
        %long exposure
        tmod=fitlm(dtFast,'eP_lAnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM=find(strcmp(tmod.PredictorNames,'eATnorm'),1,'first');
        IdxBS=find(strcmp(tmod.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.fBElong(sj+nsub)=tmod.Coefficients.Estimate(IdxBS);
        IndRegressions.fBAlong(sj+nsub)=tmod.Coefficients.Estimate(IdxBM);
        R2=uncenteredRsquared(tmod);IndRegressions.f_longR2(sj+nsub)=R2.uncentered;
        longCI=tmod.coefCI;
        IndRegressions.f_CIlong(sj+nsub)=diff(longCI(1,:))/2;
        [IndRegressions.f_pLong(sj+nsub),dummy]=coefTest(tmod);
    
        %short exposure
        tmod2=fitlm(dtFast,'eB_lSnorm~eAnorm+eATnorm-1','RobustOpts',rob);
        IdxBM2=find(strcmp(tmod2.PredictorNames,'eATnorm'),1,'first');
        IdxBS2=find(strcmp(tmod2.PredictorNames,'eAnorm'),1,'first');
        IndRegressions.fBEshort(sj+nsub)=tmod2.Coefficients.Estimate(IdxBS2);
        IndRegressions.fBAshort(sj+nsub)=tmod2.Coefficients.Estimate(IdxBM2);
        R2=uncenteredRsquared(tmod2);IndRegressions.f_shortR2(sj+nsub)=R2.uncentered;
        shortCI=tmod2.coefCI;
        IndRegressions.f_CIshort(sj+nsub)=diff(shortCI(1,:))/2;
        try 
            [IndRegressions.f_pShort(sj+nsub),dummy]=coefTest(tmod2);
        catch
            IndRegressions.f_pShort(sj+nsub)=NaN;
        end
        CosOnOffSlow(sj+nsub,1)=cosine(-dtSlow.eA,dtSlow.eP_lA); 
        CosOnOffFast(sj+nsub,1)=cosine(-dtFast.eA,dtFast.eP_lA);
        CosSFeA(sj+nsub,1)=cosine(-dtSlow.eA,-dtFast.eA);
        CosSFeP_lA(sj+nsub,1)=cosine(dtSlow.eP_lA,dtFast.eP_lA);
        clear dtFast dtSlow c sjcode tmod IdxBM IdxBS tmod2 IdxBM2 IdxBS2         
       
    end
    
    %normalize each variable in a table
    function [normTable] = fcnNormTable(Table)
    vnames=Table.Properties.VariableNames;
    newvnames=strcat(vnames,'norm');
    for n=1:length(vnames)
        Table.(newvnames{n})=Table.(vnames{n})./norm(Table.(vnames{n}));
    end
    normTable=Table;
    end