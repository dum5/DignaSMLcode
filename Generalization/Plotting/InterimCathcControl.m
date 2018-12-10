clear all
close all

load('InterimCatchControl');

rep=defineEpochs({'B'},{'OG base'},[-40],[1],[5],'nanmedian');
OGP=defineEpochs({'OGP'},{'OG post'},[5],[1],[5],'nanmean');

CatchG=studyData.Catch.removeBadStrides.removeBaselineEpoch(rep,{'netContributionNorm2'});
CatchControlG=studyData.CatchControl.removeBadStrides.removeBaselineEpoch(rep,{'netContributionNorm2'});
ControlG=studyData.Control.removeBadStrides.removeBaselineEpoch(rep,{'netContributionNorm2'});

figure
hold on
bar(1,nanmean(squeeze(CatchG.getEpochData(OGP,'netContributionNorm2'))))
errorbar(1,nanmean(squeeze(CatchG.getEpochData(OGP,'netContributionNorm2'))),nanstd(squeeze(CatchG.getEpochData(OGP,'netContributionNorm2')))./sqrt(10),'-k')
plot(1,squeeze(CatchG.getEpochData(OGP,'netContributionNorm2')),'ok')
bar(2,nanmean(squeeze(ControlG.getEpochData(OGP,'netContributionNorm2'))))
errorbar(2,nanmean(squeeze(ControlG.getEpochData(OGP,'netContributionNorm2'))),nanstd(squeeze(ControlG.getEpochData(OGP,'netContributionNorm2')))./sqrt(10),'k')
plot(2,squeeze(ControlG.getEpochData(OGP,'netContributionNorm2')),'ok')
bar(3,nanmean(squeeze(CatchControlG.getEpochData(OGP,'netContributionNorm2'))))
errorbar(3,nanmean(squeeze(CatchControlG.getEpochData(OGP,'netContributionNorm2'))),nanstd(squeeze(CatchControlG.getEpochData(OGP,'netContributionNorm2')))./sqrt(5),'k')
plot(3,squeeze(CatchControlG.getEpochData(OGP,'netContributionNorm2')),'ok')

set(gca,'XLim',[0.5 3.5],'XTick',[1 2 3],'XTickLabel',{'Catch','Control','CatchControl'})
title('OG after effects')