clear all
close all

f1=figure('Name','Adaptation Protocols');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 7 7])
lower=0.1;%position of bottom axes
height=0.16;%height of axes
width=0.95;
width2=0.44;
delta=height*1.4;
ymax=1250;

ax1 = axes('Position',[0.025  lower+3*delta+0.05 width height*0.8],'XTickLabel',{''},'YTickLabel',{''},'Clipping','off','XLim',[0 2400],'YLim',[0 1],'YTick',[-10 10000],'XTick',[-10 10000]);

hold(ax1)
patch(ax1,[1801 2100 2100 1801],[0 0 1 1],[0.5 0.5 0.5],'EdgeColor',[0 0 0],'LineWidth',2)
patch(ax1,[1 300 300 1],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
hs=patch(ax1,[301 600 600 301],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
hatchfill2(hs);
patch(ax1,[601 1500 1500 601],[0 0 1 1],[0.5 0.5 0.5],'EdgeColor',[0 0 0],'LineWidth',2)
hs=patch(ax1,[1501 1800 1800 1501],[0 0 0.5 0.5],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
hatchfill2(hs)
patch(ax1,[1501 1800 1800 1501],[0.5 0.5 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
hs=patch(ax1,[2101 2400 2400 2101],[0.5 0.5 1 1],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
hatchfill2(hs)
patch(ax1,[2101 2400 2400 2100],[0 0 0.5 0.5],[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
text(ax1,10,0.5,'OG BASE','FontSize',12,'FontName','Arial')
text(ax1,310,0.5,'TM BASE','FontSize',12,'FontName','Arial','Color',[0 0 0])
text(ax1,810,0.5,'ADAPTATION','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,1510,0.75,'OG POST','FontSize',12,'FontName','Arial')
text(ax1,1510,0.25,'TM POST','FontSize',12,'FontName','Arial','Color',[0 0 0])
text(ax1,1810,0.6,'RE-ADAP-','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,1810,0.4,'TATION','FontSize',12,'FontName','Arial','Color',[1 1 1])
text(ax1,2110,0.25,'OG POST','FontSize',12,'FontName','Arial')
text(ax1,2110,0.75,'TM POST','FontSize',12,'FontName','Arial','Color',[0 0 0])
text(ax1,0,1.2,'A','FontSize',20,'FontName','Arial','FontWeight','Bold')
text(ax1,800,1.2,'OVERALL PARADIGM','FontSize',16,'FontName','Arial')
