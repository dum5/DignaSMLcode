clear all
close all
clc

%In this version the following has been updated
% - Patient selection has changed according to what we agreed on in Sept 2018
% - Regressions are performed on normalized vectors, since BM on the non-normalized data depends on
%   magnitude in the stroke group (rho=-0.55, p=0.046).
% - We use the first 5 strides to characterize feedback-generated activity
% - The data table for individual subjects will be generated with all 16
%   subjects, such that different selections are possible in subsequent
%   analyses (set allSubFlag to 1)
% - Analyses on group median data are performed with allSubFlag at 0,
%   subject selection depends on speedMatchFlag


[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)

speedMatchFlag=0;
allSubFlag=0;%use this flag to generate the table that includes all subjects
%this needs to happen separately, since indices will be messed up ohterwise

groupMedianFlag=1; %do not change
nstrides=5;% do not change
summethod='nanmedian';% do not change

SubjectSelection% subjectSelection has moved to different script to avoid mistakes accross scripts

pIdx=1:length(strokesNames);
cIdx=1:length(controlsNames);

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

eE=1;
eL=1;
% 
% %eA-B
% ep=defineEpochs({'eA'},{'Adaptation'}',[nstrides],[eE],[eL],summethod);
% baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);
invertFlag=0;
%eP-lA
ep=defineEpochs({'eP'},{'Washout'}',[nstrides],[eE],[eL],summethod);
baseEp=defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],summethod);


%Generate figures
f1=figure('Name','EMG structure');
fb=figure;pd1=subplot(2,2,1);
%set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 4 3]);
ax2 = axes(f1,'Position',[0.6   0.06   0.32  0.8],'FontSize',6);%patients eA-B
ax4 = axes(f1,'Position',[0.1   0.06   0.32  0.8],'FontSize',6);%controls eA-B

if invertFlag==1
    [f1,fb,ax4,ax2,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax4,ax2,pd1,ep,baseEp,newLabelPrefix,groups,0.1,0.1,'invNanmedian');
else    
[f1,fb,ax4,ax2,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax4,ax2,pd1,ep,baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');
end
%[f1,fb,ax3,ax1,pd2,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2,dataBinaryc2,dataBinarys2]=plotBGcompV2(f1,fb,ax3,ax1,pd1,ep(4,:),baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');



close(fb)


Ylab=get(ax2,'YTickLabel');
for l=1:length(Ylab)
   Ylab{l}=Ylab{l}(2:end-1);
end

ax2.YTickLabel{1}= ['\color[rgb]{0.4660    0.6740    0.1880} ' ax2.YTickLabel{1}];
ax2.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{2}];
set(ax2,'YTickLabel',Ylab,'YAxisLocation','right')
ax4.YTickLabel{1}= ['\color[rgb]{0.4660    0.6740    0.1880} ' ax4.YTickLabel{1}];
ax4.YTickLabel{2}= ['\color[rgb]{0.85,0.325,0.098} ' ax4.YTickLabel{2}];
set(ax4,'YTickLabel',Ylab,'YAxisLocation','right')

for i=1:length(ax2.YTickLabel)
    if i<16
    ax2.YTickLabel{i}=['\color[rgb]{0.466 0.674 0.188} ' ax2.YTickLabel{i}];
    ax4.YTickLabel{i}=['\color[rgb]{0.466 0.674 0.188} ' ax2.YTickLabel{i}];    
    else
        ax2.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{i}];
        ax4.YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax2.YTickLabel{i}];
    end
end



set(ax2,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax4,'FontSize',6,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})


if strcmp(cell2mat(ep.Condition),'Adaptation')
    h=title(ax4,'\DeltaEMG_U_P CONTROL');set(h,'FontSize',8);
    h=title(ax2,'\DeltaEMG_U_P STROKE');set(h,'FontSize',8);
else
    h=title(ax4,'\DeltaEMG_P CONTROL');set(h,'FontSize',8);
    h=title(ax2,'\DeltaEMG_P STROKE');set(h,'FontSize',8);
end
%hold(ax2)
plot(ax4,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[6.25 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[1 4.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[5.2 7.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[8 10.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[11.2 13.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[14 14.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[15.2 15.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[16 19.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[20.2 22.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[23 25.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[26.2 28.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax4,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax4,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t2=text(ax4,-0.1,6,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t3=text(ax4,-0.1,12,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
t4=text(ax4,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t5=text(ax4,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t6=text(ax4,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
plot(ax4,[-0.17 -0.17],[0 14.9],'LineWidth',3,'Color',[0.466 0.674 0.188],'Clipping','off')
plot(ax4,[-0.17 -0.17],[15.1 30],'LineWidth',3,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax4,-0.27,6,2,'FAST','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',8,'FontWeight','Bold');
t8=text(ax4,-0.27,21,2,'SLOW','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',8,'FontWeight','Bold');
plot(ax4,[0.2 0.4],[-4 -4],'LineWidth',3,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax4,[0.2 0.4],[-6 -6],'LineWidth',3,'Color','k','Clipping','off')
t10=text(ax4,0.5,-4,2,'FLEXORS','FontSize',8);
t11=text(ax4,0.5,-6,2,'EXTENSORS','FontSize',8);


%hold(ax2)
plot(ax2,[0.25 1.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[2.25 5.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[6.25 7.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[8.25 11.75]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[1 4.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[5.2 7.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[8 10.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[11.2 13.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[14 14.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[15.2 15.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[16 19.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[20.2 22.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[23 25.6],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[26.2 28.8],'Color',[0.5 0.5 0.5],'LineWidth',3,'Clipping','off')
plot(ax2,[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',3,'Clipping','off')
t1=text(ax2,-0.1,0,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t2=text(ax2,-0.1,6,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t3=text(ax2,-0.1,12,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
t4=text(ax2,-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t5=text(ax2,-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',8,'FontWeight','Bold');
t6=text(ax2,-0.1,12+15,2,'HIP','Rotation',90,'FontSize',8,'FontWeight','Bold');
plot(ax2,[-0.17 -0.17],[0 14.9],'LineWidth',3,'Color',[0.466 0.674 0.188],'Clipping','off')
plot(ax2,[-0.17 -0.17],[15.1 30],'LineWidth',3,'Color',[0.85,0.325,0.098],'Clipping','off')
t7=text(ax2,-0.27,6,2,'FAST','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',8,'FontWeight','Bold');
t8=text(ax2,-0.27,21,2,'SLOW','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',8,'FontWeight','Bold');
plot(ax2,[0.2 0.4],[-4 -4],'LineWidth',3,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax2,[0.2 0.4],[-6 -6],'LineWidth',3,'Color','k','Clipping','off')
t10=text(ax2,0.5,-4,2,'FLEXORS','FontSize',8);
t11=text(ax2,0.5,-6,2,'EXTENSORS','FontSize',8);

 set(gcf,'Renderer','painters');
