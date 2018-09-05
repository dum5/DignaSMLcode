clear all
close all
%% read data
[loadName,matDataDir]=uigetfile('*.mat');
%%
loadName=[matDataDir,loadName]; 
load(loadName)
AddCombinedParamsToTable
t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControls=t(t.group=='Control',:);



Idx=[1:2 4:15]';%exclude pt 3 AND control 3

f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 10]);
ph=tight_subplot(6,3,0.05,0.1,0.08);
set(ph,'XTickLabelMode','auto','YTickLabelMode','auto','FontSize',12,'Box','off','PlotBoxAspectRatio',[1,1,1])
set(ph(1:5,1),'XLim',[20 35],'XTick',[20 25 30 35])%FM
set(ph(1:5,2),'XLim',[40 80],'XTick',[40 60 80])%Age
set(ph(1:5,3),'XLim',[0.25 1.5],'XTick',[0 0.5 1 1.5])%velocity
set(ph(1,:),'YLim',[0 10],'YTick',[0 5 10]);%lAMagn
set(ph(2,:),'YLim',[0 15],'YTick',[0 10 20])%eAMagn
set(ph(3,:),'YLim',[0 15],'YTick',[0 10 20])%ePMagn
set(ph(4,:),'YLim',[0 17],'YTick',[0 10 20])%ePBMagn
set(ph(5,:),'YLim',[0 1],'YTick',[0 0.5 1])%BetaM
set(ph(6,1),'Visible','off');
set(ph(6,2),'YLim',[0 1],'YTick',[0 0.5 1],'XLim',[-0.2 1.2],'XTick',[0 0.5 1],'YTickLabelMode','auto')
set(ph(6,3),'YLim',[0 1],'YTick',[0 0.5 1],'XLim',[-10 20],'XTick',[-10 0 10 20])


ph(1:5,:)=moveAxis(ph(1:5,:),0.04,0);
ph(6,:)=moveAxis(ph(6,:),-0.02,-0.2);
ph=moveAxis(ph,0,0.02);

xlabel(ph(5,1),'Fugl-Meyer')
xlabel(ph(5,2),'Age')
xlabel(ph(5,3),'Velocity')

ylabel(ph(1,1),'|| LateA ||')
ylabel(ph(2,1),'FBK_t_i_e_d_-_t_o_-_s_p_l_i_t')
ylabel(ph(3,1),'FBK_s_p_l_i_t_-_t_o_-_t_i_e_d')
ylabel(ph(4,1)','|| EarlyP ||')
ylabel(ph(5,1)','\beta_M')
ylabel(ph(6,2)','\beta_M')

set(ph(:,2:3),'YTickLabel',{''})
set(ph(1:4,:),'XTickLabel',{''})

xlabel(ph(6,2),'EMG_Q_u_a_d LateA')
xlabel(ph(6,3),'\theta Knee_s_l_o_w LateA')

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

%correlation with betaM
[a]=plotCor(ph(5,1),TStroke.FM(Idx),TStroke.BM(Idx));
[a]=plotCor(ph(5,2),TStroke.age(Idx)./12,TStroke.BM(Idx),TControls.age(Idx)./12,TControls.BM(Idx));
[a]=plotCor(ph(5,3),TStroke.vel(Idx),TStroke.BM(Idx),TControls.vel(Idx),TControls.BM(Idx));

ll=findobj(ph(1,3),'Type','Line');
legend(ph(1,3),ll(end:-1:1),{'CONTROL','STROKE'},'box','off','Position',[0.8170    0.9574    0.1815    0.0443])
text(ph(1,1),15,15,'A','FontSize',14,'FontWeight','bold')
text(ph(6,2),-1.5,1.2,'B','FontSize',14,'FontWeight','bold')

%correlations between feeback and feedforward adaptation
%[a]=plotCor(ph(6,1),TStroke.lAMagn(Idx),TStroke.BM(Idx),TControls.lAMagn(Idx),TControls.BM(Idx));
[a]=plotCor(ph(6,2),TStroke.FF_Quad(Idx),TStroke.BM(Idx),TControls.FF_Quad(Idx),TControls.BM(Idx));
[a]=plotCor(ph(6,3),TStroke.FF_skneeAngleAtSHS(Idx),TStroke.BM(Idx),TControls.FF_skneeAngleAtSHS(Idx),TControls.BM(Idx));


function [a]=plotCor(ax,xDataS,yDataS,xDataC,yDataC)
hold(ax)
a=[];
yl=get(ax,'YLim');
xl=get(ax,'XLim');
if nargin>3
    plot(ax,xDataC,yDataC,'ok','MarkerFaceColor',[1 1 1])
    [rhoc,pc]=corr([xDataC,yDataC],'Type','Spearman');
    tc=text(ax,xl(1),yl(2)+3*diff(yl)/10,['rho= ',num2str(round(rhoc(2),2)),' p=',num2str(round(pc(2),3))]);set(tc,'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold')
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
ts=text(ax,xl(1),yl(2)+diff(yl)/10,['rho= ',num2str(round(rhos(2),2)),' p=',num2str(round(ps(2),3))]);set(ts,'Color',[0 0 0],'FontSize',12,'FontWeight','bold')
if ps(2)<0.05
    [r,slope,intercept] = regression(xDataS,yDataS,'one');
    x=get(ax,'XLim');
    pred=intercept+slope.*x;
    plot(ax,x,pred,'-k','LineWidth',2')
    clear r slope intercept x pred
end


end
 
 
 
