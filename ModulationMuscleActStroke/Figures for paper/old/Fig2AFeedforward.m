%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

speedMatchFlag=0;
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
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 7 7]);

ax2 = axes('Position',[0.15   0.2   0.35 0.35*1.81],'FontSize',12);%create axis for control checkerboard
ax3 = axes('Position',[0.15+0.37    0.2    0.35   0.35*1.81],'FontSize',12);%create axis for patient checkerboard

fb=figure;
pd1=subplot(1,1,1);

eE=1;
eL=1;
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
%set axes;



[eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');
[f1,fb,ax2,ax3,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax2,ax3,pd1,eps,reps,newLabelPrefix,groups,0.1,0.1,'nanmedian');
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

set(ax2,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax3,'FontSize',12,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
colorbar('peer',ax3);
%map=flipud(repmat([0.3:0.01:1]',1,3));
%set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[0.6974   0.1107    0.2237    0.0264];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',16,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

h=title(ax2,'CONTROLS');set(h,'FontSize',14);h=title(ax3,'STROKE');set(h,'FontSize',14)

%hold(ax2)
plot(ax2,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[-0.015 -0.015],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[1 4.9],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[5.1 8],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[8 10.9],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[11.1 14],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[14 14.9],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[15.1 16],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[16 19.9],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[20.1 23],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[23 25.9],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[26.1 29],'Color',[0.5 0.5 0.5],'LineWidth',5,'Clipping','off')
plot(ax2,[-0.015 -0.015],[29 30],'Color',[0 0 0],'LineWidth',5,'Clipping','off')
t1=text(ax2,-0.08,0,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t2=text(ax2,-0.08,6,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t3=text(ax2,-0.08,12,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
t4=text(ax2,-0.08,0+15,2,'ANKLE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t5=text(ax2,-0.08,6+15,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t6=text(ax2,-0.08,12+15,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
plot(ax2,[-0.15 -0.15],[0 14.9],'LineWidth',5,'Color',[0,0.447,0.741],'Clipping','off')
plot(ax2,[-0.15 -0.15],[15.1 30],'LineWidth',5,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax2,-0.25,1,2,'NON-PAR/DOM','Rotation',90,'Color',[0 0.447 0.741],'FontSize',16,'FontWeight','Bold');
t8=text(ax2,-0.25,16.5,2,'PAR/NON-DOM','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',16,'FontWeight','Bold');
t9=text(ax2,0.22,33,2,'LATE ADAPTATION-BASELINE','Color','k','FontSize',16,'FontWeight','Bold','Clipping','off');
plot(ax2,[0 0.3],[-3 -3],'LineWidth',10,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax2,[0 0.3],[-5 -5],'LineWidth',10,'Color','k','Clipping','off')
t10=text(ax2,0.35,-3,2,'FLEXORS','FontSize',14);
t11=text(ax2,0.35,-5,2,'EXTENSORS','FontSize',14);

%hold(ax3)
plot(ax3,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
