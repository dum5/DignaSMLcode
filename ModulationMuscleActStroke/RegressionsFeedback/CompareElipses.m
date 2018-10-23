function aa=CompareElipses(Cmod,Smod,gamma);

%check divide by gamma before or after inverse
figure 
hold on
aa=[];
dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance))/gamma,Cmod.Coefficients.Estimate);
%dt1=drawEllipse2D((inv(Cmod.CoefficientCovariance./gamma)),Cmod.Coefficients.Estimate);
set(dt1,'Color',[0.7 0.7 0.7],'LineWidth',2)

dt2=drawEllipse2D((inv(Smod.CoefficientCovariance))/gamma,Smod.Coefficients.Estimate);
%dt2=drawEllipse2D((inv(Smod.CoefficientCovariance./gamma)),Smod.Coefficients.Estimate);
set(dt2,'Color','k','LineWidth',2)

xlabel(Cmod.CoefficientNames{1})
ylabel(Cmod.CoefficientNames{2})
legend('control','stroke')
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