clear all
close all


%%%%%%%%%%%%%%%%%%%
%% Extract data %%
%%%%%%%%%%%%%%%%%%

%make sure all groups are defined

[loadName,matDataDir]=uigetfile('choose data file ','*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)


colors=[0.2 0.2 1;0.8 0 0;0.2 0.2 1;0.8 0 0];
colors2=[0.1 0.1 0.5;0.6 0 0;0.1 0.1 0.5;0.6 0 0];

%Create separate table for each group
T.ExtAdapt=T.netContributionNorm2_lateAdapt-T.velocityContributionNorm2_lateAdapt;
T.ExtReadapt=T.netContributionNorm2_lateReadapt-T.velocityContributionNorm2_lateReadapt;
T.netContributionNorm2_deltaTM=T.netContributionNorm2_TM_P-T.netContributionNorm2_TM_LP;

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
    
    
    TC{g}.readaptNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{8}(1:600,:),binWidth,sumMethod)';%reAdaptation
    
    dt1=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:700,:),binWidth,sumMethod)';%ogPost
    dt2=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:700,:),binWidth,sumMethod)';
    dt3=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:700,:),binWidth,sumMethod)';
    
    dt4=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:700,:),binWidth,sumMethod)';%ogPost
    dt5=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:700,:),binWidth,sumMethod)';
    dt6=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:700,:),binWidth,sumMethod)';
        
    TC{g}.OGpNet=NaN(size(dt1,1),35); TC{g}.OGpSP=NaN(size(dt1,1),35); TC{g}.OGpST=NaN(size(dt1,1),35);
    TC{g}.OGpNet(:,1:20)=dt1(:,1:20);TC{g}.OGpSP(:,1:20)=dt2(:,1:20);TC{g}.OGpST(:,1:20)=dt3(:,1:20);
    
    TC{g}.TMpNet=NaN(size(dt1,1),35); TC{g}.TMpSP=NaN(size(dt1,1),35); TC{g}.TMpST=NaN(size(dt1,1),35);
    TC{g}.TMpNet(:,1:20)=dt4(:,1:20);TC{g}.TMpSP(:,1:20)=dt5(:,1:20);TC{g}.TMpST(:,1:20)=dt6(:,1:20);
    
    %this is to align last strides of washout
    for sj=1:size(dt1,1)
        last=find(~isnan(dt1(sj,:)),1,'last')-5;
        TC{g}.OGpNet(sj,26:35)=dt1(sj,last-9:last);
        TC{g}.OGpSP(sj,26:35)=dt2(sj,last-9:last);
        TC{g}.OGpST(sj,26:35)=dt3(sj,last-9:last);
        last=find(~isnan(dt1(sj,:)),1,'last')-5;
        TC{g}.TMpNet(sj,26:35)=dt4(sj,last-9:last);
        TC{g}.TMpSP(sj,26:35)=dt5(sj,last-9:last);
        TC{g}.TMpST(sj,26:35)=dt6(sj,last-9:last);
        
    end
    %TC{g}.OGpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:100,:),binWidth,sumMethod)';%ogPost
    %TC{g}.TMpNet=smoothData(timeCourseUnbiased{Inds(g)}.param{4}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:100,:),binWidth,sumMethod)';%tmPost
    
%     TC{g}.OGpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:100,:),binWidth,sumMethod)';%ogPost    
%     TC{g}.TMpSP=smoothData(timeCourseUnbiased{Inds(g)}.param{1}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:100,:),binWidth,sumMethod)';%tmPost
%     TC{g}.OGpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{find(contains(timeCourse{Inds(g)}.condNames,'OG post'))}(1:100,:),binWidth,sumMethod)';%ogPost    
%     TC{g}.TMpST=smoothData(timeCourseUnbiased{Inds(g)}.param{2}.cond{find(contains(timeCourse{Inds(g)}.condNames,'TM post'))}(1:100,:),binWidth,sumMethod)';%tmPost
end


f2=figure('Name','Experiment 1A');
set(f2,'Color',[1 1 1]','Units','inches','Position',[0 0 7 2.7])

lower=0.05;%position of bottom axes
left=0.07;
height=0.35;%height of axes
width2=0.17;
width4=0.6;
width3=0.24;
delta=height*1.25;
deltav=0.04;
yaxmax=0.3;
yaxmin=-0.35;

%timeCourse Adaptation
ax1 = axes('Position',[left  lower+delta+0.04 width4-0.18 height/0.9],'XTickLabel',{''},'Clipping','off','XLim',[0 930],'YLim',[-0.3 0.05],'YTick',[-0.3 -0.2  -0.1 0 0.2],'XTick',[0 100 200 300 400 500 600 700 800 900],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'FontSize',12,'FontName','Arial');
%ax2b = axes('Position',[left+width2+0.04 lower  width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+(width2+0.05)  lower width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.35 0],'YTick',[-0.3 -0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse OG post
ax3a = axes('Position',[left+width4-0.11  lower+delta+0.04 width3+0.18 height/0.9],'XTickLabel',{''},'Clipping','off','XLim',[0 35],'YLim',[0 0.25],'YTick',[0 0.1 0.2 0.3],'FontSize',12,'FontName','Arial');

%bar plots OG post
ax4a = axes('Position',[left+width4-0.11  lower width2+0.04 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[0 0.3],'YTick',[0 0.1 0.2 0.3],'FontSize',12,'FontName','Arial');
ax4b = axes('Position',[left+width4-0.11+(width2+0.09)  lower width2-0.04 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[0 0.3],'YTick',[0 0.1 0.2 0.3],'FontSize',12,'FontName','Arial');


hold(ax1)%control and small errors
l=get(ax1,'YLim');
patch(ax1,[51 65 65 51],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
patch(ax1,[91 105 105 91],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
plot(ax1,[50 50],[l(1) l(2)],'--k','Color',[0.6 0.6 0.6],'LineWidth',2)
%text(ax1,-100,l(2)+0.03,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,200,l(2),'Adaptation Errors','FontSize',14,'FontName','Arial')
for g=3:4
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
text(ax1,680,-0.10,'ControlTM','Color',colors(1,:),'FontName','Arial','FontSize',12,'FontWeight','bold')
text(ax1,680,-0.14,'AbruptTM','Color',colors(2,:),'FontName','Arial','FontSize',12,'FontWeight','bold')
plot(ax1,[200 300],[-0.32 -0.32],'k','LineWidth',2)
text(ax1,200,-0.25,'100 srides','FontName','Arial','FontSize',10);



hold(ax2a)
bar(ax2a,1,nanmean(TControlTM.maxError),'Edgecolor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2a,1,nanmean(TControlTM.maxError),nanstd(TControlTM.maxError)./sqrt(length(TControlTM.maxError)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TFullAbruptTM.maxError),'Edgecolor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2a,2,nanmean(TFullAbruptTM.maxError),nanstd(TFullAbruptTM.maxError)./sqrt(length(TFullAbruptTM.maxError)),...
    'Color','k','LineWidth',2)
plot(ax2a,[1 2],[-0.33 -0.33],'Color','k','LineWidth',2)
text(ax2a,0.5,0.03,'Max Error','FontSize',12,'FontName','Arial');



hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControlTM.netContributionNorm2_lateAdapt),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2c,1,nanmean(TControlTM.netContributionNorm2_lateAdapt),nanstd(TControlTM.netContributionNorm2_lateAdapt)./sqrt(length(TControlTM.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TFullAbruptTM.netContributionNorm2_lateAdapt),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2c,2,nanmean(TFullAbruptTM.netContributionNorm2_lateAdapt),nanstd(TFullAbruptTM.netContributionNorm2_lateAdapt)./sqrt(length(TFullAbruptTM.netContributionNorm2_lateAdapt)),...
    'Color','k','LineWidth',2)
text(ax2c,0.5,0.03,'Late Error','FontSize',12,'FontName','Arial');


hold(ax3a);%hold(ax3b);%hold(ax3c)
for g=3:4
    ns=size(TC{g}.prepertNet,1);
    if g<3
        dt1=TC{g}.OGpNet(:,1:20);
        dt4=TC{g}.OGpNet(:,26:35);
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        patch(ax3a,[26:35 fliplr(26:35)],[nanmean(dt4)+(nanstd(dt4)./sqrt(ns)) fliplr(nanmean(dt4)-(nanstd(dt4)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3b,[26:35 fliplr(26:35)],[nanmean(dt5)+(nanstd(dt5)./sqrt(ns)) fliplr(nanmean(dt5)-(nanstd(dt5)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3c,[26:35 fliplr(26:35)],[nanmean(dt6)+(nanstd(dt6)./sqrt(ns)) fliplr(nanmean(dt6)-(nanstd(dt6)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
                
        plot(ax3a,1:35,nanmean(TC{g}.OGpNet),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
        %plot(ax3b,1:35,nanmean(TC{g}.OGpSP),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
        %plot(ax3c,1:35,nanmean(TC{g}.OGpST),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    else
        dt1=TC{g}.TMpNet(:,1:20);
        dt2=TC{g}.TMpSP(:,1:20);
        dt3=TC{g}.TMpST(:,1:20);
        dt4=TC{g}.TMpNet(:,26:35);
        dt5=TC{g}.TMpSP(:,26:35);
        dt6=TC{g}.TMpST(:,26:35);
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        patch(ax3a,[26:35 fliplr(26:35)],[nanmean(dt4)+(nanstd(dt4)./sqrt(ns)) fliplr(nanmean(dt4)-(nanstd(dt4)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3b,[26:35 fliplr(26:35)],[nanmean(dt5)+(nanstd(dt5)./sqrt(ns)) fliplr(nanmean(dt5)-(nanstd(dt5)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3c,[26:35 fliplr(26:35)],[nanmean(dt6)+(nanstd(dt6)./sqrt(ns)) fliplr(nanmean(dt6)-(nanstd(dt6)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
                
        plot(ax3a,1:35,nanmean(TC{g}.TMpNet),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)  
        %plot(ax3b,1:35,nanmean(TC{g}.TMpSP),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)
        %plot(ax3c,1:35,nanmean(TC{g}.TMpST),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4) 
    end
end

% text(ax3c,2,0.26,'stepTime','FontSize',12,'FontName','Arial');
plot(ax3a,[26 35],[-0.01 -0.01],'k','LineWidth',2)
text(ax3a,26,-0.02,'10 srides','FontName','Arial','FontSize',10);


hold(ax4a)
bar(ax4a,1,nanmean(TControlTM.netContributionNorm2_TM_P),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,1,nanmean(TControlTM.netContributionNorm2_TM_P),nanstd(TControlTM.netContributionNorm2_TM_P)./sqrt(length(TControlTM.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,2,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,2,nanmean(TFullAbruptTM.netContributionNorm2_TM_P),nanstd(TFullAbruptTM.netContributionNorm2_TM_P)./sqrt(length(TFullAbruptTM.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,3,nanmean(TControlTM.netContributionNorm2_TM_LP),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,3,nanmean(TControlTM.netContributionNorm2_TM_LP),nanstd(TControlTM.netContributionNorm2_TM_LP)./sqrt(length(TControlTM.netContributionNorm2_TM_LP)),...
    'Color','k','LineWidth',2)
bar(ax4a,4,nanmean(TFullAbruptTM.netContributionNorm2_TM_LP),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4a,4,nanmean(TFullAbruptTM.netContributionNorm2_TM_LP),nanstd(TFullAbruptTM.netContributionNorm2_TM_LP)./sqrt(length(TFullAbruptTM.netContributionNorm2_TM_LP)),...
    'Color','k','LineWidth',2)

hold(ax4b)
bar(ax4b,1,nanmean(TControlTM.netContributionNorm2_deltaTM),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4b,1,nanmean(TControlTM.netContributionNorm2_deltaTM),nanstd(TControlTM.netContributionNorm2_deltaTM)./sqrt(length(TControlTM.netContributionNorm2_deltaTM)),...
    'Color','k','LineWidth',2)
bar(ax4b,2,nanmean(TFullAbruptTM.netContributionNorm2_deltaTM),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(ax4b,2,nanmean(TFullAbruptTM.netContributionNorm2_deltaTM),nanstd(TFullAbruptTM.netContributionNorm2_deltaTM)./sqrt(length(TFullAbruptTM.netContributionNorm2_deltaTM)),...
    'Color','k','LineWidth',2)
bar(ax4b,3,nanmean(TControl.netContributionNorm2_deltaOG),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax4b,3,nanmean(TControl.netContributionNorm2_deltaOG),nanstd(TControl.netContributionNorm2_deltaOG)./sqrt(length(TControl.netContributionNorm2_deltaOG)),...
    'Color','k','LineWidth',2)
bar(ax4b,4,nanmean(TFullAbrupt.netContributionNorm2_deltaOG),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax4b,4,nanmean(TFullAbrupt.netContributionNorm2_deltaOG),nanstd(TFullAbrupt.netContributionNorm2_deltaOG)./sqrt(length(TFullAbrupt.netContributionNorm2_deltaOG)),...
    'Color','k','LineWidth',2)



%ylabel(ax4a,'stepAsym')
text(ax3a,7,0.2,'TM post','FontSize',14,'FontName','Arial')
plot(ax4a,[1 3],[0.26 0.26],'-k','LineWidth',2)
plot(ax4a,[2 4],[0.24 0.24],'-k','LineWidth',2)
text(ax4a,1,0.18,'Early','FontSize',12,'FontName','Arial')
text(ax4a,3,0.18,'Late','FontSize',12,'FontName','Arial')
text(ax4b,1,0.18,'Delta','FontSize',12,'FontName','Arial')


set(gcf,'Renderer','painters');


f3=figure('Name','Experiment 1B');
set(f3,'Color',[1 1 1]','Units','inches','Position',[0 0 7 2.7])

%timeCourse re-Adaptation
ax1 = axes('Position',[left  lower+delta+0.04 width4-0.08 height/0.9],'XTickLabel',{''},'Clipping','off','XLim',[0 280],'YLim',[-0.3 0.05],'YTick',[-0.2 0 0.2],'XTick',[0 100 200],'FontSize',12,'FontName','Arial');
%Errors
ax2a = axes('Position',[left  lower width2*1.25 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.25 0],'YTick',[-0.2 -0.1 0],'FontSize',12,'FontName','Arial');
%ax2b = axes('Position',[left+width2+0.04  lower+2*delta+0.07 width2 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 4.5],'YLim',[-0.25 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');
ax2c = axes('Position',[left+(width2*1.2+0.08)  lower width2*1.25 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[-0.25 0],'YTick',[-0.2 -0.1 0],'YTickLabel',{''},'FontSize',12,'FontName','Arial');

%timeCourse TM post
ax3a = axes('Position',[left+width4-0.01  lower+delta+0.04 width3+0.08 height/0.9],'XTickLabel',{''},'Clipping','off','XLim',[0 20],'YLim',[0 0.1],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');

%bar plots TM post
ax4a = axes('Position',[left+width4-0.01  lower width3+0.08 height],'XTickLabel',{''},'Clipping','off','XLim',[0.5 2.5],'YLim',[0 0.1],'YTick',[0 0.1 0.2],'FontSize',12,'FontName','Arial');





hold(ax1)%control and small errors
text(ax1,50,l(2),'Re-adaptation Errors','FontSize',14,'FontName','Arial')
patch(ax1,[1 15 15 1],[l(1) l(1) l(2) l(2)],[1 1 1],'FaceAlpha',0,'EdgeColor','k');
for g=3:4
    ns=size(TC{g}.prepertNet,1);
    dt=TC{g}.readaptNet(:,1:280);
    if g<3        
        patch(ax1,[1:280 fliplr(1:280)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        plot(ax1,1:280,nanmean(dt),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
    else
       patch(ax1,[1:280 fliplr(1:280)],[nanmean(dt)+(nanstd(dt)./sqrt(ns)) fliplr(nanmean(dt)-(nanstd(dt)./sqrt(ns)))],colors(g,:),'FaceAlpha',0,'EdgeColor',colors(g,:));
       plot(ax1,1:280,nanmean(dt),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4) 
  
    end
    clear ns dt 
end
plot(ax1,[100 200],[-0.32 -0.32],'k','LineWidth',2)
text(ax1,100,-0.25,'100 srides','FontName','Arial','FontSize',10);
text(ax1,50,-0.075,'ControlTM','Color',colors(1,:),'FontName','Arial','FontSize',12,'FontWeight','bold')
text(ax1,50,-0.105,'AbruptTM','Color',colors(2,:),'FontName','Arial','FontSize',12,'FontWeight','bold')


hold(ax2a)
bar(ax2a,1,nanmean(TControlTM.maxErrorReadapt),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2a,1,nanmean(TControlTM.maxErrorReadapt),nanstd(TControlTM.maxErrorReadapt)./sqrt(length(TControlTM.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2a,2,nanmean(TFullAbruptTM.maxErrorReadapt),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2a,2,nanmean(TFullAbruptTM.maxErrorReadapt),nanstd(TFullAbruptTM.maxErrorReadapt)./sqrt(length(TFullAbruptTM.maxErrorReadapt)),...
    'Color','k','LineWidth',2)
text(ax2a,0.5,0.03,'Max Error','FontSize',12,'FontName','Arial');
plot(ax2a,[1 2],[-0.23 -0.23],'-k','LineWidth',2)



hold(ax2c)%control and small errors
bar(ax2c,1,nanmean(TControlTM.netContributionNorm2_lateReadapt),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2c,1,nanmean(TControlTM.netContributionNorm2_lateReadapt),nanstd(TControlTM.netContributionNorm2_lateReadapt)./sqrt(length(TControlTM.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)
bar(ax2c,2,nanmean(TFullAbruptTM.netContributionNorm2_lateReadapt),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax2c,2,nanmean(TFullAbruptTM.netContributionNorm2_lateReadapt),nanstd(TFullAbruptTM.netContributionNorm2_lateReadapt)./sqrt(length(TFullAbruptTM.netContributionNorm2_lateReadapt)),...
    'Color','k','LineWidth',2)


text(ax2c,0.5,0.03,'Late Error','FontSize',12,'FontName','Arial');



hold(ax3a);%hold(ax3b);%hold(ax3c)
for g=3:4
    ns=size(TC{g}.prepertNet,1);
    if g>2
        dt1=TC{g}.OGpNet(:,1:20);        
        dt4=TC{g}.OGpNet(:,26:35);       
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3a,[26:35 fliplr(26:35)],[nanmean(dt4)+(nanstd(dt4)./sqrt(ns)) fliplr(nanmean(dt4)-(nanstd(dt4)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3b,[26:35 fliplr(26:35)],[nanmean(dt5)+(nanstd(dt5)./sqrt(ns)) fliplr(nanmean(dt5)-(nanstd(dt5)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3c,[26:35 fliplr(26:35)],[nanmean(dt6)+(nanstd(dt6)./sqrt(ns)) fliplr(nanmean(dt6)-(nanstd(dt6)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
                
        plot(ax3a,1:20,nanmean(TC{g}.OGpNet(:,1:20)),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)  
        %plot(ax3b,1:35,nanmean(TC{g}.OGpSP),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)
        %plot(ax3c,1:35,nanmean(TC{g}.OGpST),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
    else
        dt1=TC{g}.TMpNet(:,1:20);
        dt4=TC{g}.TMpNet(:,26:35);
        patch(ax3a,[1:20 fliplr(1:20)],[nanmean(dt1)+(nanstd(dt1)./sqrt(ns)) fliplr(nanmean(dt1)-(nanstd(dt1)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3b,[1:20 fliplr(1:20)],[nanmean(dt2)+(nanstd(dt2)./sqrt(ns)) fliplr(nanmean(dt2)-(nanstd(dt2)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3c,[1:20 fliplr(1:20)],[nanmean(dt3)+(nanstd(dt3)./sqrt(ns)) fliplr(nanmean(dt3)-(nanstd(dt3)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3b,[26:35 fliplr(26:35)],[nanmean(dt4)+(nanstd(dt4)./sqrt(ns)) fliplr(nanmean(dt4)-(nanstd(dt4)./sqrt(ns)))],colors(g,:),'FaceAlpha',0.5,'LineStyle','none')
        %patch(ax3b,[26:35 fliplr(26:35)],[nanmean(dt5)+(nanstd(dt5)./sqrt(ns)) fliplr(nanmean(dt5)-(nanstd(dt5)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
        %patch(ax3c,[26:35 fliplr(26:35)],[nanmean(dt6)+(nanstd(dt6)./sqrt(ns)) fliplr(nanmean(dt6)-(nanstd(dt6)./sqrt(ns)))],[1 1 1],'FaceAlpha',0,'EdgeColor',colors(g,:))
                
        plot(ax3a,1:20,nanmean(TC{g}.TMpNet(:,1:20)),'ok','MarkerFaceColor',colors(g,:),'MarkerEdgeColor',colors2(g,:),'MarkerSize',4)  
        %plot(ax3b,1:35,nanmean(TC{g}.TMpSP),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4)
        %plot(ax3c,1:35,nanmean(TC{g}.TMpST),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',colors(g,:),'MarkerSize',4) 
    end
end

% text(ax3c,2,0.26,'stepTime','FontSize',12,'FontName','Arial');
text(ax3a,7,0.08,'OG post','FontSize',14,'FontName','Arial')
plot(ax3a,[10 20],[-0.01 -0.01],'k','LineWidth',2)
text(ax3a,10,-0.02,'10 srides','FontName','Arial','FontSize',10);
% 

hold(ax4a)
bar(ax4a,1,nanmean(TControlTM.netContributionNorm2_OG_P),'EdgeColor',[0.2 0.2 1],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax4a,1,nanmean(TControlTM.netContributionNorm2_OG_P),nanstd(TControlTM.netContributionNorm2_OG_P)./sqrt(length(TControlTM.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax4a,2,nanmean(TFullAbruptTM.netContributionNorm2_OG_P),'EdgeColor',[0.8 0 0],'FaceColor',[1 1 1],'BarWidth',0.5);
errorbar(ax4a,2,nanmean(TFullAbruptTM.netContributionNorm2_OG_P),nanstd(TFullAbruptTM.netContributionNorm2_OG_P)./sqrt(length(TFullAbruptTM.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)




set(gcf,'Renderer','painters');



