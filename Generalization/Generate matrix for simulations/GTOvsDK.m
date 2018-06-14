
GTOgradual = [0.06 0.02 0.12 0.07 0.14 0.07 0.11 0.17 0.04];
GTOabrupt = [0.03 0.00 0.03 0.05 0.14 0.08 0.05 0.03 0.04 0.08 0.01];

DKabrupt = [0.0762    0.0424    0.1045    0.0553    0.1299    0.074   -0.0086    0.1742    0.0979    0.1405];%full abrupt group
DKcatch = [0.0415 0.0344  0.0243 0.0358 0.0014 0.0087 0.0527 0.0220 0.0433 0.0918];

figure
subplot(2,2,1)
hold on
bar(1,nanmean(GTOabrupt),'FaceColor',[1 1 1])
errorbar(1,nanmean(GTOabrupt),nanstd(GTOabrupt)./sqrt(length(GTOabrupt)),'Color','k','LineWidth',2)

bar(2,nanmean(GTOgradual),'FaceColor',[0 0 0])
errorbar(2,nanmean(GTOgradual),nanstd(GTOgradual)./sqrt(length(GTOgradual)),'Color','k','LineWidth',2)

bar(4,nanmean(DKcatch),'FaceColor',[0.9 0.9 1])
errorbar(4,nanmean(DKcatch),nanstd(DKcatch)./sqrt(length(DKcatch)),'Color','k','LineWidth',2)


bar(5,nanmean(DKabrupt),'FaceColor',[0.8 0 0])
errorbar(5,nanmean(DKabrupt),nanstd(DKabrupt)./sqrt(length(DKabrupt)),'Color','k','LineWidth',2)

ylabel('OG after effects')
set(gca,'XTick',[1 2 4 5],'XTickLabel',{'TO abrupt','TO gradual','Catch','FullAbrupt'},'FontSize',12)
