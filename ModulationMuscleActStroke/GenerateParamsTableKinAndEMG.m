%%Generate ParamsTable
clear all
close all
clc


%In this version the following has been updated
% - Patient selection has changed according to what we agreed on in Sept 2018
% - All subjects are used to generate the table, selection will depend on
%   speedmatchFlag in subsequent scripts


%% read data
matDataDir='C:\Users\did35\OneDrive - University of Pittsburgh\Projects\Modulation of muscle activity in stroke\GroupData\';
%matDataDir='D:\Documents\OnedrivePitt\OneDrive - University of Pittsburgh\Projects\Modulation of muscle activity in stroke\GroupData\'
fileName='groupedParamsForKinAnalysis';
%%
loadName=[matDataDir,fileName]; 
load(loadName)


eF=1;
eL=1;

eps=defineEpochs({'Base','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 5 -40 5],...
    [eF,eF,eF,eF],[eL,eL,eL,eL],'nanmedian');
labels={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2','alphaFast','alphaSlow','xFast','xSlow'};

t=table;
t.group=cell(32,1);
t.group(1:16,1)={'Control'};
t.group(17:32,1)={'Stroke'};
t.group=nominal(t.group);
t.ID=[controls.ID';patients.ID'];


%% Contributions Data (no patients are removed here)
for p=1:length(labels) 
        for e=1:length(eps)
            t.([cell2mat(eps(e,:).Properties.ObsNames),'_',labels{p}])=[squeeze(controls.getEpochData(eps(e,:),labels{p}));...
                squeeze(patients.getEpochData(eps(e,:),labels{p}))];
        end

       
        t.(['eA_B_',labels{p}])=[squeeze(controls.getEpochData(eps(2,:),labels{p})-controls.getEpochData(eps(1,:),labels{p}));...
            squeeze(patients.getEpochData(eps(2,:),labels{p})-patients.getEpochData(eps(1,:),labels{p}))];
        t.(['lA_B_',labels{p}])=[squeeze(controls.getEpochData(eps(3,:),labels{p})-controls.getEpochData(eps(1,:),labels{p}));...
            squeeze(patients.getEpochData(eps(3,:),labels{p})-patients.getEpochData(eps(1,:),labels{p}))];
        t.(['eP_lA_',labels{p}])=[squeeze(controls.getEpochData(eps(4,:),labels{p})-controls.getEpochData(eps(3,:),labels{p}));...
            squeeze(patients.getEpochData(eps(4,:),labels{p})-patients.getEpochData(eps(3,:),labels{p}))];
        t.(['eP_B_',labels{p}])=[squeeze(controls.getEpochData(eps(4,:),labels{p})-controls.getEpochData(eps(1,:),labels{p}));...
            squeeze(patients.getEpochData(eps(4,:),labels{p})-patients.getEpochData(eps(1,:),labels{p}))];
end 

%load datafile for EMG
clear patients controls 

fileName='groupedParams30HzPT11Fixed';
loadName=[matDataDir,fileName]; 
load(loadName)

groups{1}=controls;
groups{2}=patients;

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

[dataE,EMGlabels,dummy]=getPrefixedEpochData(groups{1}.adaptData{1},newLabelPrefix,eps,1);
EMGlabels=EMGlabels(:);

for p=1:length(EMGlabels) 
    templabel=strrep(EMGlabels{p},' ','_');
        for e=1:length(eps)
            t.([cell2mat(eps(e,:).Properties.ObsNames),'_',templabel])=[squeeze(groups{1}.getEpochData(eps(e,:),EMGlabels{p}));...
                squeeze(groups{2}.getEpochData(eps(e,:),EMGlabels{p}))];                
        end
end

%Find out how many adaptation stride each subject has
t.nAdap=[getNumStridesInCond(groups{1},'Adaptation');getNumStridesInCond(groups{2},'Adaptation')];
t.nPost=[getNumStridesInCond(groups{1},'Washout');getNumStridesInCond(groups{2},'Washout')];
clear groups patients controls 

%load file with angles
fileName='groupParamsWithAngles';
%%
loadName=[matDataDir,fileName]; 
load(loadName)

%eps2=defineEpochs({'Base','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 5 -40 5],...
    [eF,eF,eF,eF],[eL,eL,eL,eL],'nanmedian');
for e=1:length(eps)
            t.([cell2mat(eps(e,:).Properties.ObsNames),'_skneeAngleAtSHS'])=[squeeze(controls.getEpochData(eps(e,:),'skneeAngleAtSHS'));...
                squeeze(patients.getEpochData(eps(e,:),'skneeAngleAtSHS'))];
             t.([cell2mat(eps(e,:).Properties.ObsNames),'_fkneeAngleAtFHS'])=[squeeze(controls.getEpochData(eps(e,:),'fkneeAngleAtFHS'));...
                squeeze(patients.getEpochData(eps(e,:),'fkneeAngleAtFHS'))];           
end

fileName='RegressionResults';
loadName=[matDataDir,fileName]; 
load(loadName)

demVars=tALL.Properties.VariableNames(2:end);
for d=1:length(demVars)
    t.(demVars{d})=tALL.(demVars{d});
end

        
