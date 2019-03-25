clear all
close all

f1=figure('Name','Ellipses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 3]);
ax1 = axes(f1,'Position',[0.08   0.14   1.1*0.35  1.1*0.7],'FontSize',8);%full group
ax2 = axes(f1,'Position',[0.58   0.14   1.1*0.35  1.1*0.7],'FontSize',8);%speed matched

load('FinalRegressionFullGroup')
hold(ax1)
aa=CompareElipses(CmodelFit4,SmodelFit4,ax1);aa=CompareElipses(CmodelFit2,SmodelFit2,ax1);

clear CmodelFit4 SmodelFit4 CmodelFit2 SmodelFit2


load('FinalRegressionSpeedMatched')
hold(ax2)
aa=CompareElipses(CmodelFit4,SmodelFit4,ax2);aa=CompareElipses(CmodelFit2,SmodelFit2,ax2);

title(ax1,'FULL GROUP')
title(ax2,'SPEED MATCHED')

set(ax1,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[-0.05 1],'YTick',[0 0.25 0.5 0.75 1])
set(ax2,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[-0.05 1],'YTick',[0 0.25 0.5 0.75 1])
