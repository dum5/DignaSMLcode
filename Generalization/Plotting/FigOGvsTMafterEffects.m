clear all
close all

load('D:\Documents\OnedrivePitt\University of Pittsburgh\Torres, Gelsy - Projects\GeneralizationStudy\GroupData\TimeCoursesAndTableSFN2018.mat')


figure
subplot 241
hold on


patch([101 980 980 101],[-0.3 -0.3 0.4 0.4],[0.5 0.5 0.5],'FaceAlpha',0.5,'EdgeColor','none')
dt1=smoothData([timeCourseUnbiased{2}.param{4}.cond{4}(1:104,:)],5,'nanmedian')';
dt2=smoothData([timeCourseUnbiased{2}.param{4}.cond{6}(1:884,:)],5,'nanmedian')';
dt3=smoothData([timeCourseUnbiased{2}.param{4}.cond{7}(1:104,:)],5,'nanmedian')';

plot(1:100,nanmean(dt1),'ok','MarkerFaceColor',[0.8 0 0], 'MarkerEdgeColor',[0.6 0 0])
%patch([1:100 fliplr(1:100)],[nanmean(dt1)+nanstd(dt1)./sqrt(10) fliplr(nanmean(dt1)-nanstd(dt1)./sqrt(10))],[0.8 0 0],'FaceAlpha',0.5,'LineStyle','none'); 

plot(101:980,nanmean(dt2),'ok','MarkerFaceColor',[0.8 0 0], 'MarkerEdgeColor',[0.6 0 0])
%patch([101:980 fliplr(101:980)],[nanmean(dt2)+nanstd(dt2)./sqrt(10) fliplr(nanmean(dt2)-nanstd(dt2)./sqrt(10))],[0.8 0 0],'FaceAlpha',0.5,'LineStyle','none'); 

plot(981:1080,nanmean(dt3),'ok','MarkerFaceColor',[0.8 0 0], 'MarkerEdgeColor',[0.6 0 0])
%patch([981:1080 fliplr(981:1080)],[nanmean(dt3)+nanstd(dt3)./sqrt(10) fliplr(nanmean(dt3)-nanstd(dt3)./sqrt(10))],[0.8 0 0],'FaceAlpha',0.5,'LineStyle','none'); 

dt1=smoothData([timeCourseUnbiased{6}.param{4}.cond{4}(1:104,:)],5,'nanmedian')';
dt2=smoothData([timeCourseUnbiased{6}.param{4}.cond{6}(1:884,:)],5,'nanmedian')';
dt3=smoothData([timeCourseUnbiased{6}.param{4}.cond{7}(1:104,:)],5,'nanmedian')';

plot(1:100,nanmean(dt1),'ok','MarkerFaceColor',[1 1 1], 'MarkerEdgeColor',[0.8 0 0])
%patch([1:100 fliplr(1:100)],[nanmean(dt1)+nanstd(dt1)./sqrt(10) fliplr(nanmean(dt1)-nanstd(dt1)./sqrt(10))],[0.8 0 0],'FaceAlpha',0,'LineStyle','none'); 

plot(101:980,nanmean(dt2),'ok','MarkerFaceColor',[1 1 1 ], 'MarkerEdgeColor',[0.8 0 0])
%patch([101:980 fliplr(101:980)],[nanmean(dt2)+nanstd(dt2)./sqrt(10) fliplr(nanmean(dt2)-nanstd(dt2)./sqrt(10))],[0.8 0 0],'FaceAlpha',0,'LineStyle','none'); 

plot(981:1080,nanmean(dt3),'ok','MarkerFaceColor',[1 1 1 ], 'MarkerEdgeColor',[0.8 0 0])
%patch([981:1080 fliplr(981:1080)],[nanmean(dt3)+nanstd(dt3)./sqrt(10) fliplr(nanmean(dt3)-nanstd(dt3)./sqrt(10))],[0.8 0 0],'FaceAlpha',0,'LineStyle','none'); 

set(gca,'XTick',[-10 12000])
set(gca,'FontSize',12)
ylabel('Step length asymmetry')

TFullAbrupt=T(T.group=='FullAbrupt',:);
TFullAbruptTM=T(T.group=='TMFullAbrupt',:);

subplot 244
hold on
bar(1,nanmean(TFullAbrupt.netContributionNorm2_OG_P),'FaceColor',[0.8 0 0],'EdgeColor',[0.6 0 0],'BarWidth',0.5);
errorbar(1,nanmean(TFullAbrupt.netContributionNorm2_OG_P),nanstd(TFullAbrupt.netContributionNorm2_OG_P)./sqrt(10),...
    'Color','k','LineWidth',2)
bar(2,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),'FaceColor',[1 1 1],'EdgeColor',[0.8 0 0],'BarWidth',0.5);
errorbar(2,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),nanstd(TFullAbruptTM.netContributionNorm2_TM_P)./sqrt(10),...
    'Color','k','LineWidth',2)
set(gca,'YTick',[0 0.1 0.2],'XLim',[0.5 2.5],'XTick',[-1 3])
set(gca,'FontSize',12)
title('After effects')


