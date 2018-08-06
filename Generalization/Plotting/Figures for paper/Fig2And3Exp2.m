%clear all
close all


%%%%%%%%%%%%%%%%%%%
%% Extract data %%
%%%%%%%%%%%%%%%%%%

%make sure all groups are defined
%GenerateParamsTable;
colors=[0.2 0.2 1;0.8 0 0;0.2 0.2 1;0.8 0 0];
colors2=[0.1 0.1 0.5;0.6 0 0;0.1 0.1 0.5;0.6 0 0];

%Create separate table for each group
T.ExtAdapt=T.netContributionNorm2_lateAdapt-T.velocityContributionNorm2_lateAdapt;
T.ExtReadapt=T.netContributionNorm2_lateReadapt-T.velocityContributionNorm2_lateReadapt;

%organize data for bar plots
TControl=T(T.group=='AbruptNoFeedback',:);
TFullAbrupt=T(T.group=='FullAbrupt',:);
TControlTM=T(T.group=='TMAbruptNoFeedback',:);
TFullAbruptTM=T(T.group=='TMFullAbrupt',:);
%TExp1=T(T.group=='AbruptNoFeedback' | T.group=='AbruptFeedback' | T.group=='Gradual',:);

%organize data for timeCourses
binWidth=5;sumMethod='nanmean';
Inds=[3,2,7,6];
for g=1:4
    if g==1 || g==3
        TC{g}.prepertNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{6}(1:150,:),binWidth,sumMethod)';%preperturbation
        TC{g}.adaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{6}(151:1050,:),binWidth,sumMethod)';%adaptation
    else
        TC{g}.prepertNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{5}(1:150,:),binWidth,sumMethod)';%preperturbation
        TC{g}.adaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{6}(1:900,:),binWidth,sumMethod)';%adaptation
    end
    
    TC{g}.OGpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost
    TC{g}.readaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{8}(1:600,:),binWidth,sumMethod)';%reAdaptation
    TC{g}.TMpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
    
    TC{g}.OGpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost    
    TC{g}.TMpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
    TC{g}.OGpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{7}(1:100,:),binWidth,sumMethod)';%ogPost    
    TC{g}.TMpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{9}(1:100,:),binWidth,sumMethod)';%tmPost
end

f2=figure('Name','Experiment 1A');
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
ax1 = axes('Position',[left  lower+3*delta+0.07 width4 height],'XTickLabel',{''},'Clipping','off','XLim',[0 930],'YLim',[-0.3 0.05],'YTick',[-0.3 -0.2  -0.1 0 0.2],'XTick',[0 100 200 300 400 500 600 700 800 900],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'FontSize',12,'FontName','Arial');
ax2b = axes('Position',[left+width2+0.04  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+2*(width2+0.04)  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse OG post
ax3a = axes('Position',[left  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2 0.3],'FontSize',12,'FontName','Arial');
ax3b = axes('Position',[left+width2+0.04  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2 0.3],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax3c = axes('Position',[left+2*(width2+0.04)  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2 0.3],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%bar plots OG post
ax4a = axes('Position',[left  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');
ax4b = axes('Position',[left+width2+0.04  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax4c = axes('Position',[left+2*(width2+0.04)  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.025 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');


hold(ax1)%control and small errors
l=get(ax1,'YLim');
plot(ax1,[50 50],[l(1) l(2)],'--k','Color',[0.6 0.6 0.6],'LineWidth',2)
patch(ax1,[51 65 65 51],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
patch(ax1,[91 105 105 91],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
text(ax1,-100,l(2)+0.03,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,200,l(2)+0.03,'Adaptation Errors','FontSize',14,'FontName','Arial')
for g=1:4
    ns=size(TC{g}.prepertNet,1);
    dt=TC{g}.prepertNet(:,end-49:end);
    dt2=TC{g}.adaptNet(:,1:880);
    if g<3
        patch(ax1,[1:50 fliplr(1:50)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        patch(ax1,[51:930 fliplr(51:930)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        plot(ax1,1:50,nanmean(dt),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
        plot(ax1,51:930,nanmean(dt2),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    else
        patch(ax1,[1:50 fliplr(1:50)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0)
        patch(ax1,[51:930 fliplr(51:930)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0)
        plot(ax1,1:50,nanmean(dt),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)
        plot(ax1,51:930,nanmean(dt2),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4) 
    end
    clear ns dt dt2
end
lines=findobj(ax1,'Type','Line');
%text(ax1,200,-0.12,'Control','Color',colors(1,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
%text(ax1,200,-0.15,'Small Explicit','Color',colors(2,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
%text(ax1,200,-0.18,'Small Implicit','Color',colors(3,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
plot(ax1,[200 300],[-0.32 -0.32],'k','LineWidth',2)
text(ax1,200,-0.25,'100 srides','FontName','Arial','FontSize',10);
h=legend(ax1,lines([7 5 3 1]),{'Control (OG)','Abrupt (OG)','Control (TM)','Abrupt (TM)'},'box','off','FontSize',10,'FontName','Arial');
set(h,'Position',[0.6538 0.7902 0.2798 0.1207]);


hold(ax2a)
bar(ax2a,1,nanmean(TControl.maxError),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2a,1,nanmean(TControl.maxError),nanstd(TControl.maxError)./sqrt(length(TControl.maxError)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TFullAbrupt.maxError),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax2a,2,nanmean(TFullAbrupt.maxError),nanstd(TFullAbrupt.maxError)./sqrt(length(TFullAbrupt.maxError)),...
    'Color','k','LineWidth',2)

bar(ax2a,3,nanmean(TControlTM.maxError),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2a,3,nanmean(TControlTM.maxError),nanstd(TControlTM.maxError)./sqrt(length(TControlTM.maxError)),...
    'Color','k','LineWidth',2)
bar(ax2a,4,nanmean(TFullAbruptTM.maxError),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2a,4,nanmean(TFullAbruptTM.maxError),nanstd(TFullAbruptTM.maxError)./sqrt(length(TFullAbruptTM.maxError)),...
    'Color','k','LineWidth',2)

plot(ax2a,[1 2],[-0.33 -0.33],'Color','k','LineWidth',2)
plot(ax2a,[3 4],[-0.33 -0.33],'Color','k','LineWidth',2)
text(ax2a,0.5,0.03,'Max Error','FontSize',12,'FontName','Arial');


hold(ax2b)
bar(ax2b,1,nanmean(TControl.meanError),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2b,1,nanmean(TControl.meanError),nanstd(TControl.meanError)./sqrt(length(TControl.meanError)),...
    'Color','k','LineWidth',2)
bar(ax2b,2,nanmean(TFullAbrupt.meanError),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax2b,2,nanmean(TFullAbrupt.meanError),nanstd(TFullAbrupt.meanError)./sqrt(length(TFullAbrupt.meanError)),...
    'Color','k','LineWidth',2)

bar(ax2b,3,nanmean(TControlTM.meanError),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2b,3,nanmean(TControlTM.meanError),nanstd(TControlTM.meanError)./sqrt(length(TControlTM.meanError)),...
    'Color','k','LineWidth',2)
bar(ax2b,4,nanmean(TFullAbruptTM.meanError),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2b,4,nanmean(TFullAbruptTM.meanError),nanstd(TFullAbruptTM.meanError)./sqrt(length(TFullAbruptTM.meanError)),...
    'Color','k','LineWidth',2)
text(ax2b,0.5,0.03,'Mean Error','FontSize',12,'FontName','Arial');


hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControl.netContributionNorm2_lateAdapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2c,1,nanmean(TControl.netContributionNorm2_lateAdapt),nanstd(TControl.netContributionNorm2_lateAdapt)./sqrt(length(TControl.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TFullAbrupt.netContributionNorm2_lateAdapt),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax2c,2,nanmean(TFullAbrupt.netContributionNorm2_lateAdapt),nanstd(TFullAbrupt.netContributionNorm2_lateAdapt)./sqrt(length(TFullAbrupt.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)

bar(ax2c,3,nanmean(TControlTM.netContributionNorm2_lateAdapt),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2c,3,nanmean(TControlTM.netContributionNorm2_lateAdapt),nanstd(TControlTM.netContributionNorm2_lateAdapt)./sqrt(length(TControlTM.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,4,nanmean(TFullAbruptTM.netContributionNorm2_lateAdapt),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax2c,4,nanmean(TFullAbruptTM.netContributionNorm2_lateAdapt),nanstd(TFullAbruptTM.netContributionNorm2_lateAdapt)./sqrt(length(TFullAbruptTM.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
text(ax2c,0.5,0.03,'Late Error','FontSize',12,'FontName','Arial');


hold(ax3a);hold(ax3b);hold(ax3c)
for g=1:4
    ns=size(TC{g}.prepertNet,1);
    if g<3
        dt1=TC{g}.OGpNet(:,1:20);
        dt2=TC{g}.OGpSP(:,1:20);
        dt3=TC{g}.OGpST(:,1:20);
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        plot(ax3a,1:20,nanmean(dt1),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
        plot(ax3b,1:20,nanmean(dt2),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
        plot(ax3c,1:20,nanmean(dt3),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    else
        dt1=TC{g}.TMpNet(:,1:20);
        dt2=TC{g}.TMpSP(:,1:20);
        dt3=TC{g}.TMpST(:,1:20);
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        plot(ax3a,1:20,nanmean(dt1),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)  
        plot(ax3b,1:20,nanmean(dt2),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)
        plot(ax3c,1:20,nanmean(dt3),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4) 
    end
end
text(ax3a,-9,0.32,'B','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax3a,22.5,0.32,'Aftereffects','FontSize',14,'FontName','Arial')
text(ax3a,2,0.26,'stepAsym','FontSize',12,'FontName','Arial');
text(ax3b,0.5,0.26,'stepPosition','FontSize',12,'FontName','Arial');
text(ax3c,2,0.26,'stepTime','FontSize',12,'FontName','Arial');
plot(ax3c,[10 20],[-0.03 -0.03],'k','LineWidth',2)
text(ax3c,10,-0.05,'10 srides','FontName','Arial','FontSize',10);


hold(ax4a)
bar(ax4a,1,nanmean(TControl.netContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4a,1,nanmean(TControl.netContributionNorm2_OG_P),nanstd(TControl.netContributionNorm2_OG_P)./sqrt(length(TControl.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,2,nanmean(TFullAbrupt.netContributionNorm2_OG_P),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax4a,2,nanmean(TFullAbrupt.netContributionNorm2_OG_P),nanstd(TFullAbrupt.netContributionNorm2_OG_P)./sqrt(length(TFullAbrupt.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,3,nanmean(TControlTM.netContributionNorm2_TM_P),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,3,nanmean(TControlTM.netContributionNorm2_TM_P),nanstd(TControlTM.netContributionNorm2_TM_P)./sqrt(length(TControlTM.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,4,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,4,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),nanstd(TFullAbruptTM.netContributionNorm2_TM_P)./sqrt(length(TFullAbruptTM.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)

text(ax4a,0.7,0.26,'stepAsym','FontSize',12,'FontName','Arial');
plot(ax4a,[2.5 2.5],[-0.05 0.2],'-.k','LineWidth',2,'Color',[0.6 0.6 0.6])
text(ax4a,1,-0.05,'OG','FontSize',12,'FontName','Arial')
text(ax4a,3,-0.05,'TM','FontSize',12,'FontName','Arial')

hold(ax4b)%control and small errors
bar(ax4b,1,nanmean(TControl.spatialContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4b,1,nanmean(TControl.spatialContributionNorm2_OG_P),nanstd(TControl.spatialContributionNorm2_OG_P)./sqrt(length(TControl.spatialContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,2,nanmean(TFullAbrupt.spatialContributionNorm2_OG_P),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax4b,2,nanmean(TFullAbrupt.spatialContributionNorm2_OG_P),nanstd(TFullAbrupt.spatialContributionNorm2_OG_P)./sqrt(length(TFullAbrupt.spatialContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,3,nanmean(TControlTM.spatialContributionNorm2_TM_P),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4b,3,nanmean(TControlTM.spatialContributionNorm2_TM_P),nanstd(TControlTM.spatialContributionNorm2_TM_P)./sqrt(length(TControlTM.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,4,nanmean(TFullAbruptTM.spatialContributionNorm2_TM_P),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4b,4,nanmean(TFullAbruptTM.spatialContributionNorm2_TM_P),nanstd(TFullAbruptTM.spatialContributionNorm2_TM_P)./sqrt(length(TFullAbruptTM.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4b,0.55,0.26,'stepPosition','FontSize',12,'FontName','Arial');

plot(ax4b,[2.5 2.5],[-0.05 0.2],'-.k','LineWidth',2,'Color',[0.6 0.6 0.6])
text(ax4b,1,-0.05,'OG','FontSize',12,'FontName','Arial')
text(ax4b,3,-0.05,'TM','FontSize',12,'FontName','Arial')

hold(ax4c)%control and small errors
bar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_OG_P),nanstd(TControl.stepTimeContributionNorm2_OG_P)./sqrt(length(TControl.stepTimeContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,2,nanmean(TFullAbrupt.stepTimeContributionNorm2_OG_P),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax4c,2,nanmean(TFullAbrupt.stepTimeContributionNorm2_OG_P),nanstd(TFullAbrupt.stepTimeContributionNorm2_OG_P)./sqrt(length(TFullAbrupt.stepTimeContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,3,nanmean(TControlTM.stepTimeContributionNorm2_TM_P),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4c,3,nanmean(TControlTM.stepTimeContributionNorm2_TM_P),nanstd(TControlTM.stepTimeContributionNorm2_TM_P)./sqrt(length(TControlTM.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,4,nanmean(TFullAbruptTM.stepTimeContributionNorm2_TM_P),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4c,4,nanmean(TFullAbruptTM.stepTimeContributionNorm2_TM_P),nanstd(TFullAbruptTM.stepTimeContributionNorm2_TM_P)./sqrt(length(TFullAbruptTM.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4c,0.7,0.26,'stepTime','FontSize',12,'FontName','Arial');

plot(ax4c,[2.5 2.5],[-0.05 0.2],'-.k','LineWidth',2,'Color',[0.6 0.6 0.6])
text(ax4c,1,-0.05,'OG','FontSize',12,'FontName','Arial')
text(ax4c,3,-0.05,'TM','FontSize',12,'FontName','Arial')




f3=figure('Name','Experiment 1B');
set(f3,'Color',[1 1 1]','Units','inches','Position',[0 0 3.5 6])

%timeCourse re-Adaptation
ax1 = axes('Position',[left  lower+3*delta+0.07 width4 height],'XTickLabel',{''},'Clipping','off','XLim',[0 280],'YLim',[-0.2 0.05],'YTick',[-0.2 0 0.2],'XTick',[0 100 200],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'FontSize',12,'FontName','Arial');
ax2b = axes('Position',[left+width2+0.04  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+2*(width2+0.04)  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[-0.2 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse TM post
ax3a = axes('Position',[left  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');
ax3b = axes('Position',[left+width2+0.04  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax3c = axes('Position',[left+2*(width2+0.04)  lower+delta width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%bar plots TM post
ax4a = axes('Position',[left  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');
ax4b = axes('Position',[left+width2+0.04  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax4c = axes('Position',[left+2*(width2+0.04)  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 3.5],'YLim',[0 0.25],'YTick',[0 0.1 0.2],'YTickLabel',{''},'FontSize',12,'FontName','Arial');



hold(ax1)%control and small errors
text(ax1,-30,l(2)+0.03,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,50,l(2)+0.03,'Re-adaptation Errors','FontSize',14,'FontName','Arial')
patch(ax1,[1 15 15 1],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
for g=1:4
    ns=size(TC{g}.prepertNet,1);
    dt=TC{g}.readaptNet(:,1:280);
    patch(ax1,[1:280 fliplr(1:280)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
    plot(ax1,1:280,nanmean(dt),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    clear ns dt 
end

text(ax1,50,-0.075,'Control','Color',colors(1,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
text(ax1,50,-0.105,'Small Explicit','Color',colors(2,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
text(ax1,50,-0.135,'Small Implicit','Color',colors(3,:),'FontName','Arial','FontSize',10,'FontWeight','bold')
plot(ax1,[100 200],[-0.22 -0.22],'k','LineWidth',2)
text(ax1,100,-0.18,'100 srides','FontName','Arial','FontSize',10);

hold(ax2a)%control and small errors
bar(ax2a,1,nanmean(TControl.maxErrorReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2a,1,nanmean(TControl.maxErrorReadapt),nanstd(TControl.maxErrorReadapt)./sqrt(length(TControl.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TFeedback.maxErrorReadapt),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax2a,2,nanmean(TFeedback.maxErrorReadapt),nanstd(TFeedback.maxErrorReadapt)./sqrt(length(TFeedback.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2a,3,nanmean(TGradual.maxErrorReadapt),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax2a,3,nanmean(TGradual.maxErrorReadapt),nanstd(TGradual.maxErrorReadapt)./sqrt(length(TGradual.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
plot(ax2a,[2 3],[-0.175 -0.175],'Color','k','LineWidth',2)
plot(ax2a,[1 3],[-0.1825 -0.1825],'Color','k','LineWidth',2)
text(ax2a,0.5,0.025,'Max Error','FontSize',12,'FontName','Arial');

hold(ax2b)%control and small errors
bar(ax2b,1,nanmean(TControl.meanErrorReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2b,1,nanmean(TControl.meanErrorReadapt),nanstd(TControl.meanErrorReadapt)./sqrt(length(TControl.meanErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2b,2,nanmean(TFeedback.meanErrorReadapt),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax2b,2,nanmean(TFeedback.meanErrorReadapt),nanstd(TFeedback.meanErrorReadapt)./sqrt(length(TFeedback.meanErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2b,3,nanmean(TGradual.meanErrorReadapt),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax2b,3,nanmean(TGradual.meanErrorReadapt),nanstd(TGradual.meanErrorReadapt)./sqrt(length(TGradual.meanErrorReadapt)),...
    'Color','k','LineWidth',2)
text(ax2b,0.5,0.025,'Mean Error','FontSize',12,'FontName','Arial');


hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControl.netContributionNorm2_lateReadapt),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2c,1,nanmean(TControl.netContributionNorm2_lateReadapt),nanstd(TControl.netContributionNorm2_lateReadapt)./sqrt(length(TControl.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TFeedback.netContributionNorm2_lateReadapt),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax2c,2,nanmean(TFeedback.netContributionNorm2_lateReadapt),nanstd(TFeedback.netContributionNorm2_lateReadapt)./sqrt(length(TFeedback.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,3,nanmean(TGradual.netContributionNorm2_lateReadapt),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax2c,3,nanmean(TGradual.netContributionNorm2_lateReadapt),nanstd(TGradual.netContributionNorm2_lateReadapt)./sqrt(length(TGradual.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
text(ax2c,0.5,0.025,'Late Error','FontSize',12,'FontName','Arial');


hold(ax3a);hold(ax3b);hold(ax3c)

for g=1:3
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
bar(ax4a,2,nanmean(TFeedback.netContributionNorm2_TM_P),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax4a,2,nanmean(TFeedback.netContributionNorm2_TM_P),nanstd(TFeedback.netContributionNorm2_TM_P)./sqrt(length(TFeedback.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,3,nanmean(TGradual.netContributionNorm2_TM_P),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax4a,3,nanmean(TGradual.netContributionNorm2_TM_P),nanstd(TGradual.netContributionNorm2_TM_P)./sqrt(length(TGradual.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4a,0.7,0.26,'stepAsym','FontSize',12,'FontName','Arial');


hold(ax4b)%control and small errors
bar(ax4b,1,nanmean(TControl.spatialContributionNorm2_TM_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4b,1,nanmean(TControl.spatialContributionNorm2_TM_P),nanstd(TControl.spatialContributionNorm2_TM_P)./sqrt(length(TControl.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,2,nanmean(TFeedback.spatialContributionNorm2_TM_P),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax4b,2,nanmean(TFeedback.spatialContributionNorm2_TM_P),nanstd(TFeedback.spatialContributionNorm2_TM_P)./sqrt(length(TFeedback.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4b,3,nanmean(TGradual.spatialContributionNorm2_TM_P),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax4b,3,nanmean(TGradual.spatialContributionNorm2_TM_P),nanstd(TGradual.spatialContributionNorm2_TM_P)./sqrt(length(TGradual.spatialContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4b,0.55,0.26,'stepPosition','FontSize',12,'FontName','Arial');


hold(ax4c)%control and small errors
bar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_TM_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4c,1,nanmean(TControl.stepTimeContributionNorm2_TM_P),nanstd(TControl.stepTimeContributionNorm2_TM_P)./sqrt(length(TControl.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,2,nanmean(TFeedback.stepTimeContributionNorm2_TM_P),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax4c,2,nanmean(TFeedback.stepTimeContributionNorm2_TM_P),nanstd(TFeedback.stepTimeContributionNorm2_TM_P)./sqrt(length(TFeedback.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4c,3,nanmean(TGradual.stepTimeContributionNorm2_TM_P),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax4c,3,nanmean(TGradual.stepTimeContributionNorm2_TM_P),nanstd(TGradual.stepTimeContributionNorm2_TM_P)./sqrt(length(TGradual.stepTimeContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
text(ax4c,0.7,0.26,'stepTime','FontSize',12,'FontName','Arial');