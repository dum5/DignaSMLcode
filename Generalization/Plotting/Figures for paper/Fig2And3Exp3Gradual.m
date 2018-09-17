%clear all
close all


%%%%%%%%%%%%%%%%%%%
%% Extract data %%
%%%%%%%%%%%%%%%%%%

%make sure all groups are defined
%GenerateParamsTable;
colors=[0.2 0.2 1;0.67 0.85 0.30];
colors2=[0.1 0.1 0.5;0.37 0.55 0.0];

%Create separate table for each group
T.ExtAdapt=T.netContributionNorm2_lateAdapt-T.velocityContributionNorm2_lateAdapt;
T.ExtReadapt=T.netContributionNorm2_lateReadapt-T.velocityContributionNorm2_lateReadapt;

%organize data for bar plots
TControl=T(T.group=='GradualNoCatch',:);
TCatch=T(T.group=='GradualCatch',:);
%organize data for timeCourses
binWidth=5;sumMethod='nanmean';
Inds=[8,9];
for g=1:2
    TC{g}.prepertNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{6}(1:150,:),binWidth,sumMethod)';%preperturbation
    TC{g}.adaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{6}(151:1050,:),binWidth,sumMethod)';%adaptation
    TC{g}.OGpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost
%     TC{g}.readaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{8}(1:600,:),binWidth,sumMethod)';%reAdaptation
%     TC{g}.TMpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
    
    TC{g}.OGpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost    
    %TC{g}.TMpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
    TC{g}.OGpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost    
    %TC{g}.TMpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
end
catchError=getGroupedTimeCourses(groups{5},{'Catch'},{'netContributionNorm2'});
TMbias=squeeze(groupOutcomes{5}(4,TMref,:))'; 
cathcError=[catchError{1}.param{1}.cond{1}-TMbias]';
catchError2=smoothData(catchError{1}.param{1}.cond{1}(1:10,:),binWidth,sumMethod)';

f2=figure('Name','Experiment 3A');
set(f2,'Color',[1 1 1]','Units','inches','Position',[0 0 3.5 6])

lower=0.05;%position of bottom axes
left=0.12;
height=0.16;%height of axes
width2=0.23;
width4=0.81;
delta=height*1.4;
deltav=0.04;
yaxmax=0.3;
yaxmin=-0.35;

%timeCourse Adaptation
ax1 = axes('Position',[left  lower+3*delta+0.07 width4 height],'XTickLabel',{''},'Clipping','off','XLim',[0 930],'YLim',[-0.2 0.3],'YTick',[-0.2 0 0.2],'XTick',[0 100 200 300 400 500 600 700 800 900],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0.25],'YTick',[-0.2 0 0.2],'FontSize',12,'FontName','Arial');
ax2b = axes('Position',[left+width2+0.04  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0.25],'YTick',[-0.2 0 0.2 ],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+2*(width2+0.04)  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0.25],'YTick',[-0.2 0 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse OG post
ax3a = axes('Position',[left  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.05 0.15],'YTick',[0 0.1],'FontSize',12,'FontName','Arial');
ax3b = axes('Position',[left+width2+0.04  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.05 0.15],'YTick',[0 0.1],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax3c = axes('Position',[left+2*(width2+0.04)  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.05 0.15],'YTick',[0 0.1],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%bar plots OG post
ax4a = axes('Position',[left  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.05 0.15],'YTick',[0 0.1],'FontSize',12,'FontName','Arial');
ax4b = axes('Position',[left+width2+0.04  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.05 0.15],'YTick',[0 0.1],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax4c = axes('Position',[left+2*(width2+0.04)  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.05 0.15],'YTick',[0 0.1],'YTickLabel',{''},'FontSize',12,'FontName','Arial');


hold(ax1)%control and small errors
l=get(ax1,'YLim');
plot(ax1,[50 50],[l(1) l(2)],'--k','Color',[0.6 0.6 0.6],'LineWidth',2)
patch(ax1,[91 105 105 91],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
text(ax1,-100,l(2)+0.03,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,200,l(2)+0.03,'Adaptation Errors','FontSize',14,'FontName','Arial')
for g=1:2
    ns=size(TC{g}.prepertNet,1);
    dt=TC{g}.prepertNet(:,end-49:end);
    dt2=TC{g}.adaptNet(:,1:880);
    if g==2
        dt2=[dt2(:,1:594) catchError2 dt2(:,601:880)];
    end
    patch(ax1,[1:50 fliplr(1:50)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    patch(ax1,[51:930 fliplr(51:930)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    plot(ax1,1:50,nanmean(dt),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    plot(ax1,51:930,nanmean(dt2),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    clear ns dt dt2
end
text(ax1,200,0.15,'Control','Color',colors(1,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
text(ax1,200,0.08,'Catch','Color',colors(2,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
plot(ax1,[700 800],[-0.22 -0.22],'k','LineWidth',2)
text(ax1,700,-0.15,'100 srides','FontName','Arial','FontSize',10);

annotation(f2,'arrow',[0.773809523809524 0.705357142857143],[0.904513888888889 0.902777777777778]);
annotation(f2,'textbox',[0.764880952380952 0.884416667546249 0.160714281811601 0.0468749991204176],...
    'String',{'catch'},'LineStyle','none');
annotation(f2,'arrow',[0.619047619047619 0.669642857142857],[0.818444444444444 0.828125]);
annotation(f2,'textbox',[0.416666666666667 0.785458334212912 0.244047615144931 0.0468749991204178],...
    'String','after catch','LineStyle','none','FitBoxToText','off');

hold(ax2a)%
bar(ax2a,1,nanmean(TControl.maxError),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2a,1,nanmean(TControl.maxError),nanstd(TControl.maxError)./sqrt(length(TControl.maxError)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TCatch.maxError),'FaceColor',[0.67 0.85 0.3],'BarWidth',0.7);
errorbar(ax2a,2,nanmean(TCatch.maxError),nanstd(TCatch.maxError)./sqrt(length(TCatch.maxError)),...
    'Color','k','LineWidth',2)
text(ax2a,0.5,0.3,'Max Error','FontSize',12,'FontName','Arial');



hold(ax2b)%control and small errors
bar(ax2b,1,nanmean(TCatch.netContributionNorm2_catch),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2b,1,nanmean(TCatch.netContributionNorm2_catch),nanstd(TCatch.netContributionNorm2_catch)./sqrt(length(TCatch.netContributionNorm2_catch)),...
    'Color','k','LineWidth',2)
bar(ax2b,2,nanmean(TCatch.netContributionNorm2_resumeSplit),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2b,2,nanmean(TCatch.netContributionNorm2_resumeSplit),nanstd(TCatch.netContributionNorm2_resumeSplit)./sqrt(length(TCatch.netContributionNorm2_resumeSplit)),...
    'Color','k','LineWidth',2)
text(ax2b,0.5,0.3,'Catch Error','FontSize',12,'FontName','Arial');
text(ax2b,0.5,-0.25,'Catch','FontSize',10,'FontName','Arial')
text(ax2b,1.5,-0.27,{'After','Catch'},'FontSize',10,'FontName','Arial')
%set(ax2b,'XTick',[1 2],'XTickLabel',{'Catch','After Catch'})

hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControl.netContributionNorm2_lateAdapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2c,1,nanmean(TControl.netContributionNorm2_lateAdapt),nanstd(TControl.netContributionNorm2_lateAdapt)./sqrt(length(TControl.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TCatch.netContributionNorm2_lateAdapt),'FaceColor',[0.37 0.55 0.0],'BarWidth',0.7);
errorbar(ax2c,2,nanmean(TCatch.netContributionNorm2_lateAdapt),nanstd(TCatch.netContributionNorm2_lateAdapt)./sqrt(length(TCatch.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
text(ax2c,0.5,0.3,'Late Error','FontSize',12,'FontName','Arial');


hold(ax3a);hold(ax3b);hold(ax3c)
for g=1:2
    ns=size(TC{g}.prepertNet,1);
    dt1=TC{g}.OGpNet(:,1:20);
    dt2=TC{g}.OGpSP(:,1:20);
    dt3=TC{g}.OGpST(:,1:20);
    patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    plot(ax3a,1:20,nanmean(dt1),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    plot(ax3b,1:20,nanmean(dt2),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    plot(ax3c,1:20,nanmean(dt3),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
end
text(ax3a,-9,0.22,'B','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax3a,7.5,0.22,'Overground Aftereffects','FontSize',14,'FontName','Arial')
text(ax3a,2,0.16,'stepAsym','FontSize',12,'FontName','Arial');
text(ax3b,0.5,0.16,'stepPosition','FontSize',12,'FontName','Arial');
text(ax3c,2,0.16,'stepTime','FontSize',12,'FontName','Arial');
plot(ax3c,[10 20],[-0.06 -0.06],'k','LineWidth',2)
text(ax3c,10,-0.08,'10 srides','FontName','Arial','FontSize',10);


hold(ax4a)%control and small errors
bar(ax4a,1,nanmean(TControl.netContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4a,1,nanmean(TControl.netContributionNorm2_OG_P),nanstd(TControl.netContributionNorm2_OG_P)./sqrt(length(TControl.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,2,nanmean(TCatch.netContributionNorm2_OG_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4a,2,nanmean(TCatch.netContributionNorm2_OG_P),nanstd(TCatch.netContributionNorm2_OG_P)./sqrt(length(TCatch.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
plot(ax4a,[1 2],[0.125 0.125],'Color','k','LineWidth',2)
text(ax4a,0.7,0.16,'stepAsym','FontSize',12,'FontName','Arial');


hold(ax4b)%control and small errors
bar(ax4b,1,nanmean(TControl.spatialContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4b,1,nanmean(TControl.spatialContributionNorm2_OG_P),nanstd(TControl.spatialContributionNorm2_OG_P)./sqrt(length(TControl.spatialContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,2,nanmean(TCatch.spatialContributionNorm2_OG_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4b,2,nanmean(TCatch.spatialContributionNorm2_OG_P),nanstd(TCatch.spatialContributionNorm2_OG_P)./sqrt(length(TCatch.spatialContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
plot(ax4b,[1 2],[0.05 0.05],'Color','k','LineWidth',2)
text(ax4b,0.55,0.16,'stepPosition','FontSize',12,'FontName','Arial');


hold(ax4c)%control and small errors
bar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_OG_P),nanstd(TControl.stepTimeContributionNorm2_OG_P)./sqrt(length(TControl.stepTimeContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,2,nanmean(TCatch.stepTimeContributionNorm2_OG_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4c,2,nanmean(TCatch.stepTimeContributionNorm2_OG_P),nanstd(TCatch.stepTimeContributionNorm2_OG_P)./sqrt(length(TCatch.stepTimeContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
plot(ax4c,[1 2],[0.1 0.1],'Color','k','LineWidth',2)
text(ax4c,0.7,0.16,'stepTime','FontSize',12,'FontName','Arial');



f3=figure('Name','Experiment 3B');
set(f3,'Color',[1 1 1]','Units','inches','Position',[0 0 3.5 6])

%timeCourse re-Adaptation
ax1 = axes('Position',[left  lower+3*delta+0.07 width4 height],'XTickLabel',{''},'Clipping','off','XLim',[0 280],'YLim',[-0.2 0.05],'YTick',[-0.2 0 0.2],'XTick',[0 100 200],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'FontSize',12,'FontName','Arial');
ax2b = axes('Position',[left+width2+0.04  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+2*(width2+0.04)  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse TM post
ax3a = axes('Position',[left  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');
ax3b = axes('Position',[left+width2+0.04  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax3c = axes('Position',[left+2*(width2+0.04)  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%bar plots TM post
ax4a = axes('Position',[left  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');
ax4b = axes('Position',[left+width2+0.04  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax4c = axes('Position',[left+2*(width2+0.04)  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

hold(ax1)%control and small errors
text(ax1,-30,0.05+0.03,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,50,0.05+0.03,'Re-adaptation Errors','FontSize',14,'FontName','Arial')
patch(ax1,[1 15 15 1],[l(1) l(1) 0.05 0.05],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
for g=1:2
    ns=size(TC{g}.prepertNet,1);
    dt=TC{g}.readaptNet(:,1:280);
    patch(ax1,[1:280 fliplr(1:280)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    plot(ax1,1:280,nanmean(dt),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    clear ns dt 
end

text(ax1,50,-0.075,'Control','Color',colors(1,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
text(ax1,50,-0.105,'Catch','Color',colors(2,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
plot(ax1,[100 200],[-0.22 -0.22],'k','LineWidth',2)
text(ax1,100,-0.18,'100 srides','FontName','Arial','FontSize',10);

hold(ax2a)%control and small errors
bar(ax2a,1,nanmean(TControl.maxErrorReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2a,1,nanmean(TControl.maxErrorReadapt),nanstd(TControl.maxErrorReadapt)./sqrt(length(TControl.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TCatch.maxErrorReadapt),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2a,2,nanmean(TCatch.maxErrorReadapt),nanstd(TCatch.maxErrorReadapt)./sqrt(length(TCatch.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
text(ax2a,0.5,0.025,'Max Error','FontSize',12,'FontName','Arial');

hold(ax2b)%control and small errors
bar(ax2b,1,nanmean(TControl.meanErrorReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2b,1,nanmean(TControl.meanErrorReadapt),nanstd(TControl.meanErrorReadapt)./sqrt(length(TControl.meanErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2b,2,nanmean(TCatch.meanErrorReadapt),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2b,2,nanmean(TCatch.meanErrorReadapt),nanstd(TCatch.meanErrorReadapt)./sqrt(length(TCatch.meanErrorReadapt)),...
    'Color','k','LineWidth',2)
text(ax2b,0.5,0.025,'Mean Error','FontSize',12,'FontName','Arial');


hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControl.netContributionNorm2_lateReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2c,1,nanmean(TControl.netContributionNorm2_lateReadapt),nanstd(TControl.netContributionNorm2_lateReadapt)./sqrt(length(TControl.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TCatch.netContributionNorm2_lateReadapt),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2c,2,nanmean(TCatch.netContributionNorm2_lateReadapt),nanstd(TCatch.netContributionNorm2_lateReadapt)./sqrt(length(TCatch.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
text(ax2c,0.5,0.025,'Late Error','FontSize',12,'FontName','Arial');


hold(ax3a);hold(ax3b);hold(ax3c)

for g=1:2
    ns=size(TC{g}.prepertNet,1);
    dt1=TC{g}.TMpNet(:,1:20);
    dt2=TC{g}.TMpSP(:,1:20);
    dt3=TC{g}.TMpST(:,1:20);
    patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    plot(ax3a,1:20,nanmean(dt1),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    plot(ax3b,1:20,nanmean(dt2),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    plot(ax3c,1:20,nanmean(dt3),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
end
text(ax3a,-9,0.34,'B','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax3a,7.5,0.34,'Treadmill Aftereffects','FontSize',14,'FontName','Arial')
text(ax3a,2,0.28,'stepAsym','FontSize',12,'FontName','Arial');
text(ax3b,0.5,0.28,'stepPosition','FontSize',12,'FontName','Arial');
text(ax3c,2,0.28,'stepTime','FontSize',12,'FontName','Arial');
plot(ax3c,[10 20],[-0.02 -0.02],'k','LineWidth',2)
text(ax3c,10,-0.04,'10 srides','FontName','Arial','FontSize',10);

hold(ax4a)%control and small errors
bar(ax4a,1,nanmean(TControl.netContributionNorm2_TM_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4a,1,nanmean(TControl.netContributionNorm2_TM_P),nanstd(TControl.netContributionNorm2_TM_P)./sqrt(length(TControl.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,2,nanmean(TCatch.netContributionNorm2_TM_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4a,2,nanmean(TCatch.netContributionNorm2_TM_P),nanstd(TCatch.netContributionNorm2_TM_P)./sqrt(length(TCatch.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
plot(ax4a,[1 2],[0.22 0.22],'Color','k','LineWidth',2)
text(ax4a,0.7,0.26,'stepAsym','FontSize',12,'FontName','Arial');


hold(ax4b)%control and small errors
bar(ax4b,1,nanmean(TControl.spatialContributionNorm2_TM_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4b,1,nanmean(TControl.spatialContributionNorm2_TM_P),nanstd(TControl.spatialContributionNorm2_TM_P)./sqrt(length(TControl.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,2,nanmean(TCatch.spatialContributionNorm2_TM_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4b,2,nanmean(TCatch.spatialContributionNorm2_TM_P),nanstd(TCatch.spatialContributionNorm2_TM_P)./sqrt(length(TCatch.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
plot(ax4b,[1 2],[0.15 0.15],'Color','k','LineWidth',2)
text(ax4b,0.55,0.26,'stepPosition','FontSize',12,'FontName','Arial');


hold(ax4c)%control and small errors
bar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_TM_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_TM_P),nanstd(TControl.stepTimeContributionNorm2_TM_P)./sqrt(length(TControl.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,2,nanmean(TCatch.stepTimeContributionNorm2_TM_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax4c,2,nanmean(TCatch.stepTimeContributionNorm2_TM_P),nanstd(TCatch.stepTimeContributionNorm2_TM_P)./sqrt(length(TCatch.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4c,0.7,0.26,'stepTime','FontSize',12,'FontName','Arial');
