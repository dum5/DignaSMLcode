%Script to evaluate the regressions
%need to load the table with params
f2=figure;
ph=tight_subplot(2,2,[0.1 0.1],[0.1 0.1],[0.1 0.1]);

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

hold(ph(1,1))
bar(ph(1,1),1,nanmedian(TControl.R2),'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),1,nanmedian(TControl.R2),0,iqr(TControl.R2),'Color','k','LineWidth',2)
bar(ph(1,1),2,nanmedian(TStroke.R2),'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),2,nanmedian(TStroke.R2),0,iqr(TStroke.R2),'Color','k','LineWidth',2)
set(ph(1,1),'XLim',[0.5 2.5],'YLim',[0 1],'YTick',[0 0.25 .5 0.75 1],'YTickLabelMode','auto')
grid(ph(1,1),'on')



hold(ph(1,2))
plot(ph(1,2),TControl.vel,TControl.R2,'ok','MarkerFaceColor',[1 1 1])
plot(ph(1,2),TStroke.vel,TStroke.R2,'ok','MarkerFaceColor',[0 0 0])
xdata=[TControl.vel;TStroke.vel];
ydata=[TControl.R2;TStroke.R2];
xdata=xdata(~isnan(ydata));
ydata=ydata(~isnan(ydata));
[rho,pval]=corr([xdata ydata],'type', 'Spearman');
[r,m,b] = regression(xdata,ydata,'one');
r=num2str(round(r,2));
rfit=b+xdata.*m;
plot(ph(1,2),xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
tx=text(ph(1,2),-0.3, 0.8,['rho=',num2str(round(rho(2),2)),' p=',num2str(round(pval(2),2))]);

clear TStroke TControl
t=t(t.SpeedMatch==1,:);

TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

 
% 
% bar(ph(2,1),3.5,nanmedian(TControl.BM),'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
% errorbar(ph(2,1),3.5,nanmedian(TControl.BM),0,iqr(TControl.BM),'Color','k','LineWidth',2)
% bar(ph(2,1),4.5,nanmedian(TStroke.BM),'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
% errorbar(ph(2,1),4.5,nanmedian(TStroke.BM),0,iqr(TStroke.BM),'Color','k','LineWidth',2)