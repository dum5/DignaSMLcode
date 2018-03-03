% make figures of propulsion 

clear all
close all

load('Z:\Users\Digna\Projects\Effort study\ReprocessedDataForces\AllControlsEffort.mat')

AllData=studyData.AllControlsEffort;

for i=1:length(AllData.adaptData)
    if strcmp(AllData.adaptData{i}.subData.dominantLeg,'Right')
        dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf minTwelve');rightPmax(1)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf minSix');rightPmax(2)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf baseline');rightPmax(3)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf plusSix');rightPmax(4)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf plusTwelve');rightPmax(5)=nanmean(dt(5:end-5));clear dt
        
        dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf minTwelve');leftPmax(1)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf minSix');leftPmax(2)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf baseline');leftPmax(3)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf plusSix');leftPmax(4)=nanmean(dt(5:end-5));clear dt
        dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf plusTwelve');leftPmax(5)=nanmean(dt(5:end-5));clear dt
        
        meandataright(:,i)=rightPmax';clear rightPmax
        meandataleft(:,i)=leftPmax';clear leftPmax
        
    else
    end
    dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf minTwelve');rightPmax(1)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf minSix');rightPmax(2)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf baseline');rightPmax(3)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf plusSix');rightPmax(4)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPSmax','bf plusTwelve');rightPmax(5)=nanmean(dt(5:end-5));clear dt

    dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf minTwelve');leftPmax(1)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf minSix');leftPmax(2)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf baseline');leftPmax(3)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf plusSix');leftPmax(4)=nanmean(dt(5:end-5));clear dt
    dt=AllData.adaptData{i}.getParamInCond('FyPFmax','bf plusTwelve');leftPmax(5)=nanmean(dt(5:end-5));clear dt

    meandataright(:,i)=rightPmax';clear rightPmax
    meandataleft(:,i)=leftPmax';clear leftPmax
end