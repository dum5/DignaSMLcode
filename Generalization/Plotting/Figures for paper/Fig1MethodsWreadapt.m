clear all
close all


%initialize figure
f1=figure('Name','Adaptation Protocols');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 7 7])
lower=0.1;%position of bottom axes
height=0.20;%height of axes
width=0.95;
width2=0.47;
delta=height*1.5;
ymax=1650;
tiedcol=[0.7 0.7 0.7];
splitcol=[0.4 0.4 0.4];
GeneralizationColorMap;

ax(1) = axes('Position',[0.025  lower+2*delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax(2) = axes('Position',[0.025+width2*1.05  lower+2* delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax(3) = axes('Position',[0.025  lower+delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax(4) = axes('Position',[0.025+width2*1.05  lower+delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax(5) = axes('Position',[0.025  lower width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax(6) = axes('Position',[0.025+width2*1.05  lower width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);

%generate data for timecourses
tied=1.125*ones(1,150);
washout=1.125*ones(1,100);
rampPert1=[linspace(1.125,1.5,40) 1.5*ones(1,860)];
rampPert2=[linspace(1.125,0.75,40) 0.75*ones(1,860)];
gradPert1=[linspace(1.125,1.5,600) 1.5*ones(1,300)];
gradPert2=[linspace(1.125,0.75,600) 0.75*ones(1,300)];
catchPert1=[linspace(1.125,1.5,40) 1.5*ones(1,559) NaN 1.125*ones(1,10) NaN 1.5*ones(1,289)];
catchPert2=[linspace(1.125,0.75,40) 0.75*ones(1,559) NaN 1.125*ones(1,10) NaN 0.75*ones(1,289)];
gCatchPert1=[linspace(1.125,1.5,600) 1.5*ones(1,149) NaN 1.125*ones(1,10) NaN 1.5*ones(1,139)];%check
gCatchPert2=[linspace(1.125,0.75,600) 0.75*ones(1,149) NaN 1.125*ones(1,10) NaN 0.75*ones(1,139)];%ceck
readap1=1.5*ones(1,300);
readap2=0.75*ones(1,300);

abruptPert1=[nan 1.5*ones(1,899)];
abruptPert2=[nan 0.75*ones(1,899)];
x1=1:100; %OG
x2=101:250; %TM tied
x3=251:1150; %TM split
x4=1151:1250; %after effects
x5=1251:1550;
x6=1551:1650;
offset=0.04;

%plot patches
for a=1:6
    hold(ax(a))
%     patch(ax(a),[x2(1),x2(end),x2(end),x2(1)],[1.75 1.75 0.5 0.5],tiedcol,'FaceAlpha',0.5,'LineStyle','none')
%     patch(ax(a),[x3(1),x3(end),x3(end),x3(1)],[1.75 1.75 0.5 0.5],splitcol,'FaceAlpha',0.5,'LineStyle','none')
%     if a==4
%         patch(ax(a),[x4(1),x4(end),x4(end),x4(1)],[1.75 1.75 0.5 0.5],tiedcol,'FaceAlpha',0.5,'LineStyle','none')
%     
%     end
end


%control and feedback
text(ax(1),x3(1)+150,2.2,'A Experiment 1','FontSize',14,'FontName','Arial','FontWeight','Bold')
text(ax(1),-10,1.9,'OGB','FontSize',10,'FontName','Arial')
text(ax(1),x2(20),1.9,'TMB','FontSize',10,'FontName','Arial')
text(ax(1),mean(x3)*0.75,1.9,'Adap1')
text(ax(1),x4(1),1.9,'OGP','FontSize',10,'FontName','Arial')
text(ax(1),x5(1)+75,1.9,'Adap2')
text(ax(1),x6(1),1.9,'TMP','FontSize',10,'FontName','Arial')

plot(ax(1),[100,200],[0.55 0.55],'-k','LineWidth',2)
text(ax(1),100,0.6,'100 strides')
plot(ax(1),[x2,x3],[tied,rampPert1],'Color',ColControl,'LineWidth',3)
plot(ax(1),[x2,x3],[tied,rampPert2],'Color',ColControl,'LineWidth',3)
plot(ax(1),[x2,x3],[tied,rampPert1]+offset,'Color',ColFeedback,'LineWidth',3)
plot(ax(1),[x2,x3],[tied,rampPert2]+offset,'Color',ColFeedback,'LineWidth',3)

plot(ax(1),[x5],readap1,'Color',ColControl,'LineWidth',3)
plot(ax(1),[x5],readap2,'Color',ColControl,'LineWidth',3)
plot(ax(1),[x6],washout,'Color',ColControl,'LineWidth',3)

plot(ax(1),[x5],readap1+offset,'Color',ColFeedback,'LineWidth',3)
plot(ax(1),[x5],readap2+offset,'Color',ColFeedback,'LineWidth',3)
plot(ax(1),[x6],washout+offset,'Color',ColFeedback,'LineWidth',3)

text(ax(1),320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',ColControl,'FontWeight','bold')
text(ax(1),320, 1,'Small Explicit','FontSize',12,'FontName','Arial','Color',ColFeedback,'FontWeight','bold')

% gradual
text(ax(2),-10,1.9,'OGB','FontSize',10,'FontName','Arial')
text(ax(2),x2(20),1.9,'TMB','FontSize',10,'FontName','Arial')
text(ax(2),mean(x3)*0.75,1.9,'Adap1')
text(ax(2),x4(1),1.9,'OGP','FontSize',10,'FontName','Arial')
text(ax(2),x5(1)+75,1.9,'Adap2')
text(ax(2),x6(1),1.9,'TMP','FontSize',10,'FontName','Arial')

plot(ax(2),[x2,x3],[tied,gradPert1],'Color',ColGradual,'LineWidth',3)
plot(ax(2),[x2,x3],[tied,gradPert2],'Color',ColGradual,'LineWidth',3)

text(ax(2),400, 1.125,'Small Implicit','FontSize',12,'FontName','Arial','Color',[0.6 0 0.6],'FontWeight','bold')

%control and full abrupt
text(ax(3),x3(1)+150,2,'B Experiment 2','FontSize',14,'FontName','Arial','FontWeight','Bold')

plot(ax(3),[x2,x3],[tied,rampPert1],'Color',ColControl,'LineWidth',3)
plot(ax(3),[x2,x3],[tied,rampPert2],'Color',ColControl,'LineWidth',3)
plot(ax(3),[x2,x3],[tied,abruptPert1]+offset,'Color',ColFullAbrupt,'LineWidth',3)
plot(ax(3),[x2,x3],[tied,abruptPert2]+offset,'Color',ColFullAbrupt,'LineWidth',3)

plot(ax(3),[x5],readap1,'Color',ColControl,'LineWidth',3)
plot(ax(3),[x5],readap2,'Color',ColControl,'LineWidth',3)
plot(ax(3),[x6],washout,'Color',ColControl,'LineWidth',3)

plot(ax(3),[x5],readap1+offset,'Color',ColFullAbrupt,'LineWidth',3)
plot(ax(3),[x5],readap2+offset,'Color',ColFullAbrupt,'LineWidth',3)
plot(ax(3),[x6],washout+offset,'Color',ColFullAbrupt,'LineWidth',3)

text(ax(3),320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',ColControl,'FontWeight','bold')
text(ax(3),320, 1,'Abrupt','FontSize',12,'FontName','Arial','Color',ColFullAbrupt,'FontWeight','bold')


%control and full abrupt with TM after effects
plot(ax(4),[x2,x3],[tied,rampPert1],'Color',ColControl,'LineWidth',3,'LineStyle',':')
plot(ax(4),[x2,x3],[tied,rampPert2],'Color',ColControl,'LineWidth',3,'LineStyle',':')
plot(ax(4),[x2,x3],[tied,abruptPert1]+offset,'Color',ColFullAbrupt,'LineWidth',3,'LineStyle',':')
plot(ax(4),[x2,x3],[tied,abruptPert2]+offset,'Color',ColFullAbrupt,'LineWidth',3,'LineStyle',':')
text(ax(4),x4(1),1.9,'TMP','FontSize',10,'FontName','Arial')
text(ax(4),x6(1),1.9,'OGP','FontSize',10,'FontName','Arial')

plot(ax(4),[x5],readap1,'Color',ColControl,'LineWidth',3,'LineStyle',':')
plot(ax(4),[x5],readap2,'Color',ColControl,'LineWidth',3,'LineStyle',':')

plot(ax(4),[x5],readap1+offset,'Color',ColFullAbrupt,'LineWidth',3,'LineStyle',':')
plot(ax(4),[x5],readap2+offset,'Color',ColFullAbrupt,'LineWidth',3,'LineStyle',':')

text(ax(4),320, 1.25,'ControlTM','FontSize',12,'FontName','Arial','Color',ColControl,'FontWeight','bold')
text(ax(4),320, 1,'AbruptTM','FontSize',12,'FontName','Arial','Color',ColFullAbrupt,'FontWeight','bold')


%control catch
text(ax(5),x3(1)+150,2,'C Experiment 3','FontSize',14,'FontName','Arial','FontWeight','Bold')
text(ax(5),x3(1)+150,0.2,'D Visual Feedback','FontSize',14,'FontName','Arial','FontWeight','Bold')

plot(ax(5),[x2,x3],[tied,rampPert1],'Color',ColControl,'LineWidth',3)
plot(ax(5),[x2,x3],[tied,rampPert2],'Color',ColControl,'LineWidth',3)
plot(ax(5),[x2,x3],[tied,catchPert1]+offset,'Color',ColCatch,'LineWidth',3)
plot(ax(5),[x2,x3],[tied,catchPert2]+offset,'Color',ColCatch,'LineWidth',3)

plot(ax(5),[x5],readap1,'Color',ColControl,'LineWidth',3)
plot(ax(5),[x5],readap2,'Color',ColControl,'LineWidth',3)
plot(ax(5),[x6],washout,'Color',ColControl,'LineWidth',3)

plot(ax(5),[x5],readap1+offset,'Color',ColCatch,'LineWidth',3)
plot(ax(5),[x5],readap2+offset,'Color',ColCatch,'LineWidth',3)
plot(ax(5),[x6],washout+offset,'Color',ColCatch,'LineWidth',3)

text(ax(5),320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',ColControl,'FontWeight','bold')
text(ax(5),320, 1,'Catch','FontSize',12,'FontName','Arial','Color',ColCatch,'FontWeight','bold')

plot(ax(5),[x2(1) x2(1)],[0.5 5.55],'--k')
plot(ax(5),[x3(1) x3(1)],[0.5 5.55],'--k')
plot(ax(5),[x4(1) x4(1)],[0.5 5.55],'--k')
plot(ax(5),[x5(1) x5(1)],[0.5 5.55],'--k')
plot(ax(5),[x6(1) x6(1)],[0.5 5.55],'--k')

plot(ax(6),[x2(1) x2(1)],[0.5 5.55],'--k')
plot(ax(6),[x3(1) x3(1)],[0.5 5.55],'--k')
plot(ax(6),[x4(1) x4(1)],[0.5 5.55],'--k')
plot(ax(6),[x5(1) x5(1)],[0.5 5.55],'--k')
plot(ax(6),[x6(1) x6(1)],[0.5 5.55],'--k')

text(ax(5),x3(420),1.65,'Catch','FontSize',10,'FontName','Arial')
text(ax(5),x3(700),1.2,['After Catch'],'FontSize',10,'FontName','Arial')

%gradual and catch gradual
plot(ax(6),[x2,x3],[tied,gradPert1],'Color',ColGradual,'LineWidth',3,'LineStyle',':')
plot(ax(6),[x2,x3],[tied,gradPert2],'Color',ColGradual,'LineWidth',3,'LineStyle',':')
plot(ax(6),[x2,x3],[tied,gCatchPert1]+offset,'Color',ColCatch,'LineWidth',3,'LineStyle',':')
plot(ax(6),[x2,x3],[tied,gCatchPert2]+offset,'Color',ColCatch,'LineWidth',3,'LineStyle',':')

text(ax(6),x3(1), 1.6,'Small Implicit','FontSize',12,'FontName','Arial','Color',ColGradual,'FontWeight','bold')
text(ax(6),x3(1), 0.7,'Small Catch','FontSize',12,'FontName','Arial','Color',ColCatch,'FontWeight','bold')

text(ax(6),x3(420),1.65,'Catch','FontSize',10,'FontName','Arial')
text(ax(6),x3(700),1.2,['After Catch'],'FontSize',10,'FontName','Arial')


set(gcf,'Renderer','painters');