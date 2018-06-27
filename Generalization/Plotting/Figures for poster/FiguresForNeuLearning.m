%clear all
close all

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
ylabel(ax1,'Maximum Error Adaptation','FontWeight','Bold','FontSize',20)

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
ylabel(ax2,'After Effect Overground','FontWeight','Bold','FontSize',20)
ll=flipud(findobj(ax2,'Type','Bar'));
legend(ax2,ll,{'Control Large Error','Explicit Small Error','Implicit Small Error'},'Position',[0.75 0.80 0.17 0.16],'box','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Experiment 2: control, fullabrupt, catch %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize figure
f2=figure('Name','Experiment 2');
set(f2,'Color',[1 1 1]','Units','inches','Position',[0 0 12 5]);
ax1 = axes('Position',[0.1   0.15   0.45 0.73],'FontSize',16);
ax2 = axes('Position',[0.65  0.15   0.32 0.73],'FontSize',16);

%plot error size
hold(ax1)
bar(ax1,1,nanmean(TControl.maxError),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax1,1,nanmean(TControl.maxError),nanstd(TControl.maxError)./sqrt(length(TControl.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,2,nanmean(TFullAbrupt.maxError),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax1,2,nanmean(TFullAbrupt.maxError),nanstd(TFullAbrupt.maxError)./sqrt(length(TFullAbrupt.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,3,nanmean(TCatch.maxError),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax1,3,nanmean(TCatch.maxError),nanstd(TCatch.maxError)./sqrt(length(TCatch.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,4,nanmean(TCatch.netContributionNorm2_catch),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax1,4,nanmean(TCatch.netContributionNorm2_catch),nanstd(TCatch.netContributionNorm2_catch)./sqrt(length(TCatch.netContributionNorm2_catch)),...
    'Color','k','LineWidth',2)
bar(ax1,5,nanmean(TCatch.netContributionNorm2_resumeSplit),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax1,5,nanmean(TCatch.netContributionNorm2_resumeSplit),nanstd(TCatch.netContributionNorm2_resumeSplit)./sqrt(length(TCatch.netContributionNorm2_resumeSplit)),...
    'Color','k','LineWidth',2)
plot(ax1,[3.5 3.5],[-0.4 0.4],'--k','LineWidth',2,'Color',[0.5 0.5 0.5])
text(ax1,3.6,-0.05,'Catch Error','FontSize',14,'FontWeight','Bold')
text(ax1,4.6,0.05,'After Catch','FontSize',14,'FontWeight','Bold')
text(ax1,0.75,0.05,'Maximum Error Adaptation','FontSize',14,'FontWeight','Bold')

plot(ax1,[1 2],[-0.35 -0.35],'Color','k','LineWidth',2)
set(ax1,'XLim',[0.5 5.5],'XTickLabel',{''},'YTick',[-0.4 -0.2 0 0.2 0.4])
ylabel(ax1,'Error Adaptation','FontWeight','Bold','FontSize',20)

%plot OG after effects
hold(ax2)
bar(ax2,1,nanmean(TControl.netContributionNorm2_OG_P),'FaceColor',[0.2 0.2 1],'BarWidth',0.7);
errorbar(ax2,1,nanmean(TControl.netContributionNorm2_OG_P),nanstd(TControl.netContributionNorm2_OG_P)./sqrt(length(TControl.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax2,2,nanmean(TFullAbrupt.netContributionNorm2_OG_P),'FaceColor',[0.8 0 0],'BarWidth',0.7);
errorbar(ax2,2,nanmean(TFullAbrupt.netContributionNorm2_OG_P),nanstd(TFullAbrupt.netContributionNorm2_OG_P)./sqrt(length(TFullAbrupt.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(ax2,3,nanmean(TCatch.netContributionNorm2_OG_P),'FaceColor',[0.67 0.85 0.30],'BarWidth',0.7);
errorbar(ax2,3,nanmean(TCatch.netContributionNorm2_OG_P),nanstd(TCatch.netContributionNorm2_OG_P)./sqrt(length(TCatch.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
plot(ax2,[1 3],[0.125 0.125],'Color','k','LineWidth',2)
set(ax2,'XLim',[0.5 3.5],'XTickLabel',{''},'YLim',[0 0.15],'YTick',[0 0.05 0.1 0.15])
ylabel(ax2,'After Effect Overground','FontWeight','Bold','FontSize',20)
ll=flipud(findobj(ax2,'Type','Bar'));
legend(ax2,ll,{'Control','Abrupt Perturbation','Catch'},'Position',[0.80 0.80 0.17 0.16],'box','off')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Experiment 3: TMcontrol, TMFullAbrupt    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize figure
f3=figure('Name','Experiment 3');
set(f3,'Color',[1 1 1]','Units','inches','Position',[0 0 8 5])
ax1 = axes('Position',[0.1   0.15   0.35 0.73],'FontSize',16);
ax2 = axes('Position',[0.60   0.15   0.35 0.73],'FontSize',16);

%plot error size
hold(ax1)
bar(ax1,1,nanmean(TTMAbruptNoFeedback.maxError),'FaceColor',[0.1 0.5 0.8],'BarWidth',0.7);
errorbar(ax1,1,nanmean(TTMAbruptNoFeedback.maxError),nanstd(TTMAbruptNoFeedback.maxError)./sqrt(length(TTMAbruptNoFeedback.maxError)),...
    'Color','k','LineWidth',2)
bar(ax1,2,nanmean(TTMFullAbrupt.maxError),'FaceColor',[0.8 0.35 0.35],'BarWidth',0.7);
errorbar(ax1,2,nanmean(TTMFullAbrupt.maxError),nanstd(TTMFullAbrupt.maxError)./sqrt(length(TTMFullAbrupt.maxError)),...
    'Color','k','LineWidth',2)
plot(ax1,[1 2],[-0.29 -0.29],'Color','k','LineWidth',2)
set(ax1,'XLim',[0.5 2.5],'XTickLabel',{''},'YTick',[-0.3 -0.2 -0.1 0])
ylabel(ax1,'Maximum Error Adaptation','FontWeight','Bold','FontSize',20)

%plot TM after effects
hold(ax2)
bar(ax2,1,nanmean(TTMAbruptNoFeedback.netContributionNorm2_TM_P),'FaceColor',[0.1 0.5 0.8],'BarWidth',0.7);
errorbar(ax2,1,nanmean(TTMAbruptNoFeedback.netContributionNorm2_TM_P),nanstd(TTMAbruptNoFeedback.netContributionNorm2_TM_P)./sqrt(length(TTMAbruptNoFeedback.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
bar(ax2,2,nanmean(TTMFullAbrupt.netContributionNorm2_TM_P),'FaceColor',[0.8 0.35 0.35],'BarWidth',0.7);
errorbar(ax2,2,nanmean(TTMFullAbrupt.netContributionNorm2_TM_P),nanstd(TTMFullAbrupt.netContributionNorm2_TM_P)./sqrt(length(TTMFullAbrupt.netContributionNorm2_TM_P)),...
    'Color','k','LineWidth',2)
set(ax2,'XLim',[0.5 2.5],'XTickLabel',{''},'YLim',[0 0.30],'YTick',[0 0.1 0.2 0.3])
ylabel(ax2,'After Effect Treadmill','FontWeight','Bold','FontSize',20)
ll=flipud(findobj(ax2,'Type','Bar'));
legend(ax2,ll,{'Control','Abrupt Perturbation'},'Position',[0.75 0.80 0.17 0.16],'box','off')

%initialize figure
lower=0.07;
height=0.09;
width=0.95;
delta=height*1.45;
tied=1.125*ones(1,150);
washout=1.125*ones(1,100);
rampPert1=[linspace(1.125,1.5,40) 1.5*ones(1,860)];
rampPert2=[linspace(1.125,0.75,40) 0.75*ones(1,860)];
gradPert1=[linspace(1.125,1.5,600) 1.5*ones(1,300)];
gradPert2=[linspace(1.125,0.75,600) 0.75*ones(1,300)];
catchPert1=[linspace(1.125,1.5,40) 1.5*ones(1,559) NaN 1.125*ones(1,10) NaN 1.5*ones(1,289)];
catchPert2=[linspace(1.125,0.75,40) 0.75*ones(1,559) NaN 1.125*ones(1,10) NaN 0.75*ones(1,289)];
abruptPert1=[1.5*ones(1,900)];
abruptPert2=[0.75*ones(1,900)];
x1=1:100;
x2=101:250;
x3=251:1150;
x4=1151:1250;
ymax=1250;

f4=figure('Name','Adaptation Protocols');
set(f4,'Color',[1 1 1]','Units','inches','Position',[0 0 4 10])
ax1 = axes('Position',[0.025 lower+6*delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax2 = axes('Position',[0.025  lower+5*delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax3 = axes('Position',[0.025 lower+4*delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax4 = axes('Position',[0.025  lower+3*delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax5 = axes('Position',[0.025  lower+2*delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax6 = axes('Position',[0.025  lower+delta width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax7 = axes('Position',[0.025 lower width height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);

%gradual group
hold(ax1)
patch(ax1,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax1,[x3(end)-300:x3(end-286) fliplr(x3(end)-300:x3(end-286))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax1,[x2 x3],[tied gradPert1],'Color',[0.6 0 0.6],'LineWidth',3)
plot(ax1,[x2 x3],[tied gradPert2],'Color',[0.6 0 0.6],'LineWidth',3)
%plot(ax1,x4,washout,'Color',[0.6 0 0.6],'LineWidth',2)
text(ax1,150, 0.75,'Small Implicit','FontSize',12,'FontWeight','bold','Color',[0.6 0 0.6])
%plot(ax1,[x3],0.5*ones(1,150),'Color',[0 0 0],'LineWidth',4)
%plot(ax1,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)
%ll=findobj(ax1,'Type','Line');
%legend(ax1,ll(1:2),{'TM','OG'},'Position',[0.7925    0.9093    0.2826    0.05],'box','off','FontSize',12,'AutoUpdate','off')


%feedback group
hold(ax2)
patch(ax2,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax2,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax2,[x2 x3],[tied rampPert1],'Color',[0.6 0.6 0.6],'LineWidth',3)
plot(ax2,[x2 x3],[tied rampPert2],'Color',[0.6 0.6 0.6],'LineWidth',3)
%plot(ax2,x3,washout,'Color',[0.6 0.6 0.6],'LineWidth',2)
text(ax2,320, 1,'Small Explicit','FontSize',12,'FontWeight','bold','Color',[0.6 0.6 0.6])
%plot(ax2,[x3],0.5*ones(1,150),'Color',[0 0 0],'LineWidth',4)
%plot(ax2,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)
%text(ax2,1800,1.125,'EXP1','FontSize',12,'FontWeight','bold','Color',[0 0 0])

%control group
hold(ax3)
patch(ax3,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax3,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax3,[x2 x3],[tied rampPert1],'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax3,[x2 x3],[tied rampPert2],'Color',[0.2 0.2 1],'LineWidth',3)
%plot(ax3,x3,washout,'Color',[0.2 0.2 1],'LineWidth',2)
text(ax3,320, 1,'Control','FontSize',12,'FontWeight','bold','Color',[0.2 0.2 1])
%plot(ax3,[x3],0.5*ones(1,150),'Color',[0 0 0],'LineWidth',4)
%plot(ax3,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)

%full abrupt
hold(ax4)
patch(ax4,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax4,[x3(2):x3(16) fliplr(x3(2):x3(16))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax4,[x2],[tied],'Color',[0.8 0 0],'LineWidth',2)
plot(ax4,[x3],[abruptPert1],'Color',[0.8 0 0],'LineWidth',3)
plot(ax4,[x3],[abruptPert2],'Color',[0.8 0 0],'LineWidth',3)
%plot(ax4,x3,washout,'Color',[0.8 0 0],'LineWidth',2)
text(ax4,320, 1,'Abrupt Perturbation','FontSize',12,'FontWeight','bold','Color',[0.8 0 0])
%plot(ax4,[x3],0.5*ones(1,150),'Color',[0 0 0],'LineWidth',4)
%plot(ax4,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)
%text(ax4,1800,1.125,'EXP2','FontSize',12,'FontWeight','bold','Color',[0 0 0])

%catch group
hold(ax5)
patch(ax5,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax5,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax5,[x2 x3],[tied catchPert1],'Color',[0.67 0.85 0.30],'LineWidth',3)
plot(ax5,[x2 x3],[tied catchPert2],'Color',[0.67 0.85 0.30],'LineWidth',3)
%plot(ax5,x3,washout,'Color',[0.67 0.85 0.30],'LineWidth',2)
text(ax5,320, 1,'Catch','FontSize',12,'FontWeight','bold','Color',[0.67 0.85 0.30])
%plot(ax5,[x3],0.5*ones(1,150),'Color',[0 0 0],'LineWidth',4)
%plot(ax5,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)

%control group treadmill
hold(ax6)
patch(ax6,[[x2 x3 x4],fliplr([x2 x3 x4])],[0.5*ones(1,length([x2 x3 x4])) 1.75*ones(1,length([x2 x3 x4]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax6,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax6,[x2 x3],[tied rampPert1],'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax6,[x2 x3],[tied rampPert2],'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax6,x4,washout,'Color',[0.2 0.2 1],'LineWidth',3)
text(ax6,320, 1,'Control','FontSize',12,'FontWeight','bold','Color',[0.2 0.2 1])
%plot(ax6,[x3],0.5*ones(1,150),'Color',[0.5 0.5 0.5],'LineWidth',4)
%plot(ax6,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)

%full abrupt treadmill
hold(ax7)
patch(ax7,[[x2 x3 x4],fliplr([x2 x3 x4])],[0.5*ones(1,length([x2 x3 x4])) 1.75*ones(1,length([x2 x3 x4]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax7,[x3(2):x3(16) fliplr(x3(2):x3(16))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax7,[x2],[tied],'Color',[0.8 0 0],'LineWidth',2)
plot(ax7,[x3],[abruptPert1],'Color',[0.8 0 0],'LineWidth',3)
plot(ax7,[x3],[abruptPert2],'Color',[0.8 0 0],'LineWidth',3)
plot(ax7,x4,washout,'Color',[0.8 0 0],'LineWidth',3)
text(ax7,320, 1,'Abrupt Perturbation','FontSize',12,'FontWeight','bold','Color',[0.8 0 0])
%plot(ax7,[x3],0.5*ones(1,150),'Color',[0.5 0.5 0.5],'LineWidth',4)
%plot(ax7,[x1 x2],0.5*ones(1,950),'Color',[0.5 0.5 0.5],'LineWidth',4)
%text(ax7,1800,2,'EXP3','FontSize',12,'FontWeight','bold','Color',[0 0 0])
% 
% 
%  annotation(f4,'textbox',[0.03225 0.607343192248847 0.9 0.376338602753693],...
%     'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle',':','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);
%  annotation(f4,'textbox',[0.03225 0.342682304946456 0.9 0.376338602753697],...
%      'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);
%  annotation(f4,'textbox',[0.03225 0.0780214176440559 0.9 0.252422233554312],...
%      'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','-.','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);

% annotation(f4,'textbox',[0.03225 0.607343192248847 0.804555555555555 0.376338602753693],...
%     'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle',':','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);
% annotation(f4,'textbox',[0.03225 0.342682304946456 0.804555555555555 0.376338602753697],...
%     'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);
% annotation(f4,'textbox',[0.03225 0.0780214176440559 0.804555555555555 0.252422233554312],...
%     'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','-.','FitBoxToText','off','EdgeColor',[0.65 0.65 0.65]);
annotation(f4,'arrow',[0.545138888888889 0.588541666666667],[0.437041815400306 0.391636919938807]);
annotation(f4,'arrow',[0.745659722222222 0.619791666666667],[0.438041815400306 0.409994900560938]);
annotation(f4,'textbox',[0.4317    0.4330    0.0926    0.0408],...
    'String',{'catch (tied)'},'LineStyle','none');
annotation(f4,'textbox',[0.7286    0.4330    0.1458    0.0408],...
    'String','after catch','LineStyle','none','FitBoxToText','off');
