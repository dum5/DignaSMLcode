%% Group assessments
clear all
close all
clc

 [loadName,matDataDir]=uigetfile('*.mat');
 loadName=[matDataDir,loadName]; 
 load(loadName)
figuresColorMap;
ex1=[0.85 0.325 0.098];
ex2=[0 0.447 0.741];

speedMatchFlag=1;
removeP07Flag=1;
removeP03Flag=1;

strokesFast=strcat('P00',{'01','02','05','08','09','10','13','14','15'});%P016 removed %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsSlow=strcat('C00',{'01','02','04','05','06','09','10','12','16'}); %C07 removed%Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s


if speedMatchFlag
   patients2=patients.getSubGroup(strokesFast);
   controls2=controls.getSubGroup(controlsSlow);
else
    patients2=patients;
    controls2=controls;
end
if removeP07Flag
   patients2=patients2.removeSubs({'P0007'});
   controls2=controls2.removeSubs({'C0007'});   
end
if removeP03Flag
   patients2=patients2.removeSubs({'P0003'});
end
%define groups
groups{1}=controls2;
groups{2}=patients2;

%% Get normalized parameters:
%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%mOrder={'TA','SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF'};
nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names

%Renaming normalized parameters, for convenience:
for k=1:length(groups)
    ll=groups{k}.adaptData{1}.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
    groups{k}=groups{k}.renameParams(ll,l2);
end
newLabelPrefix=fliplr(strcat(labelPrefix,'s'));


f1=figure('Name','Feedforward responses');
set(f1,'Color',[1 1 1]','Units','inches','Position',[-2 -2 10 12]);

axA1 = axes('Position',[0.075   0.85   0.35 0.12],'FontSize',12);%eA-B schematic
axA2 = axes('Position',[0.075   0.7    0.35   0.12],'FontSize',12);%eP-lA schematic

%generate data
condoffset=0.05;
t1=[zeros(60,1);ones(60,1)];
t2=flipud(t1);
v1=[t1+condoffset -1.*t1];
v2=[t2+condoffset -1.*t2];
condAlpha=0.2;

%plot them
hold(axA1)
patch(axA1,[40 60 60 40],[-1.5 -1.5 1.5 1.5],0,'FaceAlpha',condAlpha,'FaceColor',condColors(1,:),'EdgeColor','none')
patch(axA1,[60 80 80 60],[-1.5 -1.5 1.5 1.5],0,'FaceAlpha',condAlpha,'FaceColor',condColors(2,:),'EdgeColor','none')
h=plot(axA1,v1,'LineWidth',3);
set(h,{'color'},{ex2; ex1});
text(axA1,47,0.4,'B','Color',condColors(1,:),'FontSize',14,'FontWeight','bold');
text(axA1,65,0.4,'eA','Color',condColors(2,:),'FontSize',14,'FontWeight','bold');
set(axA1,'XLim',[30 90],'YLim',[-1.5 1.5],'XTick',[0 100],'YTick',[-10 10])
title(axA1,'TIED-TO-SPLIT')
ylabel(axA1,'BELT SPEED','FontWeight','bold')

hold(axA2)
patch(axA2,[40 60 60 40],[-1.5 -1.5 1.5 1.5],0,'FaceAlpha',condAlpha,'FaceColor',condColors(2,:),'EdgeColor','none')
patch(axA2,[60 80 80 60],[-1.5 -1.5 1.5 1.5],0,'FaceAlpha',condAlpha,'FaceColor',condColors(3,:),'EdgeColor','none')
h=plot(axA2,v2,'LineWidth',3);
set(h,{'color'},{ex2; ex1});
text(axA2,45,0.4,'eA','Color',condColors(2,:),'FontSize',14,'FontWeight','bold');
text(axA2,65,0.4,'eP','Color',condColors(3,:),'FontSize',14,'FontWeight','bold');
set(axA2,'XLim',[30 90],'YLim',[-1.5 1.5],'XTick',[0 100],'YTick',[-10 10])
title(axA2,'SPLIT-TO-TIED')
ylabel(axA2,'BELT SPEED','FontWeight','bold')

ax2 = axes('Position',[0.52   0.12   0.37/2 0.37],'FontSize',12);%patients eA-B
ax3 = axes('Position',[0.52+0.4/2    0.12    0.37/2   0.37],'FontSize',12);%patients eP-lA


ax4 = axes('Position',[0.52   0.57   0.37/2 0.37],'FontSize',12);%controls eA-B
ax5 = axes('Position',[0.52+0.4/2    0.57    0.37/2   0.37],'FontSize',12);%patients eP-lA
fb=figure;
pd1=subplot(1,1,1);

eE=1;
eL=1;
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
%set axes;



[eps1] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmean');
[reps1] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');


[eps2] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmean');
[reps2] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');

[f1,fb,ax4,ax2,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax4,ax2,pd1,eps1,reps1,newLabelPrefix,groups,0.1,0.1,'nanmedian');
[f1,fb,ax5,ax3,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax5,ax3,pd1,eps2,reps2,newLabelPrefix,groups,0.1,0.1,'nanmedian');
close(fb)

Ylab=get(ax2,'YTickLabel');
for l=1:length(Ylab)
   Ylab{l}=Ylab{l}(2:end-1);
end

ax2.YTickLabel{1}= ['\color[rgb]{0,0.447,0.741} ' ax2.YTickLabel{1}];
ax2.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{2}];
set(ax3,'YTickLabel',Ylab,'YAxisLocation','right')
set(ax2,'YTickLabel',{''})
for i=1:length(ax3.YTickLabel)
    if i<16
    ax3.YTickLabel{i}=['\color[rgb]{0,0.447,0.741} ' ax3.YTickLabel{i}];
    else
        ax3.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax3.YTickLabel{i}];
    end
end


ax4.YTickLabel{1}= ['\color[rgb]{0,0.447,0.741} ' ax4.YTickLabel{1}];
ax4.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax4.YTickLabel{2}];
set(ax5,'YTickLabel',Ylab,'YAxisLocation','right')
set(ax4,'YTickLabel',{''})
for i=1:length(ax3.YTickLabel)
    if i<16
    ax5.YTickLabel{i}=['\color[rgb]{0,0.447,0.741} ' ax5.YTickLabel{i}];
    else
        ax5.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax5.YTickLabel{i}];
    end
end

set(ax2,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax3,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})


set(ax4,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax5,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
colorbar('peer',ax3);
%map=flipud(repmat([0.3:0.01:1]',1,3));
%set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[0.6835    0.0815    0.2237    0.0264];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',16,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

h=title(ax4,'\Delta EMG eA_B');set(h,'FontSize',14);h=title(ax5,'\Delta EMG eP_l_A');set(h,'FontSize',14)
h=title(ax2,'\Delta EMG eA_B');set(h,'FontSize',14);h=title(ax3,'\Delta EMG eP_l_A');set(h,'FontSize',14)


%hold(ax2)
plot(ax2,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[1 4.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[5.2 8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[8 10.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[11.2 14],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[14 14.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[15.2 16],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[16 19.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[20.2 23],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[23 25.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[26.2 29],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax2,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t2=text(ax2,-0.1,6,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t3=text(ax2,-0.1,12,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
t4=text(ax2,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t5=text(ax2,-0.1,6.+15,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t6=text(ax2,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
plot(ax2,[-0.17 -0.17],[0 14.9],'LineWidth',5,'Color',[0,0.447,0.741],'Clipping','off')
plot(ax2,[-0.17 -0.17],[15.1 30],'LineWidth',5,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax2,-0.27,3.9,2,'NON-PAR','Rotation',90,'Color',[0 0.447 0.741],'FontSize',16,'FontWeight','Bold');
t8=text(ax2,-0.27,21,2,'PAR','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',16,'FontWeight','Bold');
t9=text(ax2,0.8,33,2,'STROKE','Color','k','FontSize',16,'FontWeight','Bold','Clipping','off');
plot(ax2,[-0.2 0.1],[-3 -3],'LineWidth',7,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax2,[-0.2 0.1],[-5 -5],'LineWidth',7,'Color','k','Clipping','off')
t10=text(ax2,0.15,-3,2,'FLEXORS','FontSize',14);
t11=text(ax2,0.15,-5,2,'EXTENSORS','FontSize',14);

%hold(ax3)
plot(ax3,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')


%hold(ax4)
plot(ax4,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[1 4.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[5.2 8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[8 10.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[11.2 14],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[14 14.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[15.2 16],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[16 19.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[20.2 23],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[23 25.8],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[26.2 29],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax4,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t2=text(ax4,-0.1,6,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t3=text(ax4,-0.1,12,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
t4=text(ax4,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t5=text(ax4,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t6=text(ax4,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
plot(ax4,[-0.17 -0.17],[0 14.9],'LineWidth',5,'Color',[0,0.447,0.741],'Clipping','off')
plot(ax4,[-0.17 -0.17],[15.1 30],'LineWidth',5,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax4,-0.27,6.2,2,'DOM','Rotation',90,'Color',[0 0.447 0.741],'FontSize',16,'FontWeight','Bold');
t8=text(ax4,-0.27,17.9,2,'NON-DOM','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',16,'FontWeight','Bold');
t9=text(ax4,0.8,33,2,'CONTROLS','Color','k','FontSize',16,'FontWeight','Bold','Clipping','off');


%hold(ax5)
plot(ax5,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax5,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax5,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax5,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Figure B. Bars and Scatter%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[loadName,matDataDir]=uigetfile('*.mat','choose file for barplots');
loadName=[matDataDir,loadName]; 
load(loadName)

AddCombinedParamsToTable;

if speedMatchFlag
    
    BSControl=0.1606;
    BMControl=0.8057;
    CIBSControl=[0.10212 0.2199];
    CIBMControl=[0.7463 0.8651];
       
    BSStroke=0.3884;
    BMStroke=0.5908;
    CIBSStroke=[0.3200 0.4569];
    CIBMStroke=[0.5224 0.6592];
    
    t=t(t.SpeedMatch==1,:);
else
    BSControl=0.1717;
    BMControl=0.7617;
    CIBSControl=[0.1266 0.2167];
    CIBMControl=[0.7166 0.8067];
       
    BSStroke=0.2227;
    BMStroke=0.6951;
    CIBSStroke=[0.1639 0.2814];
    CIBMStroke=[0.6363 0.7539];
    
end
    
%% Run stats for between group comparison
t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

[p1,h1]=ranksum(TStroke.eAMagn,TControl.eAMagn);
if p1<0.01
    p1='<0.01';
else
    p1=['=',num2str(round(p1,2))];
end

[p2,h2]=ranksum(TStroke.ePMagn,TControl.ePMagn);
if p2<0.01
    p2='<0.01';
else
    p2=['=',num2str(round(p2,2))];
end


ph(1,1) = axes('Position',[0.075   0.385   0.35 0.25],'FontSize',12);%Magnitudes
ph(1,2) = axes('Position',[0.075   0.075   0.35 0.25],'FontSize',12);%Regressors

hold(ph(1,1))
bar(ph(1,1),1,nanmedian(TControl.eAMagn),'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),1,nanmedian(TControl.eAMagn),0,iqr(TControl.eAMagn),'Color','k','LineWidth',2)
bar(ph(1,1),2,nanmedian(TStroke.eAMagn),'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),2,nanmedian(TStroke.eAMagn),0,iqr(TStroke.eAMagn),'Color','k','LineWidth',2)

bar(ph(1,1),3.5,nanmedian(TControl.ePMagn),'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),3.5,nanmedian(TControl.ePMagn),0,iqr(TControl.ePMagn),'Color','k','LineWidth',2)
bar(ph(1,1),4.5,nanmedian(TStroke.ePMagn),'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ph(1,1),4.5,nanmedian(TStroke.ePMagn),0,iqr(TStroke.ePMagn),'Color','k','LineWidth',2)

set(ph(1,1),'XLim',[0.5 5],'XTick',[1.5 4],'YLim',[0 12],'XTickLabel',{'|| FBK_t_i_e_d_-_t_o_-_s_p_l_i_t ||','|| FBK_s_p_l_i_t_-_t_o_-_t_i_e_d ||'},'YTick',[0 5 10])
ylabel(ph(1,1),'Response magnitude (a.u.)','FontWeight','bold')
text(ph(1,1),1,12,'Feedback response magnitudes ','FontSize',14,'FontWeight','bold')
ll=findobj(ph(1,1),'Type','Bar');
ll2=legend(flipud(ll),'Control','Stroke');
set(ll2,'EdgeColor','none')

hold(ph(1,2))
bar(ph(1,2),1,BSControl,'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
bar(ph(1,2),2,BSStroke,'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2);
bar(ph(1,2),3.5,BMControl,'BarWidth',0.7,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
bar(ph(1,2),4.5,BMStroke,'BarWidth',0.7,'FaceColor',[0 0 0],'EdgeColor',[0 0 0],'LineWidth',2);
errorbar(ph(1,2),[1 2 3.5 4.5],[BSControl,BSStroke BMControl BMStroke],[0 0 0 0],[diff(CIBSControl)/2 diff(CIBSStroke)/2 diff(CIBMControl)/2 diff(CIBMStroke)/2],'Color','k','LineStyle','none','LineWidth',2)

set(ph(1,2),'XLim',[0.5 5],'YLim',[0 1],'XTick',[1.5 4],'XTickLabel',{'\beta_S','\beta_M'},'YTick',[0 .5 1])
ylabel(ph(1,2),'\beta','FontWeight','bold')
text(ph(1,2),0.7,1,'Feedback response adaptation ','FontSize',14,'FontWeight','bold')
