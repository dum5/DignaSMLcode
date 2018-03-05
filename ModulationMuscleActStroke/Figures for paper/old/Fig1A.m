%%
destdir='Z:\Users\Digna\Papers\Modulation of Muscle Activity in Stroke\Matlab Figures\';
name='Fig1';
fh=figure('Name',name,'Units','Normalized','OuterPosition',[0 0 .55 1]);
figuresColorMap
%% Panel A: protocol
conditionOffset=[1 41 61 201 801 1101];
dV=nan(1,conditionOffset(end)-1);
for i=1:length(conditionOffset)-1
    dV(conditionOffset(i):conditionOffset(i+1)-1)=mod(i-1,2);
end
v0=1;
V=v0+.333*[1;-1]*dV +[.01;-.01];
ph=subplot(1,1,1);
% set(ph,'FontSize',16)
set(ph,'Position',[0.08 0.2 0.9 0.7],'FontSize',16)
ll=plot(V','LineWidth',4);
xlabel('STRIDE CYCLES')
ylabel('BELT SPEED')
ph.XLabel.FontWeight='bold';
ph.YTickLabel={'-33%','select','Self','+33%'};
ph.YTick=[.667 .95 1.05 1.333]*v0;
ph.YTickLabelRotation=0;
ph.FontSize=16;
ph.YLabel.FontWeight='bold';

%text(-170, 1.55*v0,'A','FontSize',24,'FontWeight','bold','Clipping','off')

textY=.85*v0;
epochAlpha=.2;
ptWidth=80;
ptc=patch(+[0 ptWidth ptWidth 0]+conditionOffset(4),[.5 .5 1.6 1.6],condColors(2,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
uistack(ptc,'bottom')
text(207,textY,'eA','FontSize',20,'FontWeight','bold','Color',condColors(2,:))
text(250,textY+.6,'ADAPTATION (900 strides)','FontSize',20,'Clipping','off','Color',condColors(2,:),'FontWeight','bold')
ptc=patch(-[0 ptWidth ptWidth 0]+conditionOffset(4),[.5 .5 1.6 1.6],condColors(1,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
uistack(ptc,'bottom')
text(135,textY,'B','FontSize',20,'FontWeight','bold','Color',condColors(1,:))
text(80,textY+.6,'BASE.','FontSize',20,'Clipping','off','Color',condColors(1,:),'FontWeight','bold')
ptc=patch(-[0 ptWidth ptWidth 0]+conditionOffset(5),[.5 .5 1.6 1.6],condColors(2,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
uistack(ptc,'bottom')
text(conditionOffset(5)-70,textY,'lA','FontSize',20,'FontWeight','bold','Color',condColors(2,:))
ptc=patch([0 ptWidth ptWidth 0]+conditionOffset(5),[.5 .5 1.6 1.6],condColors(3,:),'FaceAlpha',epochAlpha,'EdgeColor','None');
uistack(ptc,'bottom')
text(conditionOffset(5)+10,textY,'eP','FontSize',20,'FontWeight','bold','Color',condColors(3,:))
text(830,textY+.5,{'POST-ADAP.'; '(600 strides)'},'FontSize',20,'Clipping','off','Color',condColors(3,:),'FontWeight','bold')

legend(ll,{'Dominant (fast) belt','Non-dom (slow) belt'},'FontSize',14,'FontWeight','bold','Location','South')
set(ph,'XTick','')
%ph.XLabel.Position=ph.XLabel.Position-[300 0 0];
axis([1 conditionOffset(end) .5 1.55])

set(gcf,'Position',[0 0 .7 0.2])
set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperSize', [4 2]);

% saveFig(fh,destdir, 'Fig1A',1)
print('-painters','-dsvg','Fig1A')