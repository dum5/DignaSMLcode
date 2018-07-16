clear all
close all

%initialize figure
f1=figure('Name','Adaptation Protocols');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 7 7])
lower=0.1;%position of bottom axes
height=0.16;%height of axes
width=0.95;
width2=0.44;
delta=height*1.4;
ymax=1250;

ax1 = axes('Position',[0.025  lower+3*delta+0.05 width height*0.8],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 2400],'YLim',[0 1],'YTick',[-10 10000],'XTick',[-10 10000]);
ax2a = axes('Position',[0.025  lower+2*delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax2b = axes('Position',[0.025+width2*1.1  lower+2*delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax3a = axes('Position',[0.025  lower+delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax3b = axes('Position',[0.025+width2*1.1  lower+delta width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax4a = axes('Position',[0.025  lower width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);
ax4b = axes('Position',[0.025+width2*1.1  lower width2 height],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 ymax],'YLim',[0.5 1.75],'YTick',[0 100]);

%generate data for timecourses
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


hold(ax1)
patch(ax1,[1801 2100 2100 1801],[0 0 1 1],[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'LineWidth',2)
patch(ax1,[1 300 300 1],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[301 600 600 301],[0 0 1 1],[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[601 1500 1500 601],[0 0 1 1],[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'LineWidth',2)
patch(ax1,[1501 1800 1800 1501],[0 0 0.5 0.5],[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[1501 1800 1800 1501],[0.5 0.5 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[2101 2400 2400 2101],[0.5 0.5 1 1],[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[2101 2400 2400 2100],[0 0 0.5 0.5],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
text(ax1,10,0.5,'OG BASE','FontSize',12,'FontName','Arial')
text(ax1,310,0.5,'TM BASE','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,810,0.5,'ADAPTATION','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,1510,0.75,'OG POST','FontSize',12,'FontName','Arial')
text(ax1,1510,0.25,'TM POST','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,1810,0.6,'RE-ADAP-','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,1810,0.4,'TATION','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,2110,0.25,'OG POST','FontSize',12,'FontName','Arial')
text(ax1,2110,0.75,'TM POST','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,0,1.2,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,800,1.2,'OVERALL PARADIGM','FontSize',16,'FontName','Arial')

%control and feedback
hold(ax2a)

text(ax2a,0,2.4,'B','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax2a,825,2.4,'ADAPTATION PROFILES','FontSize',16,'FontName','Arial')
text(ax2a,0,2,'EXPERIMENT 1','FontSize',14,'FontName','Arial','FontWeight','Bold')

l1a=[tied,rampPert1];
l1b=[tied,rampPert2];
pat1=[ones(1,15) nan(1,15)];pat1=repmat(pat1,1,35);
pat2=[nan(1,15) ones(1,15)];pat2=repmat(pat2,1,35);
l2a=l1a.*pat1;l2b=l1b.*pat1;%for controls
l1a=l1a.*pat2;l1b=l1b.*pat2;%for feedback


patch(ax2a,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax2a,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax2a,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax2a,[x2,x3],l2a,'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax2a,[x2,x3],l2b,'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax2a,[x2,x3],l1a,'Color',[0.6 0.6 0.6],'LineWidth',3)
plot(ax2a,[x2,x3],l1b,'Color',[0.6 0.6 0.6],'LineWidth',3)
text(ax2a,320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',[0.2 0.2 1],'FontWeight','bold')
text(ax2a,320, 1,'Small Explicit','FontSize',12,'FontName','Arial','Color',[0.6 0.6 0.6],'FontWeight','bold')

% gradual
hold (ax2b)
l1a=[tied,gradPert1];
l1b=[tied,gradPert2];
patch(ax2b,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax2b,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax2b,[x3(end)-300:x3(end-286) fliplr(x3(end)-300:x3(end-286))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax2b,[x2,x3],l1a,'Color',[0.6 0 0.6],'LineWidth',3)
plot(ax2b,[x2,x3],l1b,'Color',[0.6 0 0.6],'LineWidth',3)
%plot(ax2b,x4,washout,'Color',[0.6 0 0.6],'LineWidth',3)
text(ax2b,400, 1.125,'Small Implicit','FontSize',12,'FontName','Arial','Color',[0.6 0 0.6],'FontWeight','bold')

%control and full abrupt
hold(ax3a)
text(ax3a,0,2,'EXPERIMENT 2','FontSize',14,'FontName','Arial','FontWeight','Bold')
l1a=[tied,rampPert1];%control
l1b=[tied,rampPert2];
l2a=[tied(1:end-1),NaN,abruptPert1];%abrupt
l2b=[tied(1:end-1),NaN,abruptPert2];
pat1(150:191)=1;pat2(150:191)=1;
l1a=l1a.*pat2;l1b=l1b.*pat2;
l2a=l2a.*pat1;l2b=l2b.*pat1;%for controls

patch(ax3a,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax3a,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax3a,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0])
patch(ax3a,[x3(1:15) fliplr(x3(1:15))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax3a,[x2,x3],l1a,'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax3a,[x2,x3],l1b,'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax3a,[x2,x3],l2a,'Color',[0.8 0 0],'LineWidth',3)
plot(ax3a,[x2,x3],l2b,'Color',[0.8 0 0],'LineWidth',3)
text(ax3a,320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',[0.2 0.2 1],'FontWeight','bold')
text(ax3a,320, 1,'Abrupt','FontSize',12,'FontName','Arial','Color',[0.8 0 0],'FontWeight','bold')


%control and full abrupt
idx1=[1:15,31:45,61:75,91:100];
idx2=[16:30,46:60,76:90];
w1=washout;w1(idx1)=NaN;
w2=washout;w2(idx2)=NaN;

hold(ax3b)
patch(ax3b,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax3b,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax3b,[[x4],fliplr([x4])],[0.5*ones(1,length([x4])) 1.75*ones(1,length([x4]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax3b,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0])
patch(ax3b,[x3(1:15) fliplr(x3(1:15))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax3b,[x2,x3],l1a+0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x2,x3],l1a-0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x2,x3],l1b+0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x2,x3],l1b-0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x4],w1+0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x4],w1-0.02,'Color',[0.2 0.2 1],'LineWidth',1)
plot(ax3b,[x2,x3],l2a+0.02,'Color',[0.8 0 0],'LineWidth',1)
plot(ax3b,[x2,x3],l2a-0.02,'Color',[0.8 0 0],'LineWidth',1)
plot(ax3b,[x2,x3],l2b+0.02,'Color',[0.8 0 0],'LineWidth',1)
plot(ax3b,[x2,x3],l2b-0.02,'Color',[0.8 0 0],'LineWidth',1)
plot(ax3b,[x4],w2+0.02,'Color',[0.8 0 0],'LineWidth',1)
plot(ax3b,[x4],w2-0.02,'Color',[0.8 0 0],'LineWidth',1)
text(ax3b,320, 1.25,'Control','FontSize',12,'FontName','Arial','Color',[0.2 0.2 1],'FontWeight','bold')
text(ax3b,320, 1,'Abrupt','FontSize',12,'FontName','Arial','Color',[0.8 0 0],'FontWeight','bold')

%control and catch
hold(ax4a)
text(ax4a,0,2,'EXPERIMENT 3','FontSize',14,'FontName','Arial','FontWeight','Bold')
patch(ax4a,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax4a,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax4a,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax4a,[x2,x3],[tied,rampPert1],'Color',[0.2 0.2 1],'LineWidth',3)
plot(ax4a,[x2,x3],[tied,rampPert2],'Color',[0.2 0.2 1],'LineWidth',3)
text(ax4a,320, 1.125,'Control','FontSize',12,'FontName','Arial','Color',[0.2 0.2 1],'FontWeight','bold')

hold(ax4b)
patch(ax4b,[[x2 x3],fliplr([x2 x3])],[0.5*ones(1,length([x2 x3])) 1.75*ones(1,length([x2 x3]))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none')
patch(ax4b,[[x2],fliplr([x2])],[0.5*ones(1,length([x2])) 1.75*ones(1,length([x2]))],[0 0 0],'FaceAlpha',1,'LineStyle','none')
patch(ax4b,[x3(end)-860:x3(end-846) fliplr(x3(end)-860:x3(end-846))],[0.5*ones(1,15) 1.75*(ones(1,15))],[0.9 0.9 0.9],'EdgeColor',[0 0 0]) 
plot(ax4b,[x2,x3],[tied,catchPert1],'Color',[0.67 0.85 0.30],'LineWidth',3)
plot(ax4b,[x2,x3],[tied,catchPert2],'Color',[0.67 0.85 0.30],'LineWidth',3)
text(ax4b,320, 1.125,'Catch','FontSize',12,'FontName','Arial','Color',[0.67 0.85 0.30],'FontWeight','bold')

annotation(f1,'textbox',[0.70 0.25 0.07 0.01],'String',{'Catch'},...
    'LineStyle','none','FontSize',12,'FontName','Arial','FitBoxToText','off');
annotation(f1,'textbox',[0.83 0.21 0.07 0.01],'String',['After',newline,'Catch'],...
    'LineStyle','none','FontSize',12,'FontName','Arial','FitBoxToText','off');
annotation(f1,'textbox',[0.66 0.71 0.07 0.01],'String',['Max',newline,'Error'],...
    'LineStyle','none','FontSize',12,'FontName','Arial','FitBoxToText','off');
annotation(f1,'arrow',[0.769345222255162 0.806547650049603],[0.236613979271515 0.180010198878123]);
annotation(f1,'arrow',[0.83779764900813 0.811011901855469],[0.206017351126197 0.230494647534267]);
annotation(f1,'arrow',[0.74 0.81],[0.69 0.69]);

set(gcf,'Renderer','painters');