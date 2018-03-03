function [newAdaptData]=fcnTransferGaitEventsP0008(oldExpData)

%load file with old gait events
load('Z:\SubjectData\E01 Synergies\mat\old\wSpikeRemoval\P0008.mat')
refEvents=expData;
clear expData


%replace gait events in new data
for i=1:length(oldExpData.data)
    oldExpData.data{i}.gaitEvents=refEvents.data{i}.gaitEvents;
end

%recompute parameters
newExpData=oldExpData.flushAndRecomputeParameters;
newAdaptData=newExpData.makeDataObj;


