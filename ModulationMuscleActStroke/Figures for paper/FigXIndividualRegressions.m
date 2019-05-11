clear all
close all

load IndividualRegressions
TStroke=IndRegressions(15:28,:);
TControl=IndRegressions(1:14,:);

f1=figure('Name','Individual regressors');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 6]);
ax1 = axes(f1,'Position',[0.11   0.55   0.35  0.35],'FontSize',8);%full group slow
ax2 = axes(f1,'Position',[0.58   0.55   0.35  0.35],'FontSize',8);%speed matched slow
ax3 = axes(f1,'Position',[0.11   0.08   0.35  0.35],'FontSize',8);%full group fast
ax4 = axes(f1,'Position',[0.58   0.08   0.35  0.35],'FontSize',8);%speed matched fast

a=plotCor(ax1,TStroke.age,TStroke.sBElong,TControl.age,TControl.sBElong,[0.93 0.69 0.13]);
a=plotCor(ax2,TStroke.age,TStroke.sBAlong,TControl.age,TControl.sBAlong,[0.49 0.18 0.56]);
a=plotCor(ax3,TStroke.age,TStroke.fBElong,TControl.age,TControl.fBElong,[0.93 0.69 0.13]);
l=legend(ax2,{'Controls','Stroke'},'box','off')
a=plotCor(ax4,TStroke.age,TStroke.fBAlong,TControl.age,TControl.fBAlong,[0.49 0.18 0.56]);

xlabel(ax3,'Age');xlabel(ax4,'Age')
ylabel(ax1,'\beta_n_o_n_-_a_d_a_p_t');ylabel(ax3,'\beta_n_o_n_-_a_d_a_p_t')
ylabel(ax2,'\beta_a_d_a_p_t');ylabel(ax4,'\beta_a_d_a_p_t')
set(ax1,'XTickLabel',{''});
set(ax2,'XTickLabel',{''});

text(ax1,30,0.-0.3,'SLOW/PARETIC','Rotation',90,'Color',[0.85 0.325 0.098])
text(ax3,30,-0.3,'FAST/NON-PARETIC','Rotation',90,'Color',[0.466 0.674 0.188])
title(ax1,'\beta_n_o_n_-_a_d_a_p_t')
title(ax2,'\beta_a_d_a_p_t')


function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC,color)
hold(ax)
a=[];
yl=get(ax,'YLim');
xl=get(ax,'XLim');
if nargin>3
   % yDataC=yDataC(find(~isnan(xDataC)));
   % xDataC=xDataC(find(~isnan(xDataC)));
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',color,'LineWidth',2)
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    tc=text(ax,40,0.4,['CON: rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',color,'FontSize',8,'FontWeight','bold')
    if pc(2)<0.05
    [r,slope,intercept] = regression(xDataC,yDataC,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2','Color',[0.7 0.7 0.7])
    clear r slope intercept x pred
    end
end
plot(ax,xDataS,yDataS,'ok','MarkerFaceColor',color,'MarkerEdgeColor',color,'LineWidth',2)
[rhos,ps]=corr([xDataS,yDataS],'Type','Spearman');
ts=text(ax,40,0.5,['ST: rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',color,'FontSize',8,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end


end
