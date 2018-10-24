%% Group assessments
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)


speedMatchFlag=0;
%removeP03Flag=1;
groupMedianFlag=1;
allSubFlag=0;
%pIdx=[1:2 4:15];
%cIdx=[1:15];
summethod='nanmedian';

%selection of subjects is as follows: subjects 3 are always removed
%(patients and controls)


SubjectSelection


%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);

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

f1=figure('Name','After effects');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 8 6/1.1429]);

ax2 = axes('Position',[0.075   0.075   0.35/1.5 0.4*2],'FontSize',12);%create axis for control checkerboard
ax3 = axes('Position',[0.075+0.37/1.5    0.075    0.35/1.5   0.4*2],'FontSize',12);%create axis for patient checkerboard
ax4 = axes('Position',[0.6849    0.4306    0.2839    0.4524],'FontSize',14);

 
% 
% ax2 = axes('Position',[0.1   0.2   0.2 0.35*1.81],'FontSize',12);%create axis for control checkerboard
% ax3 = axes('Position',[0.1+0.22    0.2    0.2   0.35*1.81],'FontSize',12);%create axis for patient checkerboard


fb=figure;
pd1=subplot(1,1,1);

eE=1;
eL=1;
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
%set axes;



[eps] = defineEpochs({'eP'},{'Washout'}',[5],[eE],[eL],'nanmedian');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');
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
cc.Position=[0.6557    0.1663    0.2237    0.0264];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',16,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

h=title(ax2,'CONTROLS');set(h,'FontSize',14);h=title(ax3,'STROKE');set(h,'FontSize',14)

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
t5=text(ax2,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',14,'FontWeight','Bold');
t6=text(ax2,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',14,'FontWeight','Bold');
plot(ax2,[-0.17 -0.17],[0 14.9],'LineWidth',5,'Color',[0,0.447,0.741],'Clipping','off')
plot(ax2,[-0.17 -0.17],[15.1 30],'LineWidth',5,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax2,-0.27,1,2,'NON-PAR/DOM','Rotation',90,'Color',[0 0.447 0.741],'FontSize',16,'FontWeight','Bold');
t8=text(ax2,-0.27,16.5,2,'PAR/NON-DOM','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',16,'FontWeight','Bold');
t9=text(ax2,0.3,33,2,'Early Post-Adaptation (EarlyP)','Color','k','FontSize',16,'FontWeight','Bold','Clipping','off');


%hold(ax3)
plot(ax3,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')

plot(ax3,[1.5 1.8],[9 9],'LineWidth',7,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax3,[1.5 1.8],[7 7],'LineWidth',7,'Color','k','Clipping','off')
t10=text(ax3,1.9,9,2,'FLEXORS','FontSize',14);
t11=text(ax3,1.9,7,2,'EXTENSORS','FontSize',14);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Figure B. Bars and Scatter%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
[loadName,matDataDir]=uigetfile('*.mat','choose file for barplots');
loadName=[matDataDir,loadName]; 
load(loadName)


%% Run stats for between group comparison
AddCombinedParamsToTable;

if speedMatchFlag==1
    t=t(t.SpeedMatch==1,:);
elseif speedMatchFlag==0
    t=t(t.fullGroup==1,:);
end

t.group=nominal(t.group);
TStroke=t(t.group=='Stroke',:);
TControl=t(t.group=='Control',:);

[p1,h1]=ranksum(TStroke.ePBMagn,TControl.ePBMagn);
if p1<0.01
    p1='<0.01';
else
    p1=['=',num2str(round(p1,2))];
end

%do the plotting
%ph.delete


hold(ax4)
bar(ax4,1,nanmedian(TControl.ePBMagn),'BarWidth',0.5,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2)
errorbar(ax4,1,nanmedian(TControl.ePBMagn),0,iqr(TControl.ePBMagn),'Color','k','LineWidth',2)
hs=bar(ax4,2,nanmedian(TStroke.ePBMagn),'BarWidth',0.5,'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'LineWidth',2);
hatchfill2(hs)
errorbar(ax4,2,nanmedian(TStroke.ePBMagn),0,iqr(TStroke.ePBMagn),'Color','k','LineWidth',2)
set(ax4,'XLim',[0.5 2.5],'YLim',[0 11],'XTickLabel',{''},'YTick',[0 5 10])
ylabel(ax4,'|| EarlyP ||','FontWeight','bold')
text(ax4,1,11,'Magnitude after effects','FontSize',14,'FontWeight','bold')
ll=findobj(ax4,'Type','Bar');
ll2=legend(flipud(ll),'Control','Stroke');
set(ll2,'EdgeColor','none')


