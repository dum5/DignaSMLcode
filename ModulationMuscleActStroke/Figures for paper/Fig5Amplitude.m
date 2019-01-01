clear all
close all


f1=figure('Name','EMG structure');
%set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 3 3]);

ax1 = axes(f1,'Position',[0.12 0.58 0.35 0.35],'FontSize',6);%eA
ax2 = axes(f1,'Position',[0.6 0.58 0.35 0.35],'FontSize',6);%lA
ax3 = axes(f1,'Position',[0.12 0.12 0.35 0.35],'FontSize',6);%eP-lA
ax4 = axes(f1,'Position',[0.6 0.12 0.35 0.35],'FontSize',6);%eP

load('AmpDataFull.mat')
load('AmpDataSpM.mat')

[aa] = plotCosines(ax1,[AmpControlsFull.eA AmpStrokeFull.eA],[AmpControlsSpM.eA AmpStrokeSpM.eA],0);
[aa] = plotCosines(ax2,[AmpControlsFull.lA AmpStrokeFull.lA],[AmpControlsSpM.lA AmpStrokeSpM.lA],0);
[aa] = plotCosines(ax3,[AmpControlsFull.eP_lA AmpStrokeFull.eP_lA],[AmpControlsSpM.eP_lA AmpStrokeSpM.eP_lA],1);
[aa] = plotCosines(ax4,[AmpControlsFull.eP AmpStrokeFull.eP],[AmpControlsSpM.eP AmpStrokeSpM.eP],1);

title(ax1,'\DeltaEMG_U_P','FontSize',8)
title(ax2,'\DeltaEMG_S_S','FontSize',8)
title(ax3,'\DeltaEMG_P','FontSize',8)
title(ax4,'\DeltaEMG_A_F_T_E_R','FontSize',8)

ylabel(ax1,'Amplitude','FontSize',8)
ylabel(ax3,'Amplitude','FontSize',8)


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