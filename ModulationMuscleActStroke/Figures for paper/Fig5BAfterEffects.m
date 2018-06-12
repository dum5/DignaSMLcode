%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

Idx=[1:4 6:15]';%exclude pt 5, since there was a loose sensor
%t=t(t.SpeedMatch==1,:);
%Idx=[1:2 4:9];

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

[p1,h1]=ranksum(TStroke.ePBMagn,TControl.ePBMagn);p1=round(p1,3);
if p1==0; p1='<0.01'; else; p1=['=',num2str(p1)]; end

f1=figure('Name','After Effects');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 3 10]);

ax2 = axes('Position',[0.22   0.6   0.7 0.33],'FontSize',12);%Between group comparison
ax8 = axes('Position',[0.22   0.2   0.7 0.33],'FontSize',12);%Correlation with FM



hold(ax2)
bar(ax2,1,nanmean(TControl.ePBMagn),'BarWidth',0.3,'FaceColor',[0.4 0.7 0.7]);
errorbar(ax2,1,nanmean(TControl.ePBMagn),nanstd(TControl.ePBMagn)./sqrt(size(TControl,1)),'LineWidth',2,'Color','k')
bar(ax2,2,nanmean(TStroke.ePBMagn(Idx)),'BarWidth',0.3,'FaceColor',[0.9 0.5 0.9]);
errorbar(ax2,2,nanmean(TStroke.ePBMagn(Idx)),nanstd(TStroke.ePBMagn(Idx))./sqrt(size(Idx,1)),'LineWidth',2,'Color','k')
%plot(ax2,0.95,TControl.BM,'.k','MarkerSize',7)
%plot(ax2,1.95,TStroke.BM,'.k','MarkerSize',7)
set(ax2,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},...
    'YLim',[0 17.5],'YTick',[0 5 10 15],'FontSize',14,'FontWeight','Bold');
ylabel(ax2,'Magnitude eP_B')
txt1=text(ax2,0.5,18,'After effect magnitude','FontSize',14,'FontWeight','bold','Clipping','off');


hold(ax8)
plot(ax8,(TControl.vel),TControl.ePBMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax8,(TStroke.vel(Idx)),TStroke.ePBMagn(Idx),'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControl.vel),TControl.ePBMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.vel(Idx)),TStroke.ePBMagn(Idx)],'Type','Spearman');
tc=text(ax8,0,40,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax8,0,37.5,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
if pc(2)<0.05
    [r,slope,intercept] = regression(TControl.vel,TControl.ePBMagn,'one');
    x=get(ax8,'XLim');
    pred=intercept+slope.*x;
    plot(ax8,x,pred,'LineWidth',2','Color',[0.4 0.7 0.7])
    clear r slope intercept x pred
end
if ps(2)<0.05
    [r,slope,intercept] = regression(TStroke.vel(Idx),TStroke.ePBMagn(Idx),'one');
    x=get(ax8,'XLim');
    pred=intercept+slope.*x;
    plot(ax8,x,pred,'LineWidth',2','Color',[0.9 0.5 0.9])
    clear r slope intercept x pred
end
ylabel(ax8,'Magnitude eP_B')
xlabel(ax8,'Velocity (m/s)')
set(ax8,'FontSize',14,'FontWeight','Bold','XLim',[0 1.2],'YLim',[0 40]);
clear rhoc pc rhos ps tc ts
ll=findobj(ax8,'Type','Line');
legend(ax8,ll(end:-1:1),{'CONTROL','STROKE'},'box','off')


% plot(ax3,TStroke.FM,TStroke.BM,'ok','MarkerFaceColor',[0.9 0.5 0.9])
% xdata=[TStroke.FM];
% ydata=[TStroke.BM];
% ll=findobj(ax3,'Type','Line');
% [r,m,b] = regression(xdata,ydata,'one');
% r=num2str(round(r,2));
% rfit=b+xdata.*m;
% plot(ax3,xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
% legend(ax3,ll,{'STROKE'},'box','off', 'Position',[0.506 0.38 0.42 0.08])
% set(ax3,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[0 1],'YTick',[0 0.5 1],'FontSize',14,'FontWeight','Bold');
% ylabel(ax3,'\betaM')
% xlabel(ax3,'FUGL-MEYER')
% tx=text(ax3,-0.3, 18,['r=',r,',p=0.75']);set(tx,'FontSize',14)



