clear all
close all
clc

load('vectorSimFull.mat')
load('vectorSimSpM.mat')

f1=figure('Name','Structure Bars');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 6]);

subplot(2,3,1)
hold on
[aa]=plotCosines(BdataFull.lAs);
title('FULL GROUP')
ylabel('PAR/NON-DOM')


subplot(2,3,4)
hold on
[aa]=plotCosines(BdataFull.lAf);
ylabel('NON-PAR/DOM')
text(gca,-0.5,0,'Cos(\DeltaEMG_(_+_)_G_R_O_U_P vs. \DeltaEMG_(_+_)_I_N_D)','Rotation',90,'FontSize',12)

subplot(2,3,2)
hold on
[aa]=plotCosines(BdataSpM.lAs);
title('SPEED MATCH')

subplot(2,3,5)
hold on
[aa]=plotCosines(BdataSpM.lAf);

function [aa]=plotCosines(Data);
aa=[];
bar(1,nanmedian(Data(:,1)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hs=bar(2,nanmedian(Data(:,2)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hatchfill2(hs);
errorbar(1,nanmedian(Data(:,1)),iqr(Data(:,1)),'Color',[0 0 0],'LineWidth',2);
errorbar(2,nanmedian(Data(:,2)),iqr(Data(:,2)),'Color',[0 0 0],'LineWidth',2);
plot(1,Data(:,1),'ok');
plot(2,Data(:,2),'ok');
[p,h]=ranksum(Data(:,1),Data(:,2));
yl=get(gca,'YLim');
text(0.5,yl(2),['p= ',num2str(round(p,3))],'FontSize',6);
set(gca,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',8)
end


% 
% %plot([refcosine refcosine],[0 600],'Color','g','LineWidth',2)
% ylabel('number of observations')
% xlabel('cosine between vectors')
% legend({'ControlCosine','DistControl','StrokeCosine','DistStroke','strokeControl14'})
