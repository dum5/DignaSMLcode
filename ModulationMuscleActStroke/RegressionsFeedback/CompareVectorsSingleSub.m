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

fastIdx=find(startsWith(labels,'f'));
slowIdx=find(startsWith(labels,'s'));
ePlA_C=eP_C-lA_C;
ePlA_S=eP_S-lA_S;

%do bootstrap for all vectors
[Bdata.eAf]=VectorSimBootstrapIndSubs(eA_C(fastIdx,:),eA_S(fastIdx,:));
[Bdata.eAs]=VectorSimBootstrapIndSubs(eA_C(slowIdx,:),eA_S(slowIdx,:));

[Bdata.lAf]=VectorSimBootstrapIndSubs(lA_C(fastIdx,:),lA_S(fastIdx,:));
[Bdata.lAs]=VectorSimBootstrapIndSubs(lA_C(slowIdx,:),lA_S(slowIdx,:));

[Bdata.ePlAf]=VectorSimBootstrapIndSubs(ePlA_C(fastIdx,:),ePlA_S(fastIdx,:));
[Bdata.ePlAs]=VectorSimBootstrapIndSubs(ePlA_C(slowIdx,:),ePlA_S(slowIdx,:));

[Bdata.ePf]=VectorSimBootstrapIndSubs(eP_C(fastIdx,:),eP_S(fastIdx,:));
[Bdata.ePs]=VectorSimBootstrapIndSubs(eP_C(slowIdx,:),eP_S(slowIdx,:));




figure
fullscreen
set(gcf,'Color',[1 1 1])
subplot(2,3,1)
hold on
[aa]=plotCosines(Bdata.eAf);
title('\DeltaEMG_U_P')
ylabel('fast')

% subplot(2,4,2)
% hold on
% [aa]=plotCosines(Bdata.ePlAf);
% title('FBK_s_p_l_i_t_-_t_o_-_t_i_e_d')

subplot(2,3,2)
hold on
[aa]=plotCosines(Bdata.lAf);
title('steady state')

subplot(2,3,3)
hold on
[aa]=plotCosines(Bdata.ePf);
title('after effect')
legend({'Controls','Stroke'})

subplot(2,3,4)
hold on
[aa]=plotCosines(Bdata.eAs);
ylabel('slow')

% subplot(2,4,6)
% hold on
% [aa]=plotCosines(Bdata.ePlAs);


subplot(2,3,5)
hold on
[aa]=plotCosines(Bdata.lAs);


subplot(2,3,6)
hold on
[aa]=plotCosines(Bdata.ePs);

names=strokesNames;
load([matDataDir,'bioData'])
fmSelect=NaN(length(names),1);
for s=1:length(names)
    temp = str2num(names{s}(2:end));
    fmSelect(s)=FM(temp);
    clear temp
end

figure
subplot(1,1,1)
set(gca,'XLim',[20 35],'YLim',[0 0.5])
plotCor(gca,fmSelect,Bdata.lAs(:,2))

function [aa]=plotCosines(Data);
aa=[];
bar(1,nanmean(Data(:,1)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hs=bar(2,nanmean(Data(:,2)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hatchfill2(hs);
errorbar(1,nanmean(Data(:,1)),std(Data(:,1))./size(Data,2),'Color',[0 0 0],'LineWidth',2);
errorbar(2,nanmean(Data(:,2)),std(Data(:,2))./size(Data,2),'Color',[0 0 0],'LineWidth',2);
set(gca,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',14,'FontWeight','bold')
[p,h]=ranksum(Data(:,1),Data(:,2));
yl=get(gca,'YLim');
text(0.5,yl(2),['p= ',num2str(round(p,3))],'FontSize',14);

end

function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
hold(ax)
a=[];
yl=get(ax,'YLim');
xl=get(ax,'XLim');
if nargin>3
   % yDataC=yDataC(find(~isnan(xDataC)));
   % xDataC=xDataC(find(~isnan(xDataC)));
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    tc=text(ax,xl(1),yl(2)+3*diff(yl)/10,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
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
ts=text(ax,xl(1),yl(2)+diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end


end


% 
% %plot([refcosine refcosine],[0 600],'Color','g','LineWidth',2)
% ylabel('number of observations')
% xlabel('cosine between vectors')
% legend({'ControlCosine','DistControl','StrokeCosine','DistStroke','strokeControl14'})
