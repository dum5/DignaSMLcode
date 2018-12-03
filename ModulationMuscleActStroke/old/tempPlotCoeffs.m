clear all
close all

BMControlAll=0.7309;
BMStrokeAll=0.6864;

CIControlAll=[0.6833 0.7785];
CIStrokeAll=[0.6234 0.7495];

BMControlSpeedmatch=0.7771;
BMStrokeSpeedmatch=0.5336;

CIControlSpeedmatch=[0.7165 0.8378];
CIStrokeSpeedmatch=[0.4552 0.6121];

figure
subplot(2,2,1)
hold on
bar(1,BMControlAll,'FaceColor',[0.4 0.7 0.7],'Barwidth',0.3);
bar(2,BMStrokeAll,'FaceColor',[0.9 0.5 0.9],'Barwidth',0.3);
plot([1 1],CIControlAll,'LineWidth',2,'Color','k')
plot([2 2],CIStrokeAll,'LineWidth',2,'Color','k')
set(gca,'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',12,'XLim',[0.5 2.5]);
ylabel('\betaM')
title('All')

subplot(2,2,2)
hold on
bar(1,BMControlSpeedmatch,'FaceColor',[0.4 0.7 0.7],'Barwidth',0.3);
bar(2,BMStrokeSpeedmatch,'FaceColor',[0.9 0.5 0.9],'Barwidth',0.3);
plot([1 1],CIControlSpeedmatch,'LineWidth',2,'Color','k')
plot([2 2],CIStrokeSpeedmatch,'LineWidth',2,'Color','k')
set(gca,'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',12,'XLim',[0.5 2.5]);
ylabel('\betaM')
title('SpeedMatch')
