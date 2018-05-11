clear all
close all


matfilespath='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Data\';

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, plus it has

load ([matfilespath,'groupedParams30Hz.mat']);


[eps] = defineEpochs({'eA','lA','eP'},{'Adaptation','Adaptation','Washout'}',[15 -40 15],[0],[0],'nansum');

StrokeHolding=transpose(squeeze(patients.getEpochData(eps,'HandrailHolding',true)));
ControlHolding=transpose(squeeze(controls.getEpochData(eps,'HandrailHolding',true)));

figure
subplot(1,2,1)
hold on
xc=[1 4 7];
xp=[2 5 8];
bar1=bar(xc,nanmean(ControlHolding),'FaceColor',[0.6 1 0.6],'BarWidth',0.3);
bar2=bar(xp,nanmean(StrokeHolding),'FaceColor',[1 0.4 0.4],'BarWidth',0.3);
l1=errorbar(xc,nanmean(ControlHolding),nanstd(ControlHolding),'LineWidth',2,'LineStyle','none','Color','k');
l2=errorbar(xp,nanmean(StrokeHolding),nanstd(StrokeHolding),'LineWidth',2,'LineStyle','none','Color','k');
plot(xc+0.2,ControlHolding,'ok');
plot(xp+0.2,StrokeHolding,'ok');
set(gca,'XTick',[1.5 4.5 7.5],'XTickLabel',{'eA(15)','lA(40','ep(15)'},'FontSize',20,'XLim',[0.5 8.5])
title('number of strides holding on in epochs of interest')
grid on