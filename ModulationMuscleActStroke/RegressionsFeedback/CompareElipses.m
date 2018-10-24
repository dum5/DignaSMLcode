function aa=CompareElipses(Cmod,Smod,gamma,ax);

if nargin<4
    ax=gca;
end

%check divide by gamma before or after inverse

aa=[];
dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance))/gamma,Cmod.Coefficients.Estimate,ax);
%make sure that BM is on the y axis
if find(startsWith(Cmod.PredictorNames,'eAT'),1,'first')==1
    tempx=dt1.YData;tempy=dt1.XData;
    dt1.XData=tempx;dt1.YData=tempy;
end
%dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance./gamma)),Cmod.Coefficients.Estimate);
set(dt1,'Color','k','LineWidth',2)

dt2=drawEllipse2D((inv(Smod.CoefficientCovariance))/gamma,Smod.Coefficients.Estimate,ax);
%dt2=drawEllipse2D((inv(Smod.CoefficientCovariance./gamma)),Smod.Coefficients.Estimate);
if find(startsWith(Smod.PredictorNames,'eAT'),1,'first')==1
    tempx=dt2.YData;tempy=dt2.XData;
    dt2.XData=tempx;dt2.YData=tempy;
end
set(dt2,'Color','k','LineWidth',2)

hs=patch(ax,dt2.XData,dt2.YData,[1 1 1]);
hatchfill2(hs)

xlabel('\betaS')
ylabel('\betaM')
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
end