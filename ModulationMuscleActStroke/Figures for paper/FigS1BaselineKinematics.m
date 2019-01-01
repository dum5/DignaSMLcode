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




load([matDataDir,'bioData']) %speeds, ages and Fugl-Meyer

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
suffix='Norm2';
paramList=strcat(paramList,suffix);


%% get data of interest
%kinematic
patientData=getEpochData(patients,meps,paramList,true);
controlData=getEpochData(controls,meps,paramList,true);
varPatientData=getEpochData(patients,seps,paramList,true);
varControlData=getEpochData(controls,seps,paramList,true);
[~,Idx]=sort(patientData(4,1,:));Idx=squeeze(Idx);%sort patients according to ascending net
patientData(1:4,1,:)=patientData(1:4,1,Idx);
varPatientData(1:4,1,:)=varPatientData(1:4,1,Idx);
FM=FM(Idx);

upperbound = nanmean(controlData,3) + 2*std(squeeze(controlData)')';
lowerbound = nanmean(controlData,3) - 2*std(squeeze(controlData)')';


%% Initialize figure
xData=1:size(patientData,3)+1;xData=xData*(length(paramList)+1);xData=xData-length(paramList);
for p=1:length(paramList)
    xval(:,p)=xData+(p-1)';
    
end
xval(end,:)=xval(end,:)+2.5;
paramList2={'StepPosition','StepTime','StepVelocity','StepAsym'};

%generate xlabels
for pt=1:length(patients.adaptData)
    xlab{pt}=['P ',num2str(Idx(pt))];
end
xlab{pt+1}='CONTROL';


f1=figure;
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 3]);
% 
% ax1 = axes('Position',[0.0394    0.6879    0.9501    0.2766],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for kinematic data
% ax2 = axes('Position',[0.4850   0.0990    0.2237    0.4772],'FontSize',12);%create axis for control checkerboard
% ax3 = axes('Position',[0.7174    0.0990    0.2237    0.4772],'FontSize',12);%create axis for patient checkerboard
% ax4 = axes('Position',[0.04   0.0804    0.3493    0.5063],'FontSize',14,'FontWeight','Bold','Box','off');%create axis for scatterplot



ax1 = axes('Position',[0.06 0.08 0.9 0.8],'FontSize',8,'FontWeight','Bold','Box','off');%create axis for kinematic data

%Individual subject bars
hold(ax1)
for p=1:length(paramList)
    bar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],'FaceColor',ccd(p,:),'BarWidth',0.15)
    errorbar(ax1,xval(:,p),[squeeze(patientData(p,1,:));nanmean(controlData(p,1,:))],...
        [squeeze(varPatientData(p,1,:))./sqrt(abs(nstrides));nanstd(controlData(p,1,:))./sqrt(length(controls.adaptData))],'LineWidth',2,'LineStyle','none','Color','k')
    %add significance
    for pt=1:length(patients.adaptData)
        if patientData(p,1,pt) > upperbound(p,1) || patientData(p,1,pt) < lowerbound(p,1)
            plot(ax1,xval(pt,p),-0.8,'*k','Color',ccd(p,:),'MarkerSize',4)
        end
        if p==4
            plot([xval(pt,p)+1 xval(pt,p)+1],[-0.9 0.6],'--k','Color',[0.75 0.75 0.75])
        end
    end
    
end
set(ax1,'XTick',mean(xval,2),'XTickLabel',xlab,'XLim',[0 max(max(xval))+min(min(xval))],'YLim',[-0.9 0.8],'YTick',[-0.3 0 0.3 0.6])
h=ylabel(ax1,'ASYMMETRY');set(h,'FontSize',8)
ll=findobj(ax1,'Type','Bar');
h=legend(ll(fliplr(1:length(ll))),paramList2);set(h,'Position',[0.1116    0.8106    0.7384    0.0613])
set(h,'Box','off','FontSize',6,'Orientation','horizontal')
h=title(ax1,'INDIVIDUAL SUBJECT KINEMATIC BEHAVIOR');set(h,'FontSize',8)



