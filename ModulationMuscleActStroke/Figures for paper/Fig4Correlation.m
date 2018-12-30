clear all
close all

load IndRegressions

T=IndRegressions(15:28,:);

f1=figure('Name','IndRegressions');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 3 3]);
ax1 = axes(f1,'Position',[0.15   0.15   0.7  0.7],'FontSize',8);%
plot(ax1,T.FM,T.BA,'.k','MarkerSize',20)
title('RECALIBRATION')
ylabel('\betaA')
xlabel('Fugl Meyer')
set(ax1,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 0.7],'YTick',[0 0.2 0.4 0.6],'Box','off')
[rho,pval] = corr(T.BA,T.FM,'Type','Spearman');
text(21, 0.6,['rho = ',num2str(round(rho,2)),' p = ',num2str(round(pval,3))],'FontSize',8);