clear all
close all

%% Load if not calculated

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)

% strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0007','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
% controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0007','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, plus it has
groups{1}=controls;
groups{2}=patients;
removeMissing=false; %Nothing else is allowed
medflag=1;


%convert muscle names for P0008 to that of all other subjects
l1=groups{2}.getLabelsThatMatch('SAR');
l3=regexprep(l1,'SAR','HIP');
groups{2}=groups{2}.renameParams(l1,l3);


baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[0],[1],'nanmedian');


for j=[1,2]% strokes and controls
    %recompute parameters is needed because normalized params are not
    %present in 30 Hz Filtered Data
    
    %if medflag==1
    mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
    nMusc=length(mOrder);
    type='s';
    labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
    labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names
    groups{j}=groups{j}.normalizeToBaselineEpoch(labelPrefixLong,baseEp);    
    
    %Renaming some EMG-associated params (different names across subs)
   
    
    %Marking strides as bad if missing any muscle or contribution, removing bad strides:
%     label=groups{j}.adaptData{1}.data.getLabelsThatMatch('Contribution$')';
%     label2=groups{j}.adaptData{1}.data.getLabelsThatMatch('[s,f].+s\d+$')';
%     
    %Running median filter: (?)
    
    %Get consistent names for conditions:
   % replacementConditionNames
   
    
    %Check: commonConditions needs to include all of the newNames ?
    groups{j}.getCommonConditions
    
    %Generating normalized EMG parameters (so I don't have to recompute
    %everytime):
%     baseEp=getBaseEpoch; %defines baseEp
%     mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%     nMusc=length(mOrder);
%     type='s';
%     labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
%     labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names
%     groups{j}=groups{j}.normalizeToBaselineEpoch(labelPrefixLong,baseEp);
    
end

%normalize EMG parameters for P0008 only
 %Generating normalized EMG parameters (so I don't have to recompute
    %everytime):
    
    jklkllkj
%%
patients=groups{2};
controls=groups{1};
% GYAA=groups{4};
% GYRC=groups{5};
%patientsUp=groups{3};
%patientsUnbiased=groupsUnbiased{1};
%controlsUnbiased=groupsUnbiased{2};
%GYAAUnbiased=groupsUnbiased{4};
%GYRCUnbiased=groupsUnbiased{5};
%patientsUpUnbiased=groupsUnbiased{3};
clear groups*

%%
patients.adaptData{1}.metaData.conditionName{4}='TM base'; %P01 has bad condition name which confounds with TM mid when it exists.
%% Sanity check: 8 common conditions
if length(controls.getCommonConditions)<8 || length(patients.getCommonConditions)<6 || length(patients.removeSubs({'P0001','P0007','P0011'}).getCommonConditions)<8
    error('Groups do not have the 8 expected common conditions, some re-naming did NOT work')
    %For controls we expect: OG base, slow, mid, short, base, adapt, wash, OG post
    %For patients the same, except: short (not in P07,P11) , mid (not present in P01,P11)
end
%%
saveName=[matDataDir 'groupedParams'];
saveName=[saveName '_wMissingParameters'];
disp('Saving control+patient data...')
tic
save(saveName,'controls','patients','-v7.3')
disp('Done!')
toc
disp('Saving control+patient UNBIASED data...')
%tic
%save([saveName 'Unbiased'],'controlsUnbiased','patientsUnbiased','-v7.3')
%disp('Done!')
%toc

saveName=[matDataDir 'groupedParamsYOUNG'];
saveName=[saveName '_wMissingParameters'];

disp('Saving young subjects data...')
tic
%save(saveName,'GYAA','GYRC','-v7.3')
disp('Done!')
toc
disp('Saving young subjects UNBIASED data...')
%tic
%save([saveName 'Unbiased'],'GYAAUnbiased','GYRCUnbiased','-v7.3')
%disp('Done!')
%toc
%saveName=[saveName '_wUphill'];
%save(saveName,'controls','patients','patientsUp','-v7.3')
%save([saveName 'Unbiased'],'controlsUnbiased','patientsUnbiased','patientsUpUnbiased','-v7.3')