clear all 
close all

load('Z:\SubjectData\E01 Synergies\mat\old\wSpikeRemoval\P0008.mat')
refEvents=expData;
clear expData

load('Z:\SubjectData\E01 Synergies\mat\HPF200\P0008.mat')

for i=1:length(expData.data)
    expData.data{i}.gaitEvents=refEvents.data{i}.gaitEvents;
end

expData=expData.flushAndRecomputeParameters;
adaptData=expData.makeDataObj;

load('Z:\SubjectData\E01 Synergies\mat\HPF200\groupedParams_wMissingParameters.mat')

%load group data firs
patients.adaptData{8}=adaptData;
