%clear all
%close all

%%%%%%%%%%%%%%%%%%%
%% Extract data %%
%%%%%%%%%%%%%%%%%%

%make sure all groups are defined
%GenerateParamsTable;

%Create separate table for each group
TControl=T(T.group=='AbruptNoFeedback',:);
TFeedback=T(T.group=='AbruptFeedback',:);
TGradual=T(T.group=='Gradual',:);
TFullAbrupt=T(T.group=='FullAbrupt',:);
TCatch=T(T.group=='Catch',:);
TTMFullAbrupt=T(T.group=='TMFullAbrupt',:);
TTMAbruptNoFeedback=T(T.group=='TMAbruptNoFeedback',:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Experiment 1: control, feedback, gradual %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize figure
f1=figure('Name','Experiment 1');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 10 5])
ax1 = axes('Position',[0.1   0.15   0.35 0.73],'FontSize',16);
ax2 = axes('Position',[0.55   0.15   0.35 0.73],'FontSize',16);

%plot error size
hold(ax1)
bar(ax1,1,nanmean(TControl.maxError),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax1,1,nanmean(TControl.maxError),nanstd(TControl.maxError)./sqrt(length(TControl.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,2,nanmean(TFeedback.maxError),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax1,2,nanmean(TFeedback.maxError),nanstd(TFeedback.maxError)./sqrt(length(TFeedback.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,3,nanmean(TGradual.maxError),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax1,3,nanmean(TGradual.maxError),nanstd(TGradual.maxError)./sqrt(length(TGradual.maxError)),...
    'Color','k','LineWidth',2)
plot(ax1,[1 2],[-0.175 -0.175],'Color','k','LineWidth',2)
plot(ax1,[1 3],[-0.18 -0.18],'Color','k','LineWidth',2)
set(ax1,'XLim',[0.5 3.5],'XTickLabel',{''},'YTick',[-0.2 -0.1 0])
ylabel(ax1,'Maximum Error','FontWeight','Bold','FontSize',20)

%plot OG after effects
hold(ax2)
bar(ax2,1,nanmean(TControl.netContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2,1,nanmean(TControl.netContributionNorm2_OG_P),nanstd(TControl.netContributionNorm2_OG_P)./sqrt(length(TControl.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax2,2,nanmean(TFeedback.netContributionNorm2_OG_P),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(ax2,2,nanmean(TFeedback.netContributionNorm2_OG_P),nanstd(TFeedback.netContributionNorm2_OG_P)./sqrt(length(TFeedback.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax2,3,nanmean(TGradual.netContributionNorm2_OG_P),'FaceColor',[0.6 0 0.6],'BarWidth',0.7);
errorbar(ax2,3,nanmean(TGradual.netContributionNorm2_OG_P),nanstd(TGradual.netContributionNorm2_OG_P)./sqrt(length(TGradual.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
plot(ax2,[1 2],[0.12 0.12],'Color','k','LineWidth',2)
plot(ax2,[1 3],[0.125 0.125],'Color','k','LineWidth',2)
set(ax2,'XLim',[0.5 3.5],'XTickLabel',{''},'YLim',[0 0.15],'YTick',[0 0.05 0.1 0.15])
ylabel(ax2,'Step Asymmetry','FontWeight','Bold','FontSize',20)
ll=flipud(findobj(ax2,'Type','Bar'));
legend(ax2,ll,{'Control Large Error','Explicit Small Error','Implicit Small Error'},'Position',[0.75 0.80 0.17 0.16],'box','off')




