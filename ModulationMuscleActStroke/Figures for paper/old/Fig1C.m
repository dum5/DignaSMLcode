clear all
close all
%% Load data
subj='C0014';
load(['Z:\SubjectData\E01 Synergies\mat\HPF30\' subj '.mat']);

%% Align it
conds={'TM Base','Adap'};
events={'RHS','LTO','LHS','RTO'};
alignmentLengths=[16,64,16,64];
muscle='LG';
RBase=expData.getAlignedField('procEMGData',conds(1),events,alignmentLengths).getPartialDataAsATS({['R' muscle]});
LBase=expData.getAlignedField('procEMGData',conds(1),events([3,4,1,2]),alignmentLengths).getPartialDataAsATS({['L' muscle]});
RAdap=expData.getAlignedField('procEMGData',conds(2),events,alignmentLengths).getPartialDataAsATS({['R' muscle]});
LAdap=expData.getAlignedField('procEMGData',conds(2),events([3,4,1,2]),alignmentLengths).getPartialDataAsATS({['L' muscle]});

%% Create plots
fh=figure('Units','Normalized');
set(gcf,'Color',[1 1 1])
figuresColorMap
ph=[];
ph1=[];
prc=[16,84];%upper and lower percentile bounds of shaded area's
MM=sum(alignmentLengths);
M=cumsum([0 alignmentLengths]);
xt=sort([M,M(1:end-1)+[diff(M)/2]]);
xt=[0,8,16:16:80,88,96:16:160];
%xt=[0:8:MM];
fs=16; %FontSize
for i=1:3
    ph(i)=axes();
    set(ph(i),'Position',[.05+(i-1)*.33 .4 .25 .5]);
    cc1=get(gca,'ColorOrder');
    set(gca,'ColorOrder',condColors)
    cca=get(gca,'ColorOrder');
end
linkaxes(ph,'y') 

%baseline only
i=1;
B=LBase;
B.plot(fh,ph(i),cca(1,:),[],0,[-49:0],prc,true);
axis tight
ylabel('')
ylabel(['SLOW ' muscle])
ax=gca;
ax.YLabel.Color=cca(i,:);
ax.YLabel.FontWeight='bold';

ph1(i)=axes;
set(ph1(i),'Position',[.05+(i-1)*.33 .15 .25 .1]);
da=randn(1,12);
aux=nanmedian(B.Data,3)';
clear aux2
for j=1:length(xt)-1
    aux2(j)=mean(aux(xt(j)+1:xt(j+1)));%compute averages for checkerboards
end
aux3([1,2:2:10,11,12:2:20])=aux2;
aux3([3:2:10,13:2:20])=aux2([3:6,9:12]);
imagesc(aux3/max(nanmedian(B.Data,3)))
view(2)
colormap(flipud(map))
caxis([-.5 .5])
rectangle('Position',[.5 .5 20 1],'EdgeColor','k')
set(ph1(i),'XTickLabel','','YTickLabel','','XTick','','YTick','')
if i==2
    pos=get(ph1(i),'Position');
end

for i=2:3
    hold on
    switch i
        case 2
            B=LBase;
            A=LAdap;
            tit=['SLOW ' muscle];
        case 3
            B=RBase;
            A=RAdap;
            tit=['FAST ' muscle];
     end
    B.plot(fh,ph(i),cca(1,:),[],0,[-49:0],prc,true);
    A.plot(fh,ph(i),cca(2,:),[],0,[-49:0],prc,true);
    axis tight
    ylabel('')
    ylabel(tit)
    ax=gca;
    ax.YLabel.Color=cc1(i-1,:);
    ax.YLabel.FontWeight='bold';
    
    ph1(i)=axes;
    set(ph1(i),'Position',[.05+(i-1)*.33 .15 .25 .1]);  
    da=randn(1,12);
    aux=nanmedian(A.Data,3)'-nanmedian(B.Data,3)';
    clear aux2
    for j=1:length(xt)-1
        aux2(j)=mean(aux(xt(j)+1:xt(j+1)));%compute averages for checkerboards
    end
    aux3([1,2:2:10,11,12:2:20])=aux2;
    aux3([3:2:10,13:2:20])=aux2([3:6,9:12]);
    imagesc(aux3/max(nanmedian(B.Data,3)))
    view(2)
    colormap(flipud(map))
    caxis([-.5 .5])
    rectangle('Position',[.5 .5 20 1],'EdgeColor','k')
    set(ph1(i),'XTickLabel','','YTickLabel','','XTick','','YTick','')
    if i==2
    pos=get(ph1(i),'Position');
    end
end
drawnow
for i=1:3
    axes(ph(i))
    ll=findobj(ph(i),'Type','Line');
    set(ll,'LineWidth',3)
    set(ph(i),'FontSize',fs,'YTickLabel','','XTickLabel','','XTick',xt,'YTick','')
    a=axis;
    yOff=a(3)-.2*(a(4)-a(3));
    text(.015*MM,yOff,'DS','Clipping','off','FontSize',fs)
    %text(.18*MM,yOff,{'Early'; 'Stance'},'Clipping','off','FontSize',fs)
    %text(.36*MM,yOff,{'Late'; 'Stance'},'Clipping','off','FontSize',fs)
    text(.2*MM,yOff,{'STANCE'},'Clipping','off','FontSize',fs)
    text(.515*MM,yOff,'DS','Clipping','off','FontSize',fs)
    %text(.68*MM,yOff,{'Early'; 'Swing'},'Clipping','off','FontSize',fs)
    %text(.86*MM,yOff,{'Late';'Swing'},'Clipping','off','FontSize',fs)
    text(.7*MM,yOff,{'SWING'},'Clipping','off','FontSize',fs)
    axis(a)
        hold on
    yOff=a(3)-.05*(a(4)-a(3));
    plot([.1 .9]*16,[1 1]*yOff,'Color',0*ones(1,3),'LineWidth',4,'Clipping','off')
    plot([1.1 4.9]*16,[1 1]*yOff,'Color',0*ones(1,3),'LineWidth',4,'Clipping','off')
    plot([5.1 5.9]*16,[1 1]*yOff,'Color',0*ones(1,3),'LineWidth',4,'Clipping','off')
    plot([6.1 9.9]*16,[1 1]*yOff,'Color',0*ones(1,3),'LineWidth',4,'Clipping','off')
     if i==3
        
        legend(ll(end:-1:1),{'Baseline','Adaptation'},'Box','off','Position',[0.8497    0.7091    0.1490    0.2523])
    end
end
set(gcf,'Position',[0 0 .7 0.2])
%%
destdir='Z:\Users\Digna\Papers\Modulation of Muscle Activity in Stroke\Matlab Figures\';
saveFig(fh,destdir, 'Fig1C',1)
print('-painters','-dsvg','Fig1C')