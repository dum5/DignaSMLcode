clear all
close all

myFiguresColorsMap
f1=figure('Name','Fig1A');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 2])

conditionOffset=[1 51 105 301 801 1101];
dV=nan(1,conditionOffset(end)-1);
for i=1:length(conditionOffset)-1
    dV(conditionOffset(i):conditionOffset(i+1)-1)=mod(i-1,2);
end
v0=1;
V=v0+.333*[1;-1]*dV +[.01;-.01];
V=[.67*[ones(1,100)*1.015;ones(1,100)*.985] V];
ph=subplot(1,1,1); set(ph,'Position',[0.1157 0.1233 0.8547 0.8017])

set(ph,'FontSize',10,'ColorOrder',legColors)
ll=plot([1:size(V,2)]-50,V','LineWidth',4);
ll(1).Color=legColors(1,:);
ll(2).Color=legColors(2,:);
xlabel('Stride cycles')
ylabel({'Belt speed'})
ph.XLabel.FontWeight='bold';
ph.YTickLabel={'-33%','Mid','+33%'};
ph.YTick=[.667 1 1.333]*v0;
ph.YTickLabelRotation=00;
ph.FontSize=10;
ph.YLabel.FontWeight='bold';
ph.YAxis.FontSize=10;
ph.YLabel.FontSize=12;

%text(-170, 1.55*v0,'A','FontSize',24,'FontWeight','bold','Clipping','off')

%ptc=patch([200 1100 1100 200],[.5 .5 1.5 1.5],.6*ones(1,3),'FaceAlpha',.4,'EdgeColor','None');
%uistack(ptc,'bottom')
%ptc=patch([40 50 50 40],[.5 .5 1.5 1.5],.6*ones(1,3),'FaceAlpha',.4,'EdgeColor','None');
%uistack(ptc,'bottom')

textY=.85*v0;
epochAlpha=.2;
ptWidth=80;
condColors=repmat(.3*ones(1,3),5,1);
condFontSize=10;
text(-48,textY-.05,'SLOW','FontSize',condFontSize,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
text(63,textY+.58,'(SHORT)','FontSize',condFontSize,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
text(104,textY+.4,'[10]','FontSize',condFontSize*.75,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
%ptc=patch(+[0 ptWidth ptWidth 0]+conditionOffset(4),[.5 .5 1.6 1.6],condColors(2,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
%uistack(ptc,'bottom')
%text(condFontSize7,textY+.03,'EarlyA','FontSize',condFontSize,'FontWeight','bold','Color',condColors(2,:))
text(450,textY+.58,'(LONG) ADAPTATION','FontSize',condFontSize,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
text(515,textY+.4,'[900 STRIDES]','FontSize',condFontSize*.75,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
%ptc=patch(-[0 ptWidth ptWidth 0]+conditionOffset(4),[.5 .5 1.6 1.6],condColors(1,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
%uistack(ptc,'bottom')
%text(135,textY+.03,'B','FontSize',condFontSize,'FontWeight','bold','Color',condColors(1,:))
text(180,textY+.26,'BASELINE','FontSize',condFontSize,'Clipping','off','Color',condColors(1,:),'FontWeight','bold')
%ptc=patch(-[0 ptWidth ptWidth 0]+conditionOffset(5),[.5 .5 1.6 1.6],condColors(2,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
%uistack(ptc,'bottom')
%text(conditionOffset(5)-140,textY+.03,'LateA','FontSize',condFontSize,'FontWeight','bold','Color',condColors(2,:))
%ptc=patch([0 ptWidth ptWidth 0]+conditionOffset(5),[.5 .5 1.6 1.6],condColors(3,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
%uistack(ptc,'bottom')
%text(conditionOffset(5)+10,textY+.03,'EarlyP','FontSize',condFontSize,'FontWeight','bold','Color',condColors(3,:))
text(880,textY+.26,'POST-ADAP','FontSize',condFontSize,'Clipping','off','Color',condColors(3,:),'FontWeight','bold')
text(885,textY+.05,'[600 STRIDES]','FontSize',condFontSize*.75,'Clipping','off','Color',condColors(3,:),'FontWeight','bold')

lg=legend(ll,{'DOMINANT/NON-PARETIC','NON-DOMINANT/PARETIC'},'FontSize',condFontSize*.75,'FontWeight','bold','Location','South');
lg.Position=lg.Position-[-.05 .005 0 0];
set(ph,'XTick','')
%ph.XLabel.Position=ph.XLabel.Position-[300 0 0];
axis([-50 conditionOffset(end) .5 1.55])
ph.Box='off';


set(gcf,'Renderer','painters');