clear all
close all

[file, path]=uigetfile('.mat','Select data file of interest');
load([path,file]);
groups=fieldnames(studyData);

%% Get Data
%baseline
cdata_bas=getAvgGroupedData(studyData.Controls,{'skneeAngleAtSHS'},{'TM base'},0,90,5,5);
sdata_bas=getAvgGroupedData(studyData.Stroke,{'skneeAngleAtSHS'},{'TM base'},0,90,5,5);

%adaptation
cdata_adapt=getAvgGroupedData(studyData.Controls,{'skneeAngleAtSHS'},{'Adaptation'},0,-40,0,5);
sdata_adapt=getAvgGroupedData(studyData.Stroke,{'skneeAngleAtSHS'},{'Adaptation'},0,-40,0,5);

cdata_diff=cdata_adapt-cdata_bas;
sdata_diff=sdata_adapt-sdata_bas;

[h,p]=ttest2(cdata_diff,sdata_diff);

figure
subplot(2,2,1)
hold on
x1=[0.75 1.75];
x2=[1.25 2.25];
bar1=bar(x1,[nanmean(cdata_bas) nanmean(cdata_adapt)],'FaceColor','g','BarWidth',0.3);
bar2=bar(x2,[nanmean(sdata_bas) nanmean(sdata_adapt)],'FaceColor','r','BarWidth',0.3);
legend('Controls','Stroke')
errorbar1=errorbar(x1,[nanmean(cdata_bas) nanmean(cdata_adapt)],[nanstd(cdata_bas) nanstd(cdata_adapt)],'LineStyle','none','LineWidth',2,'Color','k');
errorbar2=errorbar(x2,[nanmean(sdata_bas) nanmean(sdata_adapt)],[nanstd(sdata_bas) nanstd(sdata_adapt)],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'FontSize',20,'XTick',[1,2],'XTickLabel',{'TM base','Late adapt(40)'});title('Baseline and Late adapt');
ylabel('SlowKneeAng@SHS')
subplot(2,2,2)
hold on
bar3=bar([1,2], [nanmean(cdata_diff) nanmean(sdata_diff)],'FaceColor',[0.5 0.5 0.5],'BarWidth',0.3);
errorbar3=errorbar([1,2], [nanmean(cdata_diff) nanmean(sdata_diff)],[nanstd(cdata_diff) nanstd(sdata_diff)],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'FontSize',20,'XTick',[1,2],'XTickLabel',{'Controls','Stroke'})
ylabel('diff slow knee angle')
title('knee Angle late adapt-base')
