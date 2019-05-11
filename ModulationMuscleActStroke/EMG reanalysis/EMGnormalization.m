clear all 
close all

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)


mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%mOrder={'TA','SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF'};
nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names

baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[1],[1],'nanmedian');


patients=normalizeToBaselineEpoch(patients,labelPrefixLong,baseEp,0);
controls=normalizeToBaselineEpoch(controls,labelPrefixLong,baseEp,0);