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

%Generate figures
f1=figure('Name','Feedforward responses');
fb=figure;pd1=subplot(2,2,1);
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
ax2 = axes(f1,'Position',[0.38   0.08   0.25 0.8],'FontSize',8);%patients eA-B
ax4 = axes(f1,'Position',[0.08   0.08  0.25 0.8],'FontSize',8);%controls eA-B
ax1 = axes(f1,'Position',[0.75    0.08   0.23    0.48],'FontSize',10);%bar plots

[f1,fb,ax4,ax2,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax4,ax2,pd1,ep(2,:),baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');
close(fb)


Ylab=get(ax2,'YTickLabel');
for l=1:length(Ylab)
   Ylab{l}=Ylab{l}(2:end-1);
end

ax2.YTickLabel{1}= ['\color[rgb]{0.4660    0.6740    0.1880} ' ax2.YTickLabel{1}];
ax2.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{2}];
set(ax2,'YTickLabel',Ylab,'YAxisLocation','right')
set(ax4,'YTickLabel',{''})
for i=1:length(ax2.YTickLabel)
    if i<16
    ax2.YTickLabel{i}=['\color[rgb]{0.466 0.674 0.188} ' ax2.YTickLabel{i}];
    else
        ax2.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{i}];
    end
end


set(ax2,'FontSize',8,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax4,'FontSize',8,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})

colorbar('peer',ax2);
%map=flipud(repmat([0.3:0.01:1]',1,3));
%set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[ 0.7257    0.6908    0.2237    0.0264];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',10,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

h=title(ax4,'\DeltaEMG_U_P CONTROL');set(h,'FontSize',10);
h=title(ax2,'\DeltaEMG_U_P STROKE');set(h,'FontSize',10);


%hold(ax2)
plot(ax4,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[6.25 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[1 4.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[5.2 7.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[8 10.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[11.2 13.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[14 14.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[15.2 15.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[16 19.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[20.2 22.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[23 25.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[26.2 28.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax4,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',10,'FontWeight','Bold');
t2=text(ax4,-0.1,6,2,'KNEE','Rotation',90,'FontSize',10,'FontWeight','Bold');
t3=text(ax4,-0.1,12,2,'HIP','Rotation',90,'FontSize',10,'FontWeight','Bold');
t4=text(ax4,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',10,'FontWeight','Bold');
t5=text(ax4,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',10,'FontWeight','Bold');
t6=text(ax4,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',10,'FontWeight','Bold');
plot(ax4,[-0.17 -0.17],[0 14.9],'LineWidth',3,'Color',[0.466 0.674 0.188],'Clipping','off')
plot(ax4,[-0.17 -0.17],[15.1 30],'LineWidth',3,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax4,-0.27,6,2,'FAST','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',10,'FontWeight','Bold');
t8=text(ax4,-0.27,21,2,'SLOW','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',10,'FontWeight','Bold');
plot(ax2,[1.3 1.5],[30 30],'LineWidth',3,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax2,[1.3 1.5],[28 28],'LineWidth',3,'Color','k','Clipping','off')
t10=text(ax2,1.55,30,2,'FLEXORS','FontSize',10);
t11=text(ax2,1.55,28,2,'EXTENSORS','FontSize',10);

%hold(ax3)
plot(ax2,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[6.22 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')


hold(ax1)
bar1=bar(ax1,[1 3.5],[nanmedian(Bdata.eAs(:,1)),nanmedian(Bdata.eAf(:,1))],'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',1,'BarWidth',0.25);
bar2=bar(ax1,[2 4.5],[nanmedian(Bdata.eAs(:,2)),nanmedian(Bdata.eAf(:,2))],'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',1,'BarWidth',0.25);
hatchfill2(bar2);
errorbar(ax1,[1 3.5],[nanmedian(Bdata.eAs(:,1)),nanmedian(Bdata.eAf(:,1))],[iqr(Bdata.eAs(:,1)),iqr(Bdata.eAf(:,1))],'Color','k','LineWidth',1,'LineStyle','none');
errorbar(ax1,[2 4.5],[nanmedian(Bdata.eAs(:,2)),nanmedian(Bdata.eAf(:,2))],[iqr(Bdata.eAs(:,2)),iqr(Bdata.eAf(:,2))],'Color','k','LineWidth',1,'LineStyle','none');
set(ax1,'XLim',[0.5 5],'XTick',[1.5 4],'XTickLabel',{'SLOW','FAST'},'FontSize',10)
plot(ax1,[3.5 4.5],[0.8 0.8],'Color','k','LineWidth',2)
ll=findobj(ax1,'Type','Bar');
ll2=legend(ax1,flipud(ll),'Control','Stroke');
title(ax1,'\DeltaEMG_U_P STRUCTURE','FontSize',10)
set(ll2,'EdgeColor','none','Position',[ 0.8390    0.4759    0.1563    0.0898])
set(f1,'Renderer','painters');

[p1,h1]=ranksum(Bdata.eAs(:,1),Bdata.eAs(:,2))
[p2,h2]=ranksum(Bdata.eAf(:,1),Bdata.eAf(:,2))
