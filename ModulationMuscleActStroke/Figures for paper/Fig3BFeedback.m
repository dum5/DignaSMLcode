%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)


t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

[h,p]=ttest2(TStroke.BM,TControl.BM);
p=round(p,3);
if p==0
    p='<0.01';
else
    p=['=',num2str(p)];
end

f1=figure('Name','Feedforward responses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 3 10]);

ax2 = axes('Position',[0.22   0.5   0.7 0.33],'FontSize',12);%Between group comparison
ax3 = axes('Position',[0.22   0.1   0.7 0.33],'FontSize',12);%Correlation with FM


hold(ax2)
bar(ax2,1,nanmean(TControl.BM),'BarWidth',0.3,'FaceColor',[0.4 0.7 0.7]);
errorbar(ax2,1.05,nanmean(TControl.BM),nanstd(TControl.BM)./sqrt(15),'LineWidth',2,'Color','k')
bar(ax2,2,nanmean(TStroke.BM),'BarWidth',0.3,'FaceColor',[0.9 0.5 0.9]);
errorbar(ax2,2.05,nanmean(TStroke.BM),nanstd(TStroke.BM)./sqrt(15),'LineWidth',2,'Color','k')
plot(ax2,0.95,TControl.BM,'.k','MarkerSize',7)
plot(ax2,1.95,TStroke.BM,'.k','MarkerSize',7)
set(ax2,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},...
    'YLim',[0 1],'YTick',[0 .5 1],'FontSize',14,'FontWeight','Bold');
ylabel(ax2,'\betaM')
txt1=text(ax2,0.2,1.1,'FEEDBACK ADAPTATION','FontSize',14,'FontWeight','bold','Clipping','off');
txt2=text(ax2,0.7,1.3,'eP_l_A = \betaM . eA_B','FontSize',14,'FontWeight','bold');


hold(ax3)
plot(ax3,TStroke.FM,TStroke.BM,'ok','MarkerFaceColor',[0.9 0.5 0.9])
xdata=[TStroke.FM];
ydata=[TStroke.BM];
ll=findobj(ax3,'Type','Line');
[r,m,b] = regression(xdata,ydata,'one');
r=num2str(round(r,2));
rfit=b+xdata.*m;
plot(ax3,xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
legend(ax3,ll,{'STROKE'},'box','off', 'Position',[0.506 0.38 0.42 0.08])
set(ax3,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[0 1],'YTick',[0 0.5 1],'FontSize',14,'FontWeight','Bold');
ylabel(ax3,'\betaM')
xlabel(ax3,'FUGL-MEYER')
tx=text(ax3,-0.3, 18,['r=',r,',p=0.75']);set(tx,'FontSize',14)



