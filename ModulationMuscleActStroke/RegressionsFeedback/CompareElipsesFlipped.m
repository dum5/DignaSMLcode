
clear all
%close all
clc

%load data
matDataDir='C:\Users\did35\OneDrive - University of Pittsburgh\Projects\Modulation of muscle activity in stroke\GroupData\';

load([matDataDir,'GroupMedianRegressionSpeedMatch'])   
Cmod=CmodelFit2;Smod=SmodelFit2;
load([matDataDir,'GroupMedianRegressionSpeedMatchFlipped'])    
Cmod2=CmodelFit2;Smod2=SmodelFit2;
gamma=5.991;

figure 
ax=subplot(1,1,1)
hold on

dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance))/gamma,Cmod.Coefficients.Estimate,ax);
%make sure that BM is on the y axis
if find(startsWith(Cmod.PredictorNames,'eAT'),1,'first')==2
    tempx=dt1.YData;tempy=dt1.XData;
    dt1.XData=tempx;dt1.YData=tempy;
end
%dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance./gamma)),Cmod.Coefficients.Estimate);
set(dt1,'Color',[0.47 0.47 0.19],'LineWidth',2)

dt1b=drawEllipse2D((inv(Cmod2.CoefficientCovariance))/gamma,Cmod2.Coefficients.Estimate,ax);
%make sure that BM is on the y axis
if find(startsWith(Cmod2.PredictorNames,'eAT'),1,'first')==2
    tempx=dt1b.YData;tempy=dt1b.XData;
    dt1b.XData=tempx;dt1b.YData=tempy;
end
%dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance./gamma)),Cmod.Coefficients.Estimate);
set(dt1b,'Color',[0.47 0.47 0.19],'LineWidth',2,'LineStyle','--')


dt2=drawEllipse2D((inv(Smod.CoefficientCovariance))/gamma,Smod.Coefficients.Estimate,ax);
%dt2=drawEllipse2D((inv(Smod.CoefficientCovariance./gamma)),Smod.Coefficients.Estimate);
if find(startsWith(Smod.PredictorNames,'eAT'),1,'first')==2
    tempx=dt2.YData;tempy=dt2.XData;
    dt2.XData=tempx;dt2.YData=tempy;
end
set(dt2,'Color',[0.85 0.33 0.1],'LineWidth',2)


dt2b=drawEllipse2D((inv(Smod2.CoefficientCovariance))/gamma,Smod2.Coefficients.Estimate,ax);
%dt2=drawEllipse2D((inv(Smod.CoefficientCovariance./gamma)),Smod.Coefficients.Estimate);
if find(startsWith(Smod2.PredictorNames,'eAT'),1,'first')==2
    tempx=dt2b.YData;tempy=dt2b.XData;
    dt2b.XData=tempx;dt2b.YData=tempy;
end
set(dt2b,'Color',[0.85 0.33 0.1],'LineWidth',2,'LineStyle','--')

ylabel('\betaE')
xlabel('\betaA')

legend('Controls on Controls','Controls on Stroke','Stroke on Stroke','Stroke on Controls')
%legend('control','stroke')
% 
% cci=Cmod.coefCI;
% sci=Smod.coefCI;
% cest=Cmod.Coefficients.Estimate;
% sest=Smod.Coefficients.Estimate;
% plot(cci(1,:),[cest(2) cest(2)],'Color',[0.7 0.7 0.7],'LineWidth',2)
% plot([cest(1) cest(1)],cci(2,:),'Color',[0.7 0.7 0.7],'LineWidth',2)
% 
% plot(sci(1,:),[sest(2) sest(2)],'k','LineWidth',2)
% plot([sest(1) sest(1)],sci(2,:),'k','LineWidth',2)
