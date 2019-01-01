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

%load data with vector sim data;
load([matDataDir,'vectorSimFull.mat']);
fmFull=fmSelect;
load([matDataDir,'vectorSimSpM.mat']);
fmSpM=fmSelect;


%Generate figures
f1=figure('Name','EMG structure');
fb=figure;pd1=subplot(2,2,1);
%set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 9]);
ax2 = axes(f1,'Position',[0.26   0.25   0.19 0.35],'FontSize',6);%patients eA-B
ax4 = axes(f1,'Position',[0.06   0.25 0.19 0.35],'FontSize',6);%controls eA-B
ax1 = axes(f1,'Position',[0.76   0.25   0.19 0.35],'FontSize',6);%patients eA-B
ax3 = axes(f1,'Position',[0.56   0.25  0.19 0.35],'FontSize',6);%controls eA-B
ax5 = axes(f1,'Position',[0.6123 0.07    0.2    0.125],'FontSize',6,'Box','off');%scatter plot
%axes for bar plots
ax6 = axes(f1,'Position',[0.07   0.84  0.20 0.12],'FontSize',6);
ax7 = axes(f1,'Position',[0.37   0.84  0.20 0.12],'FontSize',6);
ax8 = axes(f1,'Position',[0.67   0.84  0.20 0.12],'FontSize',6);
ax9 = axes(f1,'Position',[0.07   0.7  0.20 0.12],'FontSize',6);
ax10 = axes(f1,'Position',[0.37   0.7  0.20 0.12],'FontSize',6);
ax11 = axes(f1,'Position',[0.67   0.7  0.20 0.12],'FontSize',6);
%ax1 = axes(f1,'Position',[0.75    0.08   0.23    0.48],'FontSize',10);%bar plots

[f1,fb,ax4,ax2,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax4,ax2,pd1,ep(3,:),baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');
[f1,fb,ax3,ax1,pd2,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2,dataBinaryc2,dataBinarys2]=plotBGcompV2(f1,fb,ax3,ax1,pd1,ep(4,:),baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');

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


ax1.YTickLabel{1}= ['\color[rgb]{0.4660    0.6740    0.1880} ' ax1.YTickLabel{1}];
ax1.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax1.YTickLabel{2}];
set(ax1,'YTickLabel',Ylab,'YAxisLocation','right')
set(ax3,'YTickLabel',{''})
for i=1:length(ax1.YTickLabel)
    if i<16
    ax1.YTickLabel{i}=['\color[rgb]{0.466 0.674 0.188} ' ax1.YTickLabel{i}];
    else
        ax1.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax1.YTickLabel{i}];
    end
end


set(ax2,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax4,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax1,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax3,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})

colorbar('peer',ax4);
%map=flipud(repmat([0.3:0.01:1]',1,3));
%set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[0.10 0.12 0.2 0.0150];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',8,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

h=title(ax4,'\DeltaEMG_S_S CONTROL');set(h,'FontSize',8);
h=title(ax2,'\DeltaEMG_S_S STROKE');set(h,'FontSize',8);

h=title(ax3,'\DeltaEMG_A_F_T_E_R CONTROL');set(h,'FontSize',8);
h=title(ax1,'\DeltaEMG_A_F_T_E_R STROKE');set(h,'FontSize',8);

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
t1=text(ax4,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t2=text(ax4,-0.1,6,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t3=text(ax4,-0.1,12,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
t4=text(ax4,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t5=text(ax4,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t6=text(ax4,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
plot(ax4,[-0.17 -0.17],[0 14.9],'LineWidth',3,'Color',[0.466 0.674 0.188],'Clipping','off')
plot(ax4,[-0.17 -0.17],[15.1 30],'LineWidth',3,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax4,-0.27,6,2,'FAST','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',8,'FontWeight','Bold');
t8=text(ax4,-0.27,21,2,'SLOW','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',8,'FontWeight','Bold');
plot(ax4,[0.2 0.4],[-4 -4],'LineWidth',3,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax4,[0.2 0.4],[-6 -6],'LineWidth',3,'Color','k','Clipping','off')
t10=text(ax4,0.5,-4,2,'FLEXORS','FontSize',8);
t11=text(ax4,0.5,-6,2,'EXTENSORS','FontSize',8);

%hold(ax3)
plot(ax2,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[6.22 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')



%hold(ax2)
plot(ax3,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[6.25 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[1 4.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[5.2 7.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[8 10.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[11.2 13.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[14 14.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[15.2 15.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[16 19.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[20.2 22.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[23 25.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[26.2 28.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax3,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax3,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t2=text(ax3,-0.1,6,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t3=text(ax3,-0.1,12,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
t4=text(ax3,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t5=text(ax3,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t6=text(ax3,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
plot(ax3,[-0.17 -0.17],[0 14.9],'LineWidth',3,'Color',[0.466 0.674 0.188],'Clipping','off')
plot(ax3,[-0.17 -0.17],[15.1 30],'LineWidth',3,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax3,-0.27,6,2,'FAST','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',8,'FontWeight','Bold');
t8=text(ax3,-0.27,21,2,'SLOW','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',8,'FontWeight','Bold');

%hold(ax3)
plot(ax1,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax1,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax1,[6.22 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax1,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')

%scatter plot
plot(ax5,fmFull,BdataFull.lAs(:,2),'.k','MarkerSize',10)
title(ax5,'structure \DeltaEMG_S_S')
xlabel(ax5,'Fugl Meyer')
ylabel(ax5,'Structure')
[rho,pval]=corr(fmFull,BdataFull.lAs(:,2),'Type','Spearman');
ls=lsline(ax5);set(ls,'Color','k','LineWidth',2)
text(ax5,35,0.5,[' rho = ',num2str(round(rho,2)),newline,' p = ',num2str(round(pval,3))],'FontSize',8)
set(ax5,'Box','off')

%bar plots
[aa] = plotCosines(ax6,BdataFull.eAs,BdataSpM.eAs,0);
[aa] = plotCosines(ax7,BdataFull.lAs,BdataSpM.lAs,0);
[aa] = plotCosines(ax8,BdataFull.ePs,BdataSpM.ePs,0);

[aa] = plotCosines(ax9,BdataFull.eAf,BdataSpM.eAf,1);
[aa] = plotCosines(ax10,BdataFull.lAf,BdataSpM.lAf,1);
[aa] = plotCosines(ax11,BdataFull.ePf,BdataSpM.ePf,1);

title(ax6,'\DeltaEMG_U_P')
title(ax7,'\DeltaEMG_S_S')
title(ax8,'\DeltaEMG_A_F_T_E_R')
ylabel(ax6,'SLOW')
ylabel(ax9,'FAST')
set(ax9,'YTick',[0 0.4 0.8])
ll=findobj(ax8,'Type','Bar');
legend(ll(end:-1:1),{'CONTROL','STROKE'},'box','off','Position',[0.8375    0.9513    0.17    0.0436]);

set(f1,'Renderer','painters');
    function [aa]=plotCosines(ax,DataAll,DataSpM,xLabelFlag);
    hold(ax)
    aa=[];
    hc=bar(ax,[1 3.5],[nanmedian(DataAll(:,1)) nanmedian(DataSpM(:,1))],'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',1,'BarWidth',0.3);
    hs=bar(ax,[2 4.5],[nanmedian(DataAll(:,2)) nanmedian(DataSpM(:,2))],'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',1,'BarWidth',0.3);
    hatchfill2(hs);

    errorbar(ax,[1 3.5],[nanmedian(DataAll(:,1)) nanmedian(DataSpM(:,1))],[0 0],[iqr(DataAll(:,1)) iqr(DataSpM(:,1))],'Color',[0 0 0],'LineWidth',1,'LineStyle','none');
    errorbar(ax,[2 4.5],[nanmedian(DataAll(:,2)) nanmedian(DataSpM(:,2))],[0 0],[iqr(DataAll(:,2)) iqr(DataSpM(:,2))],'Color',[0 0 0],'LineWidth',1,'LineStyle','none');
    
    if xLabelFlag==1
        set(ax,'XLim',[0.5 5],'XTick',[1.5 4],'XTickLabel',{'All','Sp. Match'},'FontSize',8)
    else set(ax,'XLim',[0.5 5],'XTick',[1.5 4],'XTickLabel',{'',''},'FontSize',8)
    end
    [p1,h1]=ranksum(DataAll(:,1),DataAll(:,2))
    [p2,h2]=ranksum(DataSpM(:,1),DataSpM(:,2))

    yl=get(ax,'YLim');
    set(ax,'YLim',[0,yl(2)*1.1]);

    if p1<0.05
       plot(ax,[1 2],[1.05*yl(2) 1.05*yl(2)],'Color','k','LineWidth',2);
    end
    if p2<0.05
        plot(ax,[3.5 4.5],[1.05*yl(2) 1.05*yl(2)],'Color','k','LineWidth',2);
    end
    end


