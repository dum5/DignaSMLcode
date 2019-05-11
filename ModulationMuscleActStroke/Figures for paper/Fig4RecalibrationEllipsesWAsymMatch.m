clear all
close all

col1=[0 0 0];
col2=[0.5 0.5 0.5];

f1=figure('Name','Ellipses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 6]);
ax1 = axes(f1,'Position',[0.11   0.55   0.35  0.35],'FontSize',8);%full group slow
ax2 = axes(f1,'Position',[0.58   0.55   0.35  0.35],'FontSize',8);%speed matched slow
ax3 = axes(f1,'Position',[0.11   0.08   0.35  0.35],'FontSize',8);%full group fast
ax4 = axes(f1,'Position',[0.58   0.08   0.35  0.35],'FontSize',8);%speed matched fast

load('FinalRegressionsFull')
hold(ax1)
%aa=CompareElipses(Cmodel1aSlow,Smodel1aSlow,col2,ax1)
aa=CompareElipses(Cmodel1bSlow,Smodel1bSlow,col1,ax1);
hold(ax3)
%aa=CompareElipses(Cmodel1aFast,Smodel1aFast,col2,ax3)
aa=CompareElipses(Cmodel1bFast,Smodel1bFast,col1,ax3);


clear Cmodel1aSlow Smodel1aSlow Cmodel1bSlow Smodel1bSlow Cmodel1aFast Smodel1aFast Cmodel1bFast Smodel1bFast


load('FinalRegressionsAsymmetryMatch')
hold(ax2)
%aa=CompareElipses(Cmodel1aSlow,Smodel1aSlow,col2,ax2);
aa=CompareElipses(Cmodel1bSlow,Smodel1bSlow,col1,ax2);
hold(ax4)
%aa=CompareElipses(Cmodel1aFast,Smodel1aFast,col2,ax4)
aa=CompareElipses(Cmodel1bFast,Smodel1bFast,col1,ax4);

ylabel(ax2,'');ylabel(ax4,'');xlabel(ax1,'');xlabel(ax2,'');

title(ax1,'FULL GROUP')
title(ax2,'ASYMMETRY MATCHED')

set(ax1,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[0 1],'YTick',[0 0.25 0.5 0.75 1],'XTickLabel','')
set(ax2,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[0 1],'YTick',[0 0.25 0.5 0.75 1],'XTickLabel','','YTickLabel','')
set(ax3,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[0 1],'YTick',[0 0.25 0.5 0.75 1])
set(ax4,'XLim',[0 1],'XTick',[0 0.25 0.5 0.75 1],'YLim',[0 1],'YTick',[0 0.25 0.5 0.75 1],'YTickLabel','')

text(ax1,-0.27,0.2,'SLOW/PARETIC','Rotation',90,'Color',[0.85 0.325 0.098])
text(ax3,-0.27,0.1,'FAST/NON-PARETIC','Rotation',90,'Color',[0.466 0.674 0.188])