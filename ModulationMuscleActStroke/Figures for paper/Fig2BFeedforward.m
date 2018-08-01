%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

AddCombinedParamsToTable;

%t=t(t.SpeedMatch==1,:);

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

%[h,p]=ttest(TStroke.FF_skneeAngleAtSHS,TControl.FF_skneeAngleAtSHS);
[p,h]=ranksum(TStroke.FF_skneeAngleAtSHS,TControl.FF_skneeAngleAtSHS);
p=round(p,3);
if p==0
    p='<0.01';
else
    p=['=',num2str(p)];
end

f1=figure('Name','Feedforward responses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 4 6]);

ax2 = axes('Position',[0.2   0.6   0.35*1.5 0.35],'FontSize',12,'Clipping','off');%create axis for control checkerboard
ax3 = axes('Position',[0.2    0.15    0.35*1.5   0.35],'FontSize',12,'Clipping','off');%create axis for patient checkerboard

hold(ax2)
bar(ax2,1,nanmean(TControl.FF_skneeAngleAtSHS),'BarWidth',0.3,'FaceColor',[0.4 0.7 0.7]);
errorbar(ax2,1,nanmean(TControl.FF_skneeAngleAtSHS),nanstd(TControl.FF_skneeAngleAtSHS)./sqrt(size(TControl,1)),'LineWidth',2,'Color','k')
bar(ax2,2,nanmean(TStroke.FF_skneeAngleAtSHS),'BarWidth',0.3,'FaceColor',[0.9 0.5 0.9]);
errorbar(ax2,2,nanmean(TStroke.FF_skneeAngleAtSHS),nanstd(TStroke.FF_skneeAngleAtSHS)./sqrt(size(TStroke,1)),'LineWidth',2,'Color','k')
set(ax2,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},...
    'YLim',[-1 11],'YTick',[0 5 10],'FontSize',14,'FontWeight','Bold');
ylabel(ax2,'\Delta\theta sKnee lA-B')
plot(ax2,[1 2],[10 10],'Color','k','LineWidth',2)
tx=text(ax2,1.25, 10.7,['p',p]);set(tx,'FontSize',14)
title(ax2,'SLOW \thetaKNEE@SHS')

hold(ax3)
plot(ax3,TControl.FF_Quad,TControl.FF_skneeAngleAtSHS,'ok','MarkerFaceColor',[0.4 0.7 0.7])
plot(ax3,TStroke.FF_Quad,TStroke.FF_skneeAngleAtSHS,'ok','MarkerFaceColor',[0.9 0.5 0.9])
ll=findobj(ax3,'Type','Line');
xdata=[TControl.FF_Quad;TStroke.FF_Quad];
ydata=[TControl.FF_skneeAngleAtSHS;TStroke.FF_skneeAngleAtSHS];
[rho,pval]=corr([xdata ydata],'type', 'Spearman');
[r,m,b] = regression(xdata,ydata,'one');
r=num2str(round(r,2));
rfit=b+xdata.*m;
plot(ax3,xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
legend(ax3,ll(end:-1:1),{'CONTROL','STROKE'},'box','off', 'Position',[0.6 0.45 0.35 0.08])
set(ax3,'XLim',[-0.3 0.8],'YLim',[-10 20],'YTick',[-10 0 20],'FontSize',14,'FontWeight','Bold');
ylabel(ax3,'\Delta\theta sKnee lA-B')
xlabel(ax3,'Quad Activity lA-B')
tx=text(ax3,-0.3, 18,['rho=',num2str(round(rho(2),2)),',p<0.01']);set(tx,'FontSize',14)


