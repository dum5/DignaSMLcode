%% Assuming that the variables groups() exists (From N19_loadGroupedData)
clear all
close all
%% read data
[loadName,matDataDir]=uigetfile('*.mat');
%%
matchSpeedFlag=0;
removeMissing=false;

loadName=[matDataDir,loadName]; 
load(loadName)

patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s


removeP07Flag=1;
if removeP07Flag
    patients2=patients.removeSubs({'P0007'});
    controls2=controls.removeSubs({'C0007'});
    %patientsUnbiased2=patients2.removeBias;
    %controlsUnbiased2=controls2.removeBias;
end
switch matchSpeedFlag
    case 1 %Speed matched groups
        patients2=patients2.getSubGroup(patientFastList).removeBadStrides;
        controls2=controls2.getSubGroup(controlsSlowList).removeBadStrides;
        %patientsUnbiased2=patientsUnbiased2.getSubGroup(patientFastList).removeBadStrides;
        %controlsUnbiased2=controlsUnbiased2.getSubGroup(controlsSlowList).removeBadStrides;
    case 0 %Full groups
        patients2=patients2.removeBadStrides;
        controls2=controls2.removeBadStrides;
        %patientsUnbiased2=patientsUnbiased2.removeBadStrides;
        %controlsUnbiased2=controlsUnbiased2.removeBadStrides; 
    
end



load([matDataDir,'bioData']) %speeds, ages and Fugl-Meyer
FM=FM([1:6 8:16]);%remove subject 7
%% Colormap:
%colorScheme
ccd=[0.6 0.3 0.5;0.95 0.7 0.13;0.5 0.8 0.2;0.3 0.75 0.93];

%% Parameters and conditions to plot
eE=1;
eL=5;
nstrides=-40;
[reps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanmedian');
[meps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanmean');
[seps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanstd');

paramList={'spatialContribution','stepTimeContribution','velocityContribution','netContribution'};
suffix='Norm2';
paramList=strcat(paramList,suffix);

%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%mOrder={'TA','SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF'};
nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names

%% get data of interest
%kinematic
patientData=getEpochData(patients2,meps,paramList,true);
controlData=getEpochData(controls2,meps,paramList,true);
varPatientData=getEpochData(patients2,seps,paramList,true);
varControlData=getEpochData(controls2,seps,paramList,true);

%EMG
%Renaming normalized parameters, for convenience:
ll=controls.adaptData{1}.data.getLabelsThatMatch('^Norm');
l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
controls2=controls2.renameParams(ll,l2);
patients2=patients2.renameParams(ll,l2);

newLabelPrefix=fliplr(strcat(labelPrefix,'s'));


%% Initialize figure
xData=1:size(patientData,3)+1;xData=xData*(length(paramList)+1);xData=xData-length(paramList);
for p=1:length(paramList)
    xval(:,p)=xData+(p-1)';
    
end
paramList2={'Step Position','Step Time','Step Velocity','Step Length'};

%generate xlabels
for pt=1:length(patients2.adaptData)
    xlab{pt}=['P ',num2str(pt)];
end
xlab{pt+1}='C';


f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6.5*1.5 6.5*1.5]);
% 
% ax1 = axes('Position',[0.0394    0.6879    0.9501    0.2766],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for kinematic data
% ax2 = axes('Position',[0.4850   0.0990    0.2237    0.4772],'FontSize',12);%create axis for control checkerboard
% ax3 = axes('Position',[0.7174    0.0990    0.2237    0.4772],'FontSize',12);%create axis for patient checkerboard
% ax4 = axes('Position',[0.04   0.0804    0.3493    0.5063],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for scatterplot



ax1 = axes('Position',[0.0769   0.6879    0.8632    0.2766],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for kinematic data
ax2 = axes('Position',[0.4650    0.1763    0.2237    0.3999],'FontSize',12);%create axis for control checkerboard
ax3 = axes('Position',[0.6974    0.1784    0.2237    0.3978],'FontSize',12);%create axis for patient checkerboard
ax4 = axes('Position',[0.0769    0.1549    0.3124    0.4318],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for scatterplot
%Individual subject bars
hold(ax1)
for p=1:length(paramList)
    bar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],'FaceColor',ccd(p,:),'BarWidth',0.15)
    errorbar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],...
        [squeeze(varPatientData(p,1,:))./sqrt(abs(nstrides));nanstd(controlData(p,1,:))./sqrt(length(controls2.adaptData))],'LineWidth',2,'LineStyle','none','Color','k')
end
set(ax1,'XTick',mean(xval,2),'XTickLabel',xlab,'XLim',[0 max(max(xval))+min(min(xval))],'YLim',[-0.3 0.6],'YTick',[-0.3 0 0.3 0.6])
h=ylabel(ax1,'ASYMMETRY');set(h,'FontSize',16)
ll=findobj(ax1,'Type','Bar');
h=legend(ll(fliplr(1:length(ll))),paramList2);
set(h,'Box','off','FontSize',14,'Orientation','horizontal')
h=title(ax1,'INDIVIDUAL SUBJECT KINEMATIC BEHAVIOR');set(h,'FontSize',16)


%checkerboards
[f1,ax2,labels,dataEc,dataRefc]=plotCheckerboards(controls2,newLabelPrefix,reps,f1,ax2,[],true,'nanmedian');
[f1,ax3,labels,dataEp,dataRefp]=plotCheckerboards(patients2,newLabelPrefix,reps,f1,ax3,[],true,'nanmedian');
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

set(ax2,'FontSize',12,'CLim',[0 1],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
set(ax3,'FontSize',12,'CLim',[0 1],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','STANCE','DS','SWING'})
colorbar('peer',ax3);
map=flipud(repmat([0.3:0.01:1]',1,3));
set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[0.6974   0.1107    0.2237    0.0264];
set(cc,'Ticks',[0 .5 1],'FontSize',16,'FontWeight','bold');
set(cc,'TickLabels',{'0%','50%','100%'});

h=title(ax2,'CONTROLS');set(h,'FontSize',14);h=title(ax3,'STROKE');set(h,'FontSize',14)

hold(ax2)
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
t9=text(ax2,0.5,33,2,'BASELINE ACTIVITY','Color','k','FontSize',16,'FontWeight','Bold','Clipping','off');
plot(ax2,[0 0.3],[-3 -3],'LineWidth',10,'Color',[0.5 0.5 0.5],'Clipping','off')
plot(ax2,[0 0.3],[-5 -5],'LineWidth',10,'Color','k','Clipping','off')
t10=text(ax2,0.35,-3,2,'FLEXORS','FontSize',14);
t11=text(ax2,0.35,-5,2,'EXTENSORS','FontSize',14);

hold(ax3)
plot(ax3,[0.1 1.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[2.1 5.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[6.1 7.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')
plot(ax3,[8.1 11.9]./12,[-0.2 -0.2],'Color','k','LineWidth',3,'Clipping','off')


%scatterplot
hold(ax4)
plot(ax4,FM,squeeze(patientData(2,1,:)),'ok','markerSize',10,'MarkerFaceColor',ccd(2,:))
l=lsline(ax4);set(l,'LineWidth',2,'Color',[0.5 0.5 0.5]);
[RHO,PVAL] = corr(FM',squeeze(patientData(2,1,:)),'Type','Spearman');
t=text(ax4,21,0.03,['RHO = ',num2str(round(RHO,2)),', p = ',num2str(round(PVAL,2))]);set(t,'FontSize', 16);
h=xlabel(ax4,'FUGL-MEYER SCORE');set(h,'FontSize',16);h=ylabel(ax4,'STEP TIME ASYM');set(h,'FontSize',16)
h=title(ax4,'STEP TIME ASYMMETRY');set(h,'FontSize',16)
set(ax4,'XTick',[20 25 30 35],'XLim',[20 35],'YTick',[-0.2 -0.1 0 0.1])

%% Save Figure
saveFig(f1,cd, 'Fig2',1)
print('Fig2','-painters','-dsvg')
print('Fig2','-dtiff')