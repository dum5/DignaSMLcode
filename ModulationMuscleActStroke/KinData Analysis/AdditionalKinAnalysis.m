%% Group assessments
clear all
close all
clc

matfilespath='Z:\SubjectData\E01 Synergies\mat\HPF30\';


strokesFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007

load ([matfilespath,'groupedParams30HzPT11Fixed.mat']);

%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);
% 
% Unbiasedgroups{1}=groups{1}.removeBias;
% Unbiasedgroups{2}=groups{2}.removeBias;

eE=1;
eL=5;

params={'alphaSlow','alphaFast','XSlow','XFast'};
params={'alphaAngSlow','alphaAngFast','betaAngSlow','betaAngFast'}

[epLA] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
[epEA] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmedian');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');

%getEpochData(this,epochs,labels,padWithNaNFlag)

LA.controls=transpose(squeeze(groups{1}.getEpochData(epLA,params,1)));
LA.stroke=transpose(squeeze(groups{2}.getEpochData(epLA,params,1)));
EA.controls=transpose(squeeze(groups{1}.getEpochData(epEA,params,1)));
EA.stroke=transpose(squeeze(groups{2}.getEpochData(epEA,params,1)));
ref.controls=transpose(squeeze(groups{1}.getEpochData(reps,params,1)));
ref.stroke=transpose(squeeze(groups{2}.getEpochData(reps,params,1)));
uLA.controls=LA.controls-ref.controls;
uLA.stroke=LA.stroke-ref.stroke;
uEA.controls=EA.controls-ref.controls;
uEA.stroke=EA.stroke-ref.stroke;
u2LA.controls=(uLA.controls./ref.controls)*100;
u2LA.stroke=(uLA.stroke./ref.stroke)*100;
u2EA.controls=(uEA.controls./ref.controls)*100;
u2EA.stroke=(uEA.stroke./ref.stroke)*100;


figure
xc=[1 4];
xs=xc+1;
subplot(3,2,1)
title('Base')
hold on
bar(xc,nanmean(ref.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(ref.controls(:,1:2)),nanstd(ref.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(ref.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(ref.stroke(:,1:2)),nanstd(ref.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,2)
title('Base')
hold on
bar(xc,nanmean(ref.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(ref.controls(:,3:4)),nanstd(ref.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(ref.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(ref.stroke(:,3:4)),nanstd(ref.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)

subplot(3,2,3)
title('eA')
hold on
bar(xc,nanmean(EA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(EA.controls(:,1:2)),nanstd(EA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(EA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(EA.stroke(:,1:2)),nanstd(EA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,4)
title('eA')
hold on
bar(xc,nanmean(EA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(EA.controls(:,3:4)),nanstd(EA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(EA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(EA.stroke(:,3:4)),nanstd(EA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)

subplot(3,2,5)
title('lA')
hold on
bar(xc,nanmean(LA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(LA.controls(:,1:2)),nanstd(LA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(LA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(LA.stroke(:,1:2)),nanstd(LA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,6)
title('lA')
hold on
bar(xc,nanmean(LA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(LA.controls(:,3:4)),nanstd(LA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(LA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(LA.stroke(:,3:4)),nanstd(LA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)



figure
xc=[1 4];
xs=xc+1;
subplot(3,2,1)
title('eA-Base')
hold on
bar(xc,nanmean(uEA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(uEA.controls(:,1:2)),nanstd(uEA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(uEA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(uEA.stroke(:,1:2)),nanstd(uEA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,2)
title('eA-Base')
hold on
bar(xc,nanmean(uEA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(uEA.controls(:,3:4)),nanstd(uEA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(uEA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(uEA.stroke(:,3:4)),nanstd(uEA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)


subplot(3,2,3)
title('lA-Base')
hold on
bar(xc,nanmean(uLA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(uLA.controls(:,1:2)),nanstd(uLA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(uLA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(uLA.stroke(:,1:2)),nanstd(uLA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,4)
title('lA-Base')
hold on
bar(xc,nanmean(uLA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(uLA.controls(:,3:4)),nanstd(uLA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(uLA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(uLA.stroke(:,3:4)),nanstd(uLA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)



figure
xc=[1 4];
xs=xc+1;
subplot(3,2,1)
title('eA-Base')
hold on
bar(xc,nanmean(u2EA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(u2EA.controls(:,1:2)),nanstd(u2EA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(u2EA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(u2EA.stroke(:,1:2)),nanstd(u2EA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,2)
title('eA-Base')
hold on
bar(xc,nanmean(u2EA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(u2EA.controls(:,3:4)),nanstd(u2EA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(u2EA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(u2EA.stroke(:,3:4)),nanstd(u2EA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)


subplot(3,2,3)
title('lA-Base')
hold on
bar(xc,nanmean(u2LA.controls(:,1:2)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(u2LA.controls(:,1:2)),nanstd(u2LA.controls(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(u2LA.stroke(:,1:2)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(u2LA.stroke(:,1:2)),nanstd(u2LA.stroke(:,1:2)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'alhpaSlow','alphaFast'},'FontSize',16)

subplot(3,2,4)
title('lA-Base')
hold on
bar(xc,nanmean(u2LA.controls(:,3:4)),'FaceColor',[0.5 1 0],'BarWidth',0.3)
errorbar(xc,nanmean(u2LA.controls(:,3:4)),nanstd(u2LA.controls(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
bar(xs,nanmean(u2LA.stroke(:,3:4)),'FaceColor',[1 0 0],'BarWidth',0.3)
errorbar(xs,nanmean(u2LA.stroke(:,3:4)),nanstd(u2LA.stroke(:,3:4)),'LineWidth',2,'LineStyle','none','Color','k')
set(gca,'XTick',[1.5 4.5],'XTickLabel',{'XSlow','XFast'},'FontSize',16)

