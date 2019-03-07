function aa=CompareElipses(Cmod,Smod,ax);

if nargin<3
    ax=gca;
end

%check divide by gamma before or after inverse

aa=[];
dt1=draw2Dci(ax,Cmod.Coefficients.Estimate,Cmod.CoefficientCovariance,0.95,Cmod.NumObservations-1);
%make sure that BM is on the y axis
if find(startsWith(Cmod.PredictorNames,'eAT'),1,'first')==2
    tempx=dt1.YData;tempy=dt1.XData;
    dt1.XData=tempx;dt1.YData=tempy;
end
%dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance./gamma)),Cmod.Coefficients.Estimate);
set(dt1,'Color','k','LineWidth',2)

dt2=draw2Dci(ax,Smod.Coefficients.Estimate,Smod.CoefficientCovariance,0.95,Smod.NumObservations-1);
%dt2=drawEllipse2D((inv(Smod.CoefficientCovariance./gamma)),Smod.Coefficients.Estimate);
if find(startsWith(Smod.PredictorNames,'eAT'),1,'first')==2
    tempx=dt2.YData;tempy=dt2.XData;
    dt2.XData=tempx;dt2.YData=tempy;
end
set(dt2,'Color','k','LineWidth',2)

hs=patch(ax,dt2.XData,dt2.YData,[1 1 1]);
hatchfill2(hs)

ylabel(ax,'\beta_n_o_-_a_d_a_p_t')
xlabel(ax,'\beta_a_d_a_p_t')

xv=mean(get(ax,'XLim'));
yv=mean(get(ax,'YLim'));
[pValue,stat] = multivarTtest([Cmod.Coefficients.Estimate-Smod.Coefficients.Estimate],[Cmod.CoefficientCovariance+Smod.CoefficientCovariance]);
text(ax,xv,yv,['F = ',num2str(round(stat,2)),'p  = ',num2str(round(pValue,4))]);
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