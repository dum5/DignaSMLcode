clear all
close all
%% read data
[loadName,matDataDir]=uigetfile('*.mat');
%%
loadName=[matDataDir,loadName]; 
load(loadName)
t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControls=t(t.group=='Control',:);

x1=0.0906;x2=0.4005;x3=0.7104;
y1=0.7104;y2=0.4146;y3=0.1188;

f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 10 10]);

ax1 = axes('Position',[x1 y1 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[-0.2 1],'YTick',[0 0.5 1],'XLim',[40 80],'XTick',[40 60 80]);
ax2 = axes('Position',[x2 y1 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[-0.2 1],'YTick',[0 0.5 1],'XLim',[0 1.5],'XTick',[0 0.5 1 1.5]);
ax3 = axes('Position',[x3 y1  0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[-0.2 1],'YTick',[0 0.5 1],'XLim',[20 35],'XTick',[20 25 30 35]);

ax4 = axes('Position',[x1 y2 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 20],'YTick',[0 5 10 15 20],'XLim',[40 80],'XTick',[40 60 80]);
ax5 = axes('Position',[x2 y2 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 20],'YTick',[0 5 10 15 20],'XLim',[0 1.5],'XTick',[0 0.5 1 1.5]);
ax6 = axes('Position',[x3 y2 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 20],'YTick',[0 5 10 15 20],'XLim',[20 35],'XTick',[20 25 30 35]);

ax7 = axes('Position',[x1 y3 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 35],'YTick',[0 10 20 30],'XLim',[40 80],'XTick',[40 60 80]);
ax8 = axes('Position',[x2 y3 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 35],'YTick',[0 10 20 30],'XLim',[0 1.5],'XTick',[0 0.5 1 1.5]);
ax9 = axes('Position',[x3 y3 0.2365 0.2365],'FontSize',14,'FontWeight','Bold','Box','off','YLim',[0 35],'YTick',[0 10 20 30],'XLim',[20 35],'XTick',[20 25 30 35]);

hold(ax1)
plot(ax1,(TControls.age)./12,TControls.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax1,(TStroke.age)./12,TStroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.age)./12,TControls.BM],'Type','Spearman');
[rhos,ps]=corr([(TStroke.age)./12,TStroke.BM],'Type','Spearman');
tc=text(ax1,60,1,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax1,60,0.9,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
ylabel(ax1,'\beta_M');title(ax1,'Age');
set(ax1,'XTickLabel',{''});
clear rhoc pc rhos ps tc ts

hold(ax2)
plot(ax2,(TControls.vel),TControls.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax2,(TStroke.vel),TStroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.vel),TControls.BM],'Type','Spearman');
[rhos,ps]=corr([(TStroke.vel),TStroke.BM],'Type','Spearman');
tc=text(ax2,0,1,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax2,0,0.9,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
title(ax2,'Velocity');
set(ax2,'XTickLabel',{''},'YTickLabel',{''});
clear rhoc pc rhos ps tc ts

hold(ax3)
%plot(ax3,(TControls.FM),TControls.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax3,(TStroke.FM),TStroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
%[rhoc,pc]=corr([(TControls.FM),TControls.BM],'Type','Spearman');
[rhos,ps]=corr([(TStroke.FM),TStroke.BM],'Type','Spearman');
%tc=text(ax3,0,1,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax3,20,0.9,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
title(ax3,'Fugl-Meyer');
set(ax3,'XTickLabel',{''},'YTickLabel',{''});
clear rhoc pc rhos ps tc ts


hold(ax4)
plot(ax4,(TControls.age)./12,TControls.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax4,(TStroke.age)./12,TStroke.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.age)./12,TControls.eAMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.age)./12,TStroke.eAMagn],'Type','Spearman');
tc=text(ax4,60,20,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax4,60,18.5,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
ylabel(ax4,'Magnitude eA_B');
set(ax4,'XTickLabel',{''});
clear rhoc pc rhos ps tc ts

hold(ax5)
plot(ax5,(TControls.vel),TControls.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax5,(TStroke.vel),TStroke.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.vel),TControls.eAMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.vel),TStroke.eAMagn],'Type','Spearman');
tc=text(ax5,0,20,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax5,0,18.5,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
set(ax5,'XTickLabel',{''},'YTickLabel',{''});
clear rhoc pc rhos ps tc ts

hold(ax6)
%plot(ax6,(TControls.FM),TControls.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax6,(TStroke.FM),TStroke.eAMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
%[rhoc,pc]=corr([(TControls.FM),TControls.eAMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.FM),TStroke.eAMagn],'Type','Spearman');
%tc=text(ax6,0,1,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax6,20,18.5,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
set(ax6,'XTickLabel',{''},'YTickLabel',{''});
clear rhoc pc rhos ps tc ts


hold(ax7)
plot(ax7,(TControls.age)./12,TControls.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax7,(TStroke.age)./12,TStroke.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.age)./12,TControls.ePMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.age)./12,TStroke.ePMagn],'Type','Spearman');
tc=text(ax7,60,30,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax7,60,27.75,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
ylabel(ax7,'Magnitude eP_l_A');
clear rhoc pc rhos ps tc ts

hold(ax8)
plot(ax8,(TControls.vel),TControls.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax8,(TStroke.vel),TStroke.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[rhoc,pc]=corr([(TControls.vel),TControls.ePMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.vel),TStroke.ePMagn],'Type','Spearman');
tc=text(ax8,0,30,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax8,0,27.75,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
set(ax8,'YTickLabel',{''});
clear rhoc pc rhos ps tc ts

hold(ax9)
%plot(ax9,(TControls.FM),TControls.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
plot(ax9,(TStroke.FM),TStroke.ePMagn,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
%[rhoc,pc]=corr([(TControls.FM),TControls.ePMagn],'Type','Spearman');
[rhos,ps]=corr([(TStroke.FM),TStroke.ePMagn],'Type','Spearman');
%tc=text(ax9,0,1,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.4 0.7 0.7],'FontSize',12,'FontWeight','bold')
ts=text(ax9,20,27.75,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0.9 0.5 0.9],'FontSize',12,'FontWeight','bold')
set(ax9,'YTickLabel',{''});
clear rhoc pc rhos ps tc ts

