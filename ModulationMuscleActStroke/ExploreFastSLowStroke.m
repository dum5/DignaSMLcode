clear all
close all

load('AllParamsTable.mat')
AddCombinedParamsToTable;

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
names=TStroke.Properties.VariableNames;
for k=2:length(names)
    if ~iscell(TStroke.(names{k}))
        TStroke.(names{k})(5)=NaN;
    end
end
Idx=[1:4 6:15];
%TStroke.ePMagn(5)=NaN;
%TStroke.ePBMagn(5)=NaN;

TStrokeFast=TStroke(TStroke.SpeedMatch==1,:);
TStrokeSlow=TStroke(TStroke.SpeedMatch==0,:);

par='eA_B_netContributionPNorm';
fastData=TStrokeFast.eA_B_netContributionPNorm;
slowData=TStrokeSlow.eA_B_netContributionPNorm;
allData=TStroke.eA_B_netContributionPNorm;

figure
subplot(2,2,1)
hold on
bar([1,2],[nanmean(fastData) nanmean(slowData)]);
errorbar([1,2],[nanmean(fastData) nanmean(slowData)],[nanstd(fastData) nanstd(slowData)],'LineStyle','none','Color','k')
set(gca,'XTick',[1,2],'XTickLabel',{'Fast','Slow'},'XLim',[0.5 2.5])
ylabel(par)
title(['p= ',num2str(ranksum(fastData,slowData))])

subplot(2,2,2)
hold on
plot(TStroke.vel(Idx),allData(Idx),'ok')
[c,p]=corr(TStroke.vel(Idx),allData(Idx),'Type','Spearman');
xlabel('Velocity')
title(['rho=',num2str(round(c,2)),' p=',round(p,3)])