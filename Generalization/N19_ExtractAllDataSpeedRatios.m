%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script extracts the grouped outcomes and timecourses            %
% Input: Datafile created by UICreateStudy                            %
%                                                                     %
%                                                                     %
% Output: - groupOutcomes        nParams,nEpochs,nSubjects)           %
%         - timeCourse           timeCourse(group),param(p).cond(c)   %
%         - timeCourseUnbiased                                        %
%         - NEpochOutcomes       outcomes that are not based on epochs%
%                                NEpochOutcomes(group).param(p)       %     
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

clear NonEpochoutcome groups timeCourse timeCourseUnbiased
% This section calculates the parameters we wanted to compute. First lines

%[file,path]=uigetfile('Z:\Users\Wouter\Generalization Young\Paramfiles Study after ReviewEventGui\*.mat','choose file to load');
[file,path]=uigetfile('Z:\Users\Digna\Projects\Generalization\3to1VS2to1\*.mat','choose file to load');


load([path,file]);

%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groups{i}=eval(['studyData.',groupsnames{i}]);
    %groups{i}.groupID=groupsnames{i};This is not allowed for
    %groupAdaptationData
    groups{i}=groups{i}.removeBadStrides;
    groups{i}=groups{i}.removeBias;
end

% %define epochs
% eF=1;%this is used for adaptation
% eFbase=0;% this is used for base only to get similar values as before, since we take the median it does not matter if first one is an outlier
% eLBase=1;
% eLAdap=10;%strides exempt for late adaptation
% eLOGP=1;
% nEA=5;%number of strides to characterize early adaptation
% nLateAdap=-50;%number of strides for late adaptation
% nLateOGp=-20;
% nbase=90;%number of strides for TM base and OG base
% nafter=5;%number of strides for after effects
% nslow=50;%number of strides for slow baseline
% eFSlowbase=0;%consider changing strides for ref base (-40), since that is more consistent with code procedures
% 
% 
% names={'OG_B','TM_B','OG_P','OG_LP','TM_P','lateAdapt','lateReadapt','earlyAdapt','FullSplit','EarlyReadapt','TM slowref'};
% 
% conds={'OG base','TM base', 'OG post','OG post', 'TM post', 'gradual adaptation', 'readaptation', 'gradual adaptation','gradual adaptation','readaptation','TM slow'};
% strideNo=[nbase nbase nafter nLateOGp nafter nLateAdap nLateAdap nEA nEA nEA nslow];
% exemptLast=[eLBase eLBase 0 eLOGP 0 eLAdap eLAdap 0 0 0 0];
% summethods=({'nanmedian','nanmedian','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean'});
% 
% %extract data for epochs and subtract reference condition and remove
% %appropriate bias
% params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2','FyPSmax'};
% correctTMbase=1:4;%indices of parameters that need to be corrected for TM base
% correctTMslow=5;%indices of parameters that need to be corrected for TM slow
% 
% OGind=[3,4];%epoch associated with OGpost
% TMind=[5:10];%epoch associated with treadmill trials, except the reference trial

epsData=defineEpochs({'TMafter'},{'TM post'},5,1,0,'nanmean');
params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};

for i=1:length(groups)
    groupOutcomes{i}=groups{i}.getEpochData(epsData,params);
   
    
    
end

%extract timecourses

[timeCourse]=getGroupedTimeCourses(groups,{'adaptation'},params);
timeCourseUnbiased=timeCourse;

%Add additional parameters not computed in epochs and store that in separate variable
params2={'maxError','meanError','strideMonIncrease','ErrorFromMonIncrese'};

%find index for gradual adaptation
cInd=NaN(2,1);
tpInd=NaN;

tpInd = strfind(params,'netContributionNorm2');ParInd = find(not(cellfun('isempty', tpInd)));

for i=1:length(groups)
    %initialize matrices for data
    NonEpochoutcome{i}.par{1}=NaN(length(groups{i}.adaptData),1);
    NonEpochoutcome{i}.par{2}=NaN(length(groups{i}.adaptData),1);
    NonEpochoutcome{i}.par{3}=NaN(length(groups{i}.adaptData),1);    
    NonEpochoutcome{i}.par{4}=NaN(length(groups{i}.adaptData),1);
   
    
    %first get gradualAdaptation and readaptation
    tempdata=cell2mat(timeCourseUnbiased{i}.param{ParInd}.cond(1));%gradual adaptation
   
    
    %extract parameters for all subjects
    for sj=1:length(groups{i}.adaptData)   
        dt=tempdata(:,sj);                
        % Maximum error        
        NonEpochoutcome{i}.par{1}(sj,1)=-1*(findmaxAV(dt.*-1,1,15,5));%in time window 15 strides of full ramp    
            
        % Mean error adaptation
        dt3=dt(1:(find(~isnan(dt),1,'last')));
        dt3=dt3(1:end-10);
        NonEpochoutcome{i}.par{2}(sj,1)=nanmean(dt3);
         
         %Index start monotonic increase
         dt2 = medfilt1(dt(1:end),5);
         tempout=find_strides_to_ignore(dt2,5,1,0);%look for first 5 strides of monotonic increase starting from full split
         if ~isempty(tempout)
             NonEpochoutcome{i}.par{3}(sj,1)=tempout;

             %determine error of 5 strides monotonic increase
             NonEpochoutcome{i}.par{4}(sj,1)=nanmean(dt2(NonEpochoutcome{i}.par{3}(sj,1)+1:NonEpochoutcome{i}.par{3}(sj,1)+5));
         end
             clear dt dt2 dt3 dt4 tempout
         
    end
    clear tempdata
end

clear tcInd tpInd cInd ParInd
