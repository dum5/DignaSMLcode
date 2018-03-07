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
        patientsUnbiased2=patients2.removeBadStrides.removeBias;
        controlsUnbiased2=controls2.removeBadStrides.removeBias;   
end

groups{1}=controlsUnbiased2;
groups{2}=patientsUnbiased2;

eF=1;
eL=5;
eps=defineEpochs({'Base','eA','lA','eP','lP'},{'TM base','Adaptation','Adaptation','Washout','Washout'},[-40 15 -40 15 -40],...
    [eF,eF,eF,eF,eF],[eL,eL,eL,eL,eL],'nanmean');
labels={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};


%[fh,ph,allData]=plotGroupedTimeAndEpochBars(adaptDataGroups,labels,epochs,binwidth,trialMarkerFlag,indivFlag,indivSubs,colorOrder,biofeedback,groupNames,medianFlag);
[fh,ph,allData]=adaptationData.plotGroupedTimeAndEpochBars(groups,labels,eps,5,0,0,0,[0 1 0;1 0 0],0,{'control','stroke'},0);