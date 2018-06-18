%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

speedmatch=1;

if speedmatch==0
    Idx=[1:4 6:15]';%exclude pt 5, since there was a loose sensor
    
    BMControl=0.7259;
    BMStroke=0.7031;%patient 5 excluded, patient 3 included
    CIControl=[0.6670 7848];
    CIStroke=[0.6296 0.7766];%patient 5 excluded, patient 3 included
    
elseif speedmatch==1
    t=t(t.SpeedMatch==1,:);
    Idx=[1:2 4:9];
    
    BMControl=0.7202;
    BMStroke=0.5549;    
    CIControl=[0.6456 0.7947];
    CIStroke=[0.4695 0.6405];
end

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);




% [p1,h1]=ranksum(TStroke.BM(Idx),TControl.BM);p1=round(p1,3);
% if p1==0; p1='<0.01'; else; p1=['=',num2str(p1)]; end

[p2,h2]=ranksum(TStroke.eAMagn,TControl.eAMagn);p2=round(p2,3);
if p2==0; p2='<0.01'; else; p2=['=',num2str(p2)]; end

[p3,h3]=ranksum(TStroke.ePMagn(Idx),TControl.ePMagn);p3=round(p3,3);
if p3==0; p3='<0.01'; else; p3=['=',num2str(p3)]; end

f1=figure('Name','Feedforward responses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 3 10]);

ax2 = axes('Position',[0.22   0.5   0.7 0.33],'FontSize',12);%Between group comparison
ax3 = axes('Position',[0.22   0.1   0.7 0.33],'FontSize',12);%Correlation with FM


hold(ax2)
bar(ax2,1,BMControl,'BarWidth',0.3,'FaceColor',[0.4 0.7 0.7]);
bar(ax2,2,BMStroke,'BarWidth',0.3,'FaceColor',[0.9 0.5 0.9]);
errorbar(ax2,[1 2],[BMControl,BMStroke],[diff(CIControl)/2 diff(CIStroke)/2],'Color','k','LineStyle','none','LineWidth',2)
%plot(ax2,[1 1],CIControl,'LineWidth',2,'Color','k')
%plot(ax2,[2 2],CIStroke,'LineWidth',2,'Color','k')
if speedmatch==1
    plot(ax2,[1,2],[0.9 0.9],'k','LineWidth',2)
end
set(ax2,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'CONTROL','STROKE'},...
    'YLim',[0 1],'YTick',[0 .5 1],'FontSize',14,'FontWeight','Bold');
ylabel(ax2,'\betaM')
txt1=text(ax2,0.2,1.1,'FEEDBACK ADAPTATION','FontSize',14,'FontWeight','bold','Clipping','off');
txt2=text(ax2,0.7,1.3,'eP_l_A = \betaM . eA_B','FontSize',14,'FontWeight','bold');


hold(ax3)
bar(ax3,[1,4],[nanmean(TControl.eAMagn) nanmean(TControl.ePMagn)],'BarWidth',0.3,'FaceColor',[0.4 0.7 0.7])
errorbar(ax3,[1,4],[nanmean(TControl.eAMagn) nanmean(TControl.ePMagn)],[nanstd(TControl.eAMagn) nanstd(TControl.ePMagn)]./sqrt(size(TControl,1)),...
    'LineStyle','none','LineWidth',2,'Color','k')
bar(ax3,[2,5],[nanmean(TStroke.eAMagn) nanmean(TStroke.ePMagn(Idx))],'BarWidth',0.3,'FaceColor',[0.9 0.5 0.9])
errorbar(ax3,[2,5],[nanmean(TStroke.eAMagn) nanmean(TStroke.ePMagn(Idx))],[nanstd(TStroke.eAMagn)./sqrt(size(TStroke,1)) nanstd(TStroke.ePMagn(Idx))./sqrt(size(Idx,1))],...
    'LineStyle','none','LineWidth',2,'Color','k')
set(ax3,'XLim',[0.5 5.5],'XTick',[1.5 4.5],'XTickLabel',{'eA_B','eP_l_A'},...
    'YLim',[0 15],'YTick',[0 5 10 15],'FontSize',14,'FontWeight','Bold');
ylabel(ax3,'Response magnitude')
ll=findobj(ax3,'Type','Bar');
h=legend(ax3,flipud(ll),{'CONTROL','STROKE'});
set(h,'EdgeColor','none');
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



