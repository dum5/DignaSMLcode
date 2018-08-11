clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)
% 
% writePath=uigetdir;
% dt=datestr(datetime('now'));
% dt(find(dt==':'))='-';
% diary([writePath,'\',dt]);

figure



%predict BM for stroke group only
Tstroke=tALL(tALL.group=='stroke',:);
Tcontrols=tALL(tALL.group=='control',:);
dependent='BM';

fitlm(Tstroke,'BM~age*FM')
fitlm(Tstroke,'BM~age*FM','RobustOpts',true)
fitlm(Tstroke,'BM~age+FM')
fitlm(Tstroke,'BM~age+FM','RobustOpts',true)
fitlm(Tstroke,'BM~vel*FM')
fitlm(Tstroke,'BM~vel*FM','RobustOpts',true)
fitlm(Tstroke,'BM~vel+FM')
fitlm(Tstroke,'BM~vel+FM','RobustOpts',true)
fitlm(Tstroke,'BM~age*vel')
fitlm(Tstroke,'BM~age*vel','RobustOpts',true)
fitlm(Tstroke,'BM~age+vel')
fitlm(Tstroke,'BM~age+vel','RobustOpts',true)
fitlm(Tstroke,'BM~vel')
fitlm(Tstroke,'BM~vel','RobustOpts',true)


subplot(2,3,1);
hold on
plot(Tstroke.age,Tstroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[r,m,b] = regression(Tstroke.age,Tstroke.BM,'one');
xdata=get(gca,'XLim');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.9 0.5 0.9])
xlabel('age (months)');ylabel('\beta_M')
set(gca,'FontSize',10)

subplot(2,3,2);
hold on
plot(Tstroke.FM,Tstroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[r,m,b] = regression(Tstroke.FM,Tstroke.BM,'one');
xdata=get(gca,'XLim');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.9 0.5 0.9])
xlabel('FM');ylabel('\beta_M')
set(gca,'FontSize',10)

subplot(2,3,3);
hold on
plot(Tstroke.vel,Tstroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
[r,m,b] = regression(Tstroke.vel,Tstroke.BM,'one');
xdata=get(gca,'XLim');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.9 0.5 0.9])
xlabel('velocity');ylabel('\beta_M')
set(gca,'FontSize',10)

%predict BM for group as a whole
fitlm(tALL,'BM~group+age')
fitlm(tALL,'BM~group+age','RobustOpts',true)
fitlm(tALL,'BM~group*age')
fitlm(tALL,'BM~group*age','RobustOpts',true)
fitlm(tALL,'BM~group+vel')
fitlm(tALL,'BM~group+vel','RobustOpts',true)
fitlm(tALL,'BM~group*vel')
fitlm(tALL,'BM~group*vel','RobustOpts',true)
fitlm(tALL,'BM~group+age+vel')
fitlm(tALL,'BM~group+age+vel','RobustOpts',true)


LinearModel.fit(tALL,'PredictorVars',{'group','age','FM'},'ResponseVar',dependent)
LinearModel.fit(tALL,'PredictorVars',{'group','FM'},'ResponseVar',dependent)
LinearModel.fit(tALL,'PredictorVars',{'group','age'},'ResponseVar',dependent)
LinearModel.fit(tALL,'PredictorVars',{'vel','age','group'},'ResponseVar',dependent)

subplot(2,3,4);
hold on
plot(Tstroke.age,Tstroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
plot(Tcontrols.age,Tcontrols.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
xdata=get(gca,'XLim');
[r,m,b] = regression(Tstroke.age,Tstroke.BM,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.9 0.5 0.9])
[r,m,b] = regression(Tcontrols.age,Tcontrols.BM,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.4 0.7 0.7])
xlabel('age (months)');ylabel('\beta_M')
set(gca,'FontSize',10)


subplot(2,3,5);
hold on
plot(Tstroke.vel,Tstroke.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.9 0.5 0.9])
plot(Tcontrols.vel,Tcontrols.BM,'ok','MarkerSize',8,'MarkerFaceColor',[0.4 0.7 0.7])
xdata=get(gca,'XLim');
[r,m,b] = regression(Tstroke.vel,Tstroke.BM,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.9 0.5 0.9])
[r,m,b] = regression(Tcontrols.vel,Tcontrols.BM,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.4 0.7 0.7])
xlabel('vel');ylabel('\beta_M')
ll=findobj(gca,'Type','line');
legend(ll(1:2),{'controls','stroke'});
set(gca,'FontSize',10)