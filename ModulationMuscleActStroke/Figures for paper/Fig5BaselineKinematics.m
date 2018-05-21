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
        %patients2=patients2.removeBadStrides;
        %controls2=controls2.removeBadStrides;
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
eL=1;
nstrides=-40;
[reps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanmean');
[meps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanmean');
[seps] = defineEpochs({'Base'},{'TM base'}',[nstrides],[eE],[eL],'nanstd');

paramList={'spatialContribution','stepTimeContribution','velocityContribution','netContribution'};
suffix='PNorm';
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
[~,Idx]=sort(patientData(4,1,:));Idx=squeeze(Idx);%sort patients according to ascending net
patientData(1:4,1,:)=patientData(1:4,1,Idx);
varPatientData(1:4,1,:)=varPatientData(1:4,1,Idx);
FM=FM(Idx);

upperbound = nanmean(controlData,3) + 2*std(squeeze(controlData)')';
lowerbound = nanmean(controlData,3) - 2*std(squeeze(controlData)')';

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
xval(end,:)=xval(end,:)+2.5;
paramList2={'StepPosition','StepTime','StepVelocity','StepAsym'};

%generate xlabels
for pt=1:length(patients2.adaptData)
    xlab{pt}=['P ',num2str(pt)];
end
xlab{pt+1}='CONTROL';


f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 12 4]);
% 
% ax1 = axes('Position',[0.0394    0.6879    0.9501    0.2766],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for kinematic data
% ax2 = axes('Position',[0.4850   0.0990    0.2237    0.4772],'FontSize',12);%create axis for control checkerboard
% ax3 = axes('Position',[0.7174    0.0990    0.2237    0.4772],'FontSize',12);%create axis for patient checkerboard
% ax4 = axes('Position',[0.04   0.0804    0.3493    0.5063],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for scatterplot



ax1 = axes('Position',[0.06 0.08 0.63 0.79],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for kinematic data
ax4 = axes('Position',[0.77 0.18 0.21 0.69],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for scatterplot
%Individual subject bars
hold(ax1)
for p=1:length(paramList)
    bar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],'FaceColor',ccd(p,:),'BarWidth',0.15)
    errorbar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],...
        [squeeze(varPatientData(p,1,:))./sqrt(abs(nstrides));nanstd(controlData(p,1,:))./sqrt(length(controls2.adaptData))],'LineWidth',2,'LineStyle','none','Color','k')
    %add significance
    for pt=1:length(patients2.adaptData)
        if patientData(p,1,pt) > upperbound(p,1) || patientData(p,1,pt) < lowerbound(p,1)
            plot(ax1,xval(pt,p),-0.25,'*k','Color',ccd(p,:),'MarkerSize',8)
        end
    end
    
end
set(ax1,'XTick',mean(xval,2),'XTickLabel',xlab,'XLim',[0 max(max(xval))+min(min(xval))],'YLim',[-0.3 0.6],'YTick',[-0.3 0 0.3 0.6])
h=ylabel(ax1,'ASYMMETRY');set(h,'FontSize',14)
ll=findobj(ax1,'Type','Bar');
h=legend(ll(fliplr(1:length(ll))),paramList2);set(h,'Position',[0.064 0.78 0.52 0.074])
set(h,'Box','off','FontSize',14,'Orientation','horizontal')
h=title(ax1,'INDIVIDUAL SUBJECT KINEMATIC BEHAVIOR');set(h,'FontSize',16)





%scatterplot
hold(ax4)
plot(ax4,FM,squeeze(patientData(2,1,:)),'ok','markerSize',10,'MarkerFaceColor',ccd(2,:))
l=lsline(ax4);set(l,'LineWidth',2,'Color',[0.5 0.5 0.5]);
[RHO,PVAL] = corr(FM',squeeze(patientData(2,1,:)),'Type','Spearman');
t=text(ax4,21,0.03,['RHO = ',num2str(round(RHO,2)),', p = ',num2str(round(PVAL,2))]);set(t,'FontSize', 14);
h=xlabel(ax4,'FUGL-MEYER SCORE');set(h,'FontSize',14);h=ylabel(ax4,'STEP TIME ASYM');set(h,'FontSize',14)
h=title(ax4,'STEP TIME ASYMMETRY');set(h,'FontSize',16)
set(ax4,'XTick',[20 25 30 35],'XLim',[20 35],'YTick',[-0.2 -0.1 0 0.1])

%% Save Figure
% saveFig(f1,cd, 'Fig2',1)
% print('Fig2','-painters','-dsvg')
% print('Fig2','-dtiff')