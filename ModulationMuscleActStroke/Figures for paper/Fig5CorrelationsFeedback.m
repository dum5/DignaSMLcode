clear all
close all
%% read data
[loadName,matDataDir]=uigetfile('*.mat');
%%
loadName=[matDataDir,loadName]; 
load(loadName)
t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControls=t(t.group=='Control',:);


Idx=[1:2 4:15]';%exclude pt 3 AND control 3

f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 10 10]);
ph=tight_subplot(4,3,0.05,0.1,0.1);
set(ph,'XTickLabelMode','auto','YTickLabelMode','auto','FontSize',14,'Box','off')
set(ph(:,1),'XLim',[20 35],'XTick',[20 25 30 35])%FM
set(ph(:,2),'XLim',[40 80],'XTick',[40 60 80])%Age
set(ph(:,3),'XLim',[0 1.5],'XTick',[0 0.5 1 1.5])%velocity
set(ph(1,:),'YLim',[0 12],'YTick',[0 5 10]);%lAMagn
set(ph(2,:),'YLim',[0 22],'YTick',[0 10 20])%eAMagn
set(ph(3,:),'YLim',[0 20],'YTick',[0 10 20])%ePMagn
set(ph(4,:),'YLim',[0 20],'YTick',[0 10 20])%ePBMagn


title(ph(1,1),'Fugl-Meyer')
title(ph(1,2),'Age')
title(ph(1,3),'Velocity')

ylabel(ph(1,1),'|| LateA ||')
ylabel(ph(2,1),'FBK_t_i_e_d_-_t_o_-_s_p_l_i_t')
ylabel(ph(3,1),'FBK_s_p_l_i_t_-_t_o_-_t_i_e_d')
ylabel(ph(4,1)','|| EarlyP ||')

set(ph(:,2:3),'YTickLabel',{''})
set(ph(1:2,:),'XTickLabel',{''})


%correlations with feedforward
[a]=plotCor(ph(1,1),TStroke.FM(Idx),TStroke.lAMagn(Idx));
[a]=plotCor(ph(1,2),TStroke.age(Idx)./12,TStroke.lAMagn(Idx),TControls.age(Idx)./12,TControls.lAMagn(Idx));
[a]=plotCor(ph(1,3),TStroke.vel(Idx),TStroke.lAMagn(Idx),TControls.vel(Idx),TControls.lAMagn(Idx));

%correlations with FBKtied-to-tplit
[a]=plotCor(ph(2,1),TStroke.FM(Idx),TStroke.eAMagn(Idx));
[a]=plotCor(ph(2,2),TStroke.age(Idx)./12,TStroke.eAMagn(Idx),TControls.age(Idx)./12,TControls.eAMagn(Idx));
[a]=plotCor(ph(2,3),TStroke.vel(Idx),TStroke.eAMagn(Idx),TControls.vel(Idx),TControls.eAMagn(Idx));

%correlations with FBKsplit-to-tied
[a]=plotCor(ph(3,1),TStroke.FM(Idx),TStroke.ePMagn(Idx));
[a]=plotCor(ph(3,2),TStroke.age(Idx)./12,TStroke.ePMagn(Idx),TControls.age(Idx)./12,TControls.ePMagn(Idx));
[a]=plotCor(ph(3,3),TStroke.vel(Idx),TStroke.ePMagn(Idx),TControls.vel(Idx),TControls.ePMagn(Idx));

%correlations with after effects
[a]=plotCor(ph(4,1),TStroke.FM(Idx),TStroke.ePBMagn(Idx));
[a]=plotCor(ph(4,2),TStroke.age(Idx)./12,TStroke.ePBMagn(Idx),TControls.age(Idx)./12,TControls.ePBMagn(Idx));
[a]=plotCor(ph(4,3),TStroke.vel(Idx),TStroke.ePBMagn(Idx),TControls.vel(Idx),TControls.ePBMagn(Idx));

ll=findobj(ph(1,3),'Type','Line');
legend(ph(1,3),ll(end:-1:1),{'CONTROL','STROKE'},'box','off')


function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
hold(ax)
a=[];
yl=get(ax,'YLim');
xl=get(ax,'XLim');
if nargin>3
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    tc=text(ax,xl(1),yl(2),['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),2))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
    if pc(2)<0.05
    [r,slope,intercept] = regression(xDataC,yDataC,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2','Color',[0.7 0.7 0.7])
    clear r slope intercept x pred
    end
end
plot(ax,xDataS,yDataS,'ok','MarkerFaceColor',[0 0 0])
[rhos,ps]=corr([xDataS,yDataS],'Type','Spearman');
ts=text(ax,xl(1),yl(2)-diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),2))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end

end
 
 
 
