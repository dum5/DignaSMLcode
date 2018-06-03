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

%patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
%controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s

eF=1;
eL=1;
rep=defineEpochs({'Base'},{'TM base'},-40,eF,eL,'nanmean');
eps=defineEpochs({'eA','lA','eP',},{'Adaptation','Adaptation','Washout'},[15 -40 15],...
    [eF,eF,eF],[eL,eL,eL],'nanmean');


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
        %patientsUnbiased2=patients2.removeBadStrides.removeBias;
        %controlsUnbiased2=controls2.removeBadStrides.removeBias; 
        controls2 = controls2.removeBaselineEpoch(rep,[]);
        patients2 = patients2.removeBaselineEpoch(rep,[]);
        
end

groups{1}=controls2;
groups{2}=patients2;


% eps=defineEpochs({'Base','eA','lA','eP','lP'},{'TM base','Adaptation','Adaptation','Washout','Washout'},[-40 15 -40 15 -40],...
%     [eF,eF,eF,eF,eF],[eL,eL,eL,eL,eL],'nanmean');



[SPmodel,SPbtab,SPwtab,SPmaineff,SPposthocGroup,SPposthocEpoch,SPposthocEpochByGroup,SPposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'spatialContributionPNorm',eps,0.05);

[STmodel,STbtab,STwtab,STmaineff,STposthocGroup,STposthocEpoch,STposthocEpochByGroup,STposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'stepTimeContributionPNorm',eps,0.05);

[SVmodel,SVbtab,SVwtab,SVmaineff,SVposthocGroup,SVposthocEpoch,SVposthocEpochByGroup,SVposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'velocityContributionPNorm',eps,0.05);

[NETmodel,NETbtab,NETwtab,NETmaineff,NETposthocGroup,NETposthocEpoch,NETposthocEpochByGroup,NETposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'netContributionPNorm',eps,0.05);

[AFmodel,AFbtab,AFwtab,AFmaineff,AFposthocGroup,AFposthocEpoch,AFposthocEpochByGroup,AFposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'alphaFast',eps,0.05);

[ASmodel,ASbtab,ASwtab,ASmaineff,ASposthocGroup,ASposthocEpoch,ASposthocEpochByGroup,ASposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'alphaSlow',eps,0.05);

[XFmodel,XFbtab,XFwtab,XFmaineff,XFposthocGroup,XFposthocEpoch,XFposthocEpochByGroup,XFposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'XFast',eps,0.05);

[XSmodel,XSbtab,XSwtab,XSmaineff,XSposthocGroup,XSposthocEpoch,XSposthocEpochByGroup,XSposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groups,{'controls','stroke'},'XSlow',eps,0.05);





