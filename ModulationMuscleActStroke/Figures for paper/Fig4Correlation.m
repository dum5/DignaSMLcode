clear all
close all

load IndRegressions

T=IndRegressions(15:28,:);

f1=figure('Name','Ellipses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 3]);
ax1 = axes(f1,'Position',[0.08   0.14   1.1*0.35  1.1*0.7],'FontSize',8);
ax2 = axes(f1,'Position',[0.58   0.14   1.1*0.35  1.1*0.7],'FontSize',8);

plot(ax1,T.FM,T.BA,'.k','MarkerSize',20)
title(ax1,'ADAPTIVE')
ylabel(ax1,'\beta_a_d_a_p_t')
xlabel(ax1,'Fugl Meyer')
set(ax1,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 0.7],'YTick',[0 0.2 0.4 0.6],'Box','off')
[rho1,pval1] = corr(T.BA,T.FM,'Type','Spearman');
text(ax1,21, 0.6,['rho = ',num2str(round(rho1,2)),' p = ',num2str(round(pval1,3))],'FontSize',8);
dt=[T.BA-T.longCI T.BA+T.longCI];
hold(ax1)
for sj=1:length(T.BA)
    plot(ax1,[T.FM(sj) T.FM(sj)],dt(sj,:),'-k','Color',[0.5 0.5 0.5]);
end
clear dt

plot(ax2,T.FM,T.BE,'.k','MarkerSize',20)
title(ax2,'NON-ADAPTIVE')
ylabel(ax2,'\beta_n_o_n_-_a_d_a_p')
xlabel(ax2,'Fugl Meyer')
set(ax2,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 0.7],'YTick',[0 0.2 0.4 0.6],'Box','off')
[rho2,pval2] = corr(T.BE,T.FM,'Type','Spearman');
text(ax2,21, 0.6,['rho = ',num2str(round(rho2,2)),' p = ',num2str(round(pval2,3))],'FontSize',8);
l=lsline;
hold(ax2)
dt=[T.BE-T.longCI T.BE+T.longCI];
for sj=1:length(T.BE)
    plot(ax2,[T.FM(sj) T.FM(sj)],dt(sj,:),'-k','Color',[0.5 0.5 0.5]);
end


f2=figure('Name','Ellipses');
set(f2,'Color',[1 1 1]','Units','inches','Position',[0 0 6 3]);
ax1 = axes(f2,'Position',[0.08   0.14   1.1*0.35  1.1*0.7],'FontSize',8);
ax2 = axes(f2,'Position',[0.58   0.14   1.1*0.35  1.1*0.7],'FontSize',8);

T2=IndRegressions([15,16,18:28],:);

plot(ax1,T2.FM,T2.BE,'.k','MarkerSize',20)
title(ax1,'ADAPTIVE')
ylabel(ax1,'\beta_no_a_d_a_p_t')
xlabel(ax1,'Fugl Meyer')
set(ax1,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 0.7],'YTick',[0 0.2 0.4 0.6],'Box','off')
[rho1,pval1] = corr(T2.BE,T2.FM,'Type','Spearman');
text(ax1,21, 0.6,['rho = ',num2str(round(rho1,2)),' p = ',num2str(round(pval1,3))],'FontSize',8);

plot(ax2,T.FM,abs(T.BE),'.k','MarkerSize',20)
title(ax2,'NON-ADAPTIVE')
ylabel(ax2,'\beta_n_o_n_-_a_d_a_p')
xlabel(ax2,'Fugl Meyer')
set(ax2,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 0.7],'YTick',[0 0.2 0.4 0.6],'Box','off')
[rho2,pval2] = corr(abs(T.BE),T.FM,'Type','Spearman');
text(ax2,21, 0.6,['rho = ',num2str(round(rho2,2)),' p = ',num2str(round(pval2,3))],'FontSize',8);
l=lsline;

T3=T([1:8,10:14],:);

f3=figure('Name','Ellipses');
set(f3,'Color',[1 1 1]','Units','inches','Position',[0 0 6 3]);
ax1 = axes(f3,'Position',[0.08   0.14   1.1*0.35  1.1*0.7],'FontSize',8);
ax2 = axes(f3,'Position',[0.58   0.14   1.1*0.35  1.1*0.7],'FontSize',8);

plot(ax1,T3.FM,T3.sBA,'.k','MarkerSize',20)
title(ax1,'ADAPTIVE')
ylabel(ax1,'\beta_a_d_a_p_t')
xlabel(ax1,'Fugl Meyer')
set(ax1,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 1],'YTick',[0 0.2 0.4 0.6 0.8 1],'Box','off')
[rho1,pval1] = corr(T3.sBA,T3.FM,'Type','Spearman');
text(ax1,21, 0.6,['rho = ',num2str(round(rho1,2)),' p = ',num2str(round(pval1,3))],'FontSize',8);

plot(ax2,T3.FM,T3.sBE,'.k','MarkerSize',20)
title(ax2,'NON-ADAPTIVE')
ylabel(ax2,'\beta_n_o_n_-_a_d_a_p')
xlabel(ax2,'Fugl Meyer')
set(ax2,'XLim',[20 35],'XTick',[20 25 30 35],'YLim',[-Inf 1],'YTick',[0 0.2 0.4 0.6, 0.8 1],'Box','off')
[rho2,pval2] = corr(T3.sBE,T3.FM,'Type','Spearman');
text(ax2,21, 0.6,['rho = ',num2str(round(rho2,2)),' p = ',num2str(round(pval2,3))],'FontSize',8);



