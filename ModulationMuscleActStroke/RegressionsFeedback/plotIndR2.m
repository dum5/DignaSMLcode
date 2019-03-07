clear all
close all

load IndRegressions
figure
subplot(2,3,1);hold on;title('R^2 long exposure')
[aa]=plotCosines([IndRegressions.longR2(1:14) IndRegressions.longR2(15:28)]);
subplot(2,3,2);hold on;title('p \beta_N_O_-_A_D_A_P_T')
[aa]=plotPvals([IndRegressions.pBE(1:14) IndRegressions.pBE(15:28)]);
subplot(2,3,3);hold on;title('p \beta_A_D_A_P_T')
[aa]=plotPvals([IndRegressions.pBA(1:14) IndRegressions.pBA(15:28)]);

subplot(2,3,4);hold on;title('R^2 short exposure')
[aa]=plotCosines([IndRegressions.shortR2(1:14) IndRegressions.shortR2(15:28)]);
subplot(2,3,5);hold on;title('p \beta_N_O_-_A_D_A_P_T')
[aa]=plotPvals([IndRegressions.short_pBE(1:14) IndRegressions.short_pBE(15:28)]);
subplot(2,3,6);hold on;title('p \beta_A_D_A_P_T')
[aa]=plotPvals([IndRegressions.short_pBA(1:14) IndRegressions.short_pBA(15:28)]);

figure
cInds=1:14;sInds=15:28;
subplot(2,2,1)
a=plotCor(gca,IndRegressions.pBE(sInds),abs(IndRegressions.BE(sInds)),IndRegressions.pBE(cInds),abs(IndRegressions.BE(cInds)));
title('\beta_N_O_-_A_D_A_P Long');
subplot(2,2,2)
a=plotCor(gca,IndRegressions.pBA(sInds),abs(IndRegressions.BA(sInds)),IndRegressions.pBA(cInds),abs(IndRegressions.BA(cInds)));
title('\beta_A_D_A_P Long');
subplot(2,2,3)
a=plotCor(gca,IndRegressions.short_pBE(sInds),abs(IndRegressions.sBE(sInds)),IndRegressions.short_pBE(cInds),abs(IndRegressions.sBE(cInds)));
title('\beta_N_O_-_A_D_A_P Short');
subplot(2,2,4)
a=plotCor(gca,IndRegressions.short_pBA(sInds),abs(IndRegressions.sBA(sInds)),IndRegressions.short_pBA(cInds),abs(IndRegressions.sBA(cInds)));
title('\beta_A_D_A_P Short');


%name
function [aa]=plotCosines(Data);
aa=[];
bar(1,nanmedian(Data(:,1)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hs=bar(2,nanmedian(Data(:,2)),'Facecolor',[0.5 0.5 0.5 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
%hatchfill2(hs);
errorbar(1,nanmedian(Data(:,1)),iqr(Data(:,1)),'Color',[0 0 0],'LineWidth',2);
errorbar(2,nanmedian(Data(:,2)),iqr(Data(:,2)),'Color',[0 0 0],'LineWidth',2);
plot(1,Data(:,1),'ok');
plot(2,Data(:,2),'ok');
set(gca,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',14,'FontWeight','bold')
[p,h]=ranksum(Data(:,1),Data(:,2));
yl=get(gca,'YLim');
text(0.5,yl(2),['p= ',num2str(round(p,3))],'FontSize',14);



end

function [aa]=plotPvals(Data);
aa=[];
bar(1,nanmedian(Data(:,1)),'Facecolor',[1 1 1 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
hs=bar(2,nanmedian(Data(:,2)),'Facecolor',[0.5 0.5 0.5 ],'EdgeColor',[0 0 0],'LineWidth',2,'BarWidth',0.6);
%hatchfill2(hs);
errorbar(1,nanmedian(Data(:,1)),iqr(Data(:,1)),'Color',[0 0 0],'LineWidth',2);
errorbar(2,nanmedian(Data(:,2)),iqr(Data(:,2)),'Color',[0 0 0],'LineWidth',2);
for d=1:size(Data,1)
    if Data(d,1)>0.05
        plot(1,Data(d,1),'or');
    else
        plot(1,Data(d,1),'ok');
    end
    
    if Data(d,2)>0.05
        plot(2,Data(d,2),'or');
    else
        plot(2,Data(d,2),'ok');
    end
end
set(gca,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'Control','Stroke'},'FontSize',14,'FontWeight','bold')
[p,h]=ranksum(Data(:,1),Data(:,2));
yl=get(gca,'YLim');
text(0.5,yl(2),['p= ',num2str(round(p,3))],'FontSize',14);

end

function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
hold(ax)
a=[];

if nargin>3
   % yDataC=yDataC(find(~isnan(xDataC)));
   % xDataC=xDataC(find(~isnan(xDataC)));
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    yl=get(ax,'YLim');
    xl=get(ax,'XLim');
  %  tc=text(ax,xl(1),yl(2)+3*diff(yl)/10,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
    if pc(2)<0.05
    [r,slope,intercept] = regression(xDataC,yDataC,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
  %  plot(ax,x,pred,'-k','LineWidth',2','Color',[0.7 0.7 0.7])
    clear r slope intercept x pred
    end
end
plot(ax,xDataS,yDataS,'ok','MarkerFaceColor',[0 0 0])
[rhos,ps]=corr([xDataS,yDataS],'Type','Spearman');
yl=get(ax,'YLim');
xl=get(ax,'XLim');
%ts=text(ax,xl(1),yl(2)+diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
  %  plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end
plot(ax,[0.05 0.05],[0  1],'--r')
xlabel('p-value');ylabel('\beta');

end
