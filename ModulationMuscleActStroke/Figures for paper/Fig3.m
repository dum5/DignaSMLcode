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
        %patientsUnbiased2=patients2.removeBadStrides.removeBias;
        %controlsUnbiased2=controls2.removeBadStrides.removeBias;   
end

groups{1}=controls2;
groups{2}=patients2;
colors=[0.4 0.7 0.7;0.9 0.5 0.9];

eF=1;
eL=5;
% eps=defineEpochs({'Base','eA','lA','eP','lP'},{'TM base','Adaptation','Adaptation','Washout','Washout'},[-40 15 -40 15 -40],...
%     [eF,eF,eF,eF,eF],[eL,eL,eL,eL,eL],'nanmean');

eps=defineEpochs({'Base','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 15 -40 15],...
    [eF,eF,eF,eF],[eL,eL,eL,eL],'nanmean');
labels={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};


%[fh,ph,allData]=plotGroupedTimeAndEpochBars(adaptDataGroups,labels,epochs,binwidth,trialMarkerFlag,indivFlag,indivSubs,colorOrder,biofeedback,groupNames,medianFlag);
[fh,ph,allData]=adaptationData.plotGroupedTimeAndEpochBars(groups,labels,eps,10,0,0,0,colors,0,{'control','stroke'},0,1,0,0.05,0,0,1,0);
fullscreen

%get epoch data and generate data for plot
for i=1:length(groups)
    contrasts{i}=table;
    for p=1:length(labels) 
        contrasts{i}.(['eA_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(2,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
        contrasts{i}.(['lA_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(3,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
        contrasts{i}.(['lA_eA_',labels{p}])=squeeze(groups{i}.getEpochData(eps(3,:),labels{p})-groups{i}.getEpochData(eps(2,:),labels{p}));
        contrasts{i}.(['eP_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(4,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
    end    
end
contrastnames={'eA_B','lA_B','lA_eA','eP_B'};

spatialDataControls=NaN(15,4);
spatialDataStroke=NaN(15,4);
temporalDataControls=NaN(15,4);
temporalDataStroke=NaN(15,4);
velocityDataControls=NaN(15,4);
velocityDataStroke=NaN(15,4);
netDataControls=NaN(15,4);
netDataStroke=NaN(15,4);

for c=1:length(contrastnames)
    spatialDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','spatialContributionNorm2']);
    spatialDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','spatialContributionNorm2']);
    temporalDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','stepTimeContributionNorm2']);
    temporalDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','stepTimeContributionNorm2']);
    velocityDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','velocityContributionNorm2']);
    velocityDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','velocityContributionNorm2']);
    netDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','netContributionNorm2']);
    netDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','netContributionNorm2']);
    
end

%run paired t-test stats with Bonferroni correction for each parameter
stat=table;
stat.param=repmat({''},length(contrastnames)*length(labels),1);
row=1;
for l=1:length(labels)
    for c=1:length(contrastnames)
        stat.param(row)=labels(l);
        stat.contrast(row)=contrastnames(c);
        [h,p,ci]=ttest2(contrasts{1}.([contrastnames{c},'_',labels{l}]),contrasts{2}.([contrastnames{c},'_',labels{l}]));
        stat.meandif(row)=nanmean(contrasts{1}.([contrastnames{c},'_',labels{l}]))-nanmean(contrasts{2}.([contrastnames{c},'_',labels{l}]));
        stat.lowerbound(row)=ci(1);
        stat.upperboutn(row)=ci(2);
        stat.pval(row)=p;
        stat.pvalBonferroni(row)=p*length(contrastnames);   
        row=row+1;
        
    end
end


%Make figure pretty and add between epoch bars

%Move to the right
pos=get(ph(1,1),'Position');pos(1)=0.03;pos(3)=0.45;set(ph(1,1),'Position',pos);
pos=get(ph(2,1),'Position');pos(1)=0.03;pos(3)=0.45;set(ph(2,1),'Position',pos);
pos=get(ph(3,1),'Position');pos(1)=0.03;pos(3)=0.45;set(ph(3,1),'Position',pos);
pos=get(ph(4,1),'Position');pos(1)=0.03;pos(3)=0.45;set(ph(4,1),'Position',pos);
xl=get(ph(1,1),'XLim');
set(ph(:,1),'XLim',[100 xl(2)-200])

pos=get(ph(1,2),'Position');pos(1)=0.51;set(ph(1,2),'Position',pos);%pos(1)=0.76;ph(1,3)=axes('Position',pos);
pos=get(ph(2,2),'Position');pos(1)=0.51;set(ph(2,2),'Position',pos);%pos(1)=0.76;ph(2,3)=axes('Position',pos);
pos=get(ph(3,2),'Position');pos(1)=0.51;set(ph(3,2),'Position',pos);%pos(1)=0.76;ph(3,3)=axes('Position',pos);
pos=get(ph(4,2),'Position');pos(1)=0.51;set(ph(4,2),'Position',pos);%pos(1)=0.76;ph(4,3)=axes('Position',pos);

legend(ph(4,1),'off')

cla(ph(1,2));cla(ph(2,2));cla(ph(3,2));cla(ph(4,2));

set(ph(:,:),'FontSize',16,'TitleFontSizeMultiplier',1.1,'box','off');


%generate plots for between epoch measures
xval=[1 2;4 5;7 8;10 11];
nc=size(spatialDataControls,1);
ns=size(spatialDataStroke,1);
%hold(ph(1,2));
bar(ph(1,2),xval(:,1),nanmean(spatialDataControls),'FaceColor',colors(1,:),'BarWidth',0.2)
errorbar(ph(1,2),xval(:,1),nanmean(spatialDataControls),nanstd(spatialDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(1,2),xval(:,2),nanmean(spatialDataStroke),'FaceColor',colors(2,:),'BarWidth',0.2)
errorbar(ph(1,2),xval(:,2),nanmean(spatialDataStroke),nanstd(spatialDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(1,2),nanmean(xval([2:4],:),2),[0.15 0.15 0.15],'LineStyle','none','LineWidth',2,'Marker','*','Color','k','MarkerSize',12)
ll=findobj(ph(1,2),'Type','Bar');
legend(ll(end:-1:1),{'CONTROL','STROKE'},'box','off')


%hold(ph(2,2));
bar(ph(2,2),xval(:,1),nanmean(temporalDataControls),'FaceColor',colors(1,:),'BarWidth',0.2)
errorbar(ph(2,2),xval(:,1),nanmean(temporalDataControls),nanstd(temporalDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(2,2),xval(:,2),nanmean(temporalDataStroke),'FaceColor',colors(2,:),'BarWidth',0.2)
errorbar(ph(2,2),xval(:,2),nanmean(temporalDataStroke),nanstd(temporalDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(2,2),nanmean(xval([1:3],:),2),[0.15 0.15 0.15],'LineStyle','none','LineWidth',2,'Marker','*','Color','k','MarkerSize',12)

%hold(ph(3,2));
bar(ph(3,2),xval(:,1),nanmean(velocityDataControls),'FaceColor',colors(1,:),'BarWidth',0.2)
errorbar(ph(3,2),xval(:,1),nanmean(velocityDataControls),nanstd(velocityDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(3,2),xval(:,2),nanmean(velocityDataStroke),'FaceColor',colors(2,:),'BarWidth',0.2)
errorbar(ph(3,2),xval(:,2),nanmean(velocityDataStroke),nanstd(velocityDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(3,2),nanmean(xval([1 2 4],:),2),[-0.35 -0.35 0.1],'LineStyle','none','LineWidth',2,'Marker','*','Color','k','MarkerSize',12)

%hold(ph(4,2));
bar(ph(4,2),xval(:,1),nanmean(netDataControls),'FaceColor',colors(1,:),'BarWidth',0.2)
errorbar(ph(4,2),xval(:,1),nanmean(netDataControls),nanstd(netDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(4,2),xval(:,2),nanmean(netDataStroke),'FaceColor',colors(2,:),'BarWidth',0.2)
errorbar(ph(4,2),xval(:,2),nanmean(netDataStroke),nanstd(netDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(4,2),nanmean(xval([1:4],:),2),[-0.35 -0.35 0.15 0.15],'LineStyle','none','LineWidth',2,'Marker','*','Color','k','MarkerSize',12)
%set titles and labels
set(ph(:,2),'XTick',nanmean(xval,2),'XTickLabel',{''},'XLim',[0.5 11.5],'YTickLabel',{''})
set(ph(4,2),'XTickLabel',{'eA_B_A_S_E','lA_B_A_S_E','lA_e_A','eP_B_A_S_E'})
set(ph(:,1),'XTick',[115 362 625])
set(ph(4,1),'XTickLabel',{'BASE','ADAPTATION','POST-ADAPTATION'})

set(ph(1,:),'YLim',[-0.1 0.2],'YTick',[-0.1 0 0.1 0.2])
set(ph(2,:),'YLim',[-0.05 0.2],'YTick',[0 0.1 0.2])
set(ph(3,:),'YLim',[-0.4 0.2],'YTick',[-0.4 -0.2 0 0.2])
set(ph(4,:),'YLim',[-0.4 0.2],'YTick',[-0.4 -0.2 0 0.2])

title(ph(1,1),'StepPosition')
title(ph(2,1),'StepTime')
title(ph(3,1),'StepVelocity')
title(ph(4,1),'StepAsym')
title(ph(1,2),'StepPosition')
title(ph(2,2),'StepTime')
title(ph(3,2),'StepVelocity')
title(ph(4,2),'StepAsym')



%set(fh,'Position',[0 0 250 250])