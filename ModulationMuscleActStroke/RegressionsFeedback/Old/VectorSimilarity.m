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

%if allSubFlag==0; %if this is set to 1, the bad subjects are in the analysis, so don't run the group analysis
    
    if groupMedianFlag
        ttC=table(-median(eA_C(:,cIdx),2), median(eAT_C(:,cIdx),2), -median(lA_C(:,cIdx),2), median(eP_C(:,cIdx),2)-median(lA_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
        %patients that are don't have good data will be removed
        ttS=table(-median(eA_S(:,pIdx),2), median(eAT_S(:,pIdx),2), -median(lA_S(:,pIdx),2), median(eP_S(:,pIdx),2)-median(lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    
        ttSFlipped=table(-median(eA_C(:,cIdx),2), median(eAT_C(:,cIdx),2), -median(lA_C(:,cIdx),2), median(eP_S(:,cIdx),2)-median(lA_S(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
        %patients that are don't have good data will be removed
        ttCFlipped=table(-median(eA_S(:,pIdx),2), median(eAT_S(:,pIdx),2), -median(lA_S(:,pIdx),2), median(eP_C(:,pIdx),2)-median(lA_C(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    
        ttSHalfFlipped=table(-median(eA_S(:,cIdx),2), median(eAT_C(:,cIdx),2), -median(lA_C(:,cIdx),2), median(eP_S(:,cIdx),2)-median(lA_S(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
        %patients that are don't have good data will be removed
        ttCHalfFlipped=table(-median(eA_C(:,pIdx),2), median(eAT_S(:,pIdx),2), -median(lA_S(:,pIdx),2), median(eP_C(:,pIdx),2)-median(lA_C(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    
    else
        ttC=table(-mean(eA_C(:,cIdx),2), mean(eAT_C(:,cIdx),2), -mean(lA_C(:,cIdx),2), mean(eP_C(:,cIdx),2)-mean(lA_C(:,cIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
        %patients that are don't have good data will be removed
        ttS=table(-mean(eA_S(:,pIdx),2), mean(eAT_S(:,pIdx),2), -mean(lA_S(:,pIdx),2), mean(eP_S(:,pIdx),2)-mean(lA_S(:,pIdx),2),'VariableNames',{'eA','eAT','lA','eP_lA'});
    end
    
  
   fIds=1:180;
   sIds=181:360;
   
   ttCFast=ttC(fIds,:);
   ttCSlow=ttC(sIds,:); 
   ttSFast=ttS(fIds,:);
   ttSSlow=ttS(sIds,:); 
   
   ttCFlippedFast=ttCFlipped(fIds,:);
   ttCFlippedSlow=ttCFlipped(sIds,:); 
   ttSFlippedFast=ttSFlipped(fIds,:);
   ttSFlippedSlow=ttSFlipped(sIds,:);
   
   ttCHalfFlippedFast=ttCHalfFlipped(fIds,:);
   ttSHalfFlippedFast=ttSHalfFlipped(fIds,:);
   
    %normalizing vectors
    ttC.eATnorm=ttC.eAT./norm(ttC.eAT);
    ttC.eP_lAnorm=ttC.eP_lA./norm(ttC.eP_lA);
    ttC.eAnorm=ttC.eA./norm(ttC.eA);
    
    ttS.eATnorm=ttS.eAT./norm(ttS.eAT);
    ttS.eP_lAnorm=ttS.eP_lA./norm(ttS.eP_lA);
    ttS.eAnorm=ttS.eA./norm(ttS.eA);
    
    ttCFlipped.eATnorm=ttCFlipped.eAT./norm(ttCFlipped.eAT);
    ttCFlipped.eP_lAnorm=ttCFlipped.eP_lA./norm(ttCFlipped.eP_lA);
    ttCFlipped.eAnorm=ttCFlipped.eA./norm(ttCFlipped.eA);
    
    ttSFlipped.eATnorm=ttSFlipped.eAT./norm(ttSFlipped.eAT);
    ttSFlipped.eP_lAnorm=ttSFlipped.eP_lA./norm(ttSFlipped.eP_lA);
    ttSFlipped.eAnorm=ttSFlipped.eA./norm(ttSFlipped.eA);
    
    ttCFast.eATnorm=ttCFast.eAT./norm(ttCFast.eAT);
    ttCFast.eP_lAnorm=ttCFast.eP_lA./norm(ttCFast.eP_lA);
    ttCFast.eAnorm=ttCFast.eA./norm(ttCFast.eA);
    
    ttSFast.eATnorm=ttSFast.eAT./norm(ttSFast.eAT);
    ttSFast.eP_lAnorm=ttSFast.eP_lA./norm(ttSFast.eP_lA);
    ttSFast.eAnorm=ttSFast.eA./norm(ttSFast.eA);
    
    ttCFlippedFast.eATnorm=ttCFlippedFast.eAT./norm(ttCFlippedFast.eAT);
    ttCFlippedFast.eP_lAnorm=ttCFlippedFast.eP_lA./norm(ttCFlippedFast.eP_lA);
    ttCFlippedFast.eAnorm=ttCFlippedFast.eA./norm(ttCFlippedFast.eA);
    
    ttSFlippedFast.eATnorm=ttSFlippedFast.eAT./norm(ttSFlippedFast.eAT);
    ttSFlippedFast.eP_lAnorm=ttSFlippedFast.eP_lA./norm(ttSFlippedFast.eP_lA);
    ttSFlippedFast.eAnorm=ttSFlippedFast.eA./norm(ttSFlippedFast.eA);
    
    
    ttCSlow.eATnorm=ttCSlow.eAT./norm(ttCSlow.eAT);
    ttCSlow.eP_lAnorm=ttCSlow.eP_lA./norm(ttCSlow.eP_lA);
    ttCSlow.eAnorm=ttCSlow.eA./norm(ttCSlow.eA);
    
    ttSSlow.eATnorm=ttSSlow.eAT./norm(ttSSlow.eAT);
    ttSSlow.eP_lAnorm=ttSSlow.eP_lA./norm(ttSSlow.eP_lA);
    ttSSlow.eAnorm=ttSSlow.eA./norm(ttSSlow.eA);
    
    ttCFlippedSlow.eATnorm=ttCFlippedSlow.eAT./norm(ttCFlippedSlow.eAT);
    ttCFlippedSlow.eP_lAnorm=ttCFlippedSlow.eP_lA./norm(ttCFlippedSlow.eP_lA);
    ttCFlippedSlow.eAnorm=ttCFlippedSlow.eA./norm(ttCFlippedSlow.eA);
    
    ttSFlippedSlow.eATnorm=ttSFlippedSlow.eAT./norm(ttSFlippedSlow.eAT);
    ttSFlippedSlow.eP_lAnorm=ttSFlippedSlow.eP_lA./norm(ttSFlippedSlow.eP_lA);
    ttSFlippedSlow.eAnorm=ttSFlippedSlow.eA./norm(ttSFlippedSlow.eA);
    
    ttCHalfFlippedFast.eATnorm=ttCHalfFlippedFast.eAT./norm(ttCHalfFlippedFast.eAT);
    ttCHalfFlippedFast.eP_lAnorm=ttCHalfFlippedFast.eP_lA./norm(ttCHalfFlippedFast.eP_lA);
    ttCHalfFlippedFast.eAnorm=ttCHalfFlippedFast.eA./norm(ttCHalfFlippedFast.eA);
    
    ttSHalfFlippedFast.eATnorm=ttSHalfFlippedFast.eAT./norm(ttSHalfFlippedFast.eAT);
    ttSHalfFlippedFast.eP_lAnorm=ttSHalfFlippedFast.eP_lA./norm(ttSHalfFlippedFast.eP_lA);
    ttSHalfFlippedFast.eAnorm=ttSHalfFlippedFast.eA./norm(ttSHalfFlippedFast.eA);
    
    ttCHalfFlipped.eATnorm=ttCHalfFlipped.eAT./norm(ttCHalfFlipped.eAT);
    ttCHalfFlipped.eP_lAnorm=ttCHalfFlipped.eP_lA./norm(ttCHalfFlipped.eP_lA);
    ttCHalfFlipped.eAnorm=ttCHalfFlipped.eA./norm(ttCHalfFlipped.eA);
    
    ttSHalfFlipped.eATnorm=ttSHalfFlipped.eAT./norm(ttSHalfFlipped.eAT);
    ttSHalfFlipped.eP_lAnorm=ttSHalfFlipped.eP_lA./norm(ttSHalfFlipped.eP_lA);
    ttSHalfFlipped.eAnorm=ttSHalfFlipped.eA./norm(ttSHalfFlipped.eA);
    

   
    
    figure
    da=subplot(1,3,1);
    [a]=plotCor(da,ttC.eAnorm,ttS.eAnorm)
    title(da,'eAnorm')
    ylabel('Controls')
    xlabel('Stroke')
    da=subplot(1,3,2);
    [a]=plotCor(da,ttCFast.eAnorm,ttSFast.eAnorm)
    title(da,'eAnormFast')
     xlabel('Stroke')
    da=subplot(1,3,3);
    [a]=plotCor(da,ttCSlow.eAnorm,ttSSlow.eAnorm)
    title(da,'eAnormSlow')
     xlabel('Stroke')
    
    
function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
    hold(ax)
    a=[];
    yl=max(yDataS);
    xl=0;
    if nargin>3
         yl=max([yDataS; yDataC]);
       % yDataC=yDataC(find(~isnan(xDataC)));
       % xDataC=xDataC(find(~isnan(xDataC)));
        plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
        [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
        tc=text(ax,xl,yl,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
        if pc(2)<0.05
        [r,slope,intercept] = regression(xDataC,yDataC,'one');
        x=get(ax,'XLim');
        pred=intercept+slope.*x;
        plot(ax,x,pred,'-k','LineWidth',2','Color',[0.7 0.7 0.7])
        clear r slope intercept x pred
        end
    end
    plot(ax,xDataS,yDataS,'ok','MarkerFaceColor',[0.5 0.5 0.5])
    [rhos,ps]=corr([xDataS,yDataS],'Type','Spearman');
    ts=text(ax,xl,yl,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
    if ps(2)<0.05
        [r,slope,intercept] = regression(xDataS,yDataS,'one');
        x=get(ax,'XLim');
        pred=intercept+slope.*x;
        plot(ax,x,pred,'-k','LineWidth',2')
        clear r slope intercept x pred
    end


end
 
 

   
%     if speedMatchFlag==0
%         save([matDataDir,'GroupMedianRegressionHalfFlippedFullNoNorm.mat'],'CmodelFit2','SmodelFit2','CmodelFit3','SmodelFit3');
%     elseif speedMatchFlag==1
%         save([matDataDir,'GroupMedianRegressionHalfFlippedSpeedMatchNoNorm.mat'],'CmodelFit2','SmodelFit2','CmodelFit3','SmodelFit3');
%     end
    
