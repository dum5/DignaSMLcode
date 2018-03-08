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

%clear NonEpochoutcome groups timeCourse timeCourseUnbiased
% This section calculates the parameters we wanted to compute. First lines

%[file,path]=uigetfile('Z:\Users\Wouter\Generalization Young\Paramfiles Study after ReviewEventGui\*.mat','choose file to load');
[file,path]=uigetfile('Z:\SubjectData\E04 Generalization Young\*.mat','choose file to load');


load([path,file]);

%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groups{i}=eval(['studyData.',groupsnames{i}]);
    %groups{i}.groupID=groupsnames{i};This is not allowed for
    %groupAdaptationData
    groups{i}=groups{i}.removeBadStrides;
end


%define stride numbers associated with specific events in each protocol
startsplit=NaN(1,length(groups));fullsplit=NaN(1,length(groups));
for i=1:length(groups)
    if strcmp(groupsnames{i},'Gradual')
        startsplit(i)=150;
        fullsplit(i)=750;
    elseif strcmp(groupsnames{i},'FullAbrupt')
        startsplit(i)=0;
        fullsplit(i)=0;
    elseif strcmp(groupsnames{i},'AbruptNoFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
    elseif strcmp(groupsnames{i},'AbruptFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
    elseif strcmp(groupsnames{i},'Catch')
        startsplit(i)=150;
        fullsplit(i)=190;        
    end   
end

%define epochs
eF=1;%this is used for adaptation
eFbase=0;% this is used for base only to get similar values as before, since we take the median it does not matter if first one is an outlier
eLBase=1;
eLAdap=10;%strides exempt for late adaptation
eLOGP=1;
nEA=5;%number of strides to characterize early adaptation
nLateAdap=-50;%number of strides for late adaptation
nLateOGp=-20;
nbase=90;%number of strides for TM base and OG base
nafter=5;%number of strides for after effects
nslow=50;%number of strides for slow baseline
eFSlowbase=0;%consider changing strides for ref base (-40), since that is more consistent with code procedures


names={'OG_B','TM_B','OG_P','OG_LP','TM_P','lateAdapt','lateReadapt','earlyAdapt','FullSplit','EarlyReadapt','TM_slowref'};

conds={'OG base','TM base', 'OG post','OG post', 'TM post', 'gradual adaptation', 'readaptation', 'gradual adaptation','gradual adaptation','readaptation','TM slow'};
strideNo=[nbase nbase nafter nLateOGp nafter nLateAdap nLateAdap nEA nEA nEA nslow];
exemptLast=[eLBase eLBase 0 eLOGP 0 eLAdap eLAdap 0 0 0 0];
summethods=({'nanmedian','nanmedian','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean'});

%extract data for epochs and subtract reference condition and remove
%appropriate bias
params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2','FyPSmax'};
correctTMbase=1:4;%indices of parameters that need to be corrected for TM base
correctTMslow=5;%indices of parameters that need to be corrected for TM slow

OGind=[3,4];%epoch associated with OGpost
TMind=[5:10];%epoch associated with treadmill trials, except the reference trial

for i=1:length(groups)
    exemptFirst=[eFbase eFbase eF 0 eF 0 0 startsplit(i) fullsplit(i) 0 eFSlowbase];
    [epsData{i}] = defineEpochs(names,conds,strideNo, exemptFirst,exemptLast,summethods);%this will be used to compute the baseline bias manually, since predefined function performs poorly for OG trials
    
    groupOutcomes{i}=NaN(length(params),length(names)+2,10);
    
end


%idendify reference conditions
OGref=strfind(names,'OG_B');OGref=find(not(cellfun('isempty', OGref)));
TMref=strfind(names,'TM_B');TMref=find(not(cellfun('isempty', TMref)));
slowref=strfind(names,'TM_slowref');slowref=find(not(cellfun('isempty', slowref)));%this one is used for analysis of slow propulsion forces

%find epochs needed to compute multiple epoch params
OGpE=strfind(names,'OG_P');OGpE=find(not(cellfun('isempty', OGpE)));
OGpL=strfind(names,'OG_LP');OGpL=find(not(cellfun('isempty', OGpL)));
LA=strfind(names,'lateAdapt');LA=find(not(cellfun('isempty', LA)));
ERA=strfind(names,'EarlyReadapt');ERA=find(not(cellfun('isempty', ERA)));


%extract data for epochs and subtract reference condition and remove
%appropriate bias
params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2','FyPSmax'};
correctTMbase=1:4;%indices of parameters that need to be corrected for TM base
correctTMslow=5;%indices of parameters that need to be corrected for TM slow

%extract data and remove bias, also compute params based on more than one epoch
nEp=length(names);%number of epochs
for i=1:length(groups)
    groupOutcomes{i}(1:length(params),1:length(names),1:10)=groups{i}.getEpochData(epsData{i},params);% nLabels x nEpochs x nSubjects
    
    %correct for bias
    for ind=TMind
        groupOutcomes{i}(correctTMbase,ind,:) =  groupOutcomes{i}(correctTMbase,ind,:) - groupOutcomes{i}(correctTMbase,TMref,:);
        groupOutcomes{i}(correctTMslow,ind,:) =  groupOutcomes{i}(correctTMslow,ind,:) - groupOutcomes{i}(correctTMslow,slowref,:);%this is done to correct FyPSmax for TM slow;
    end
    for ind=OGind
        groupOutcomes{i}(:,ind,:) =  groupOutcomes{i}(:,ind,:) - groupOutcomes{i}(:,OGref,:);
    end
    
    %compute multiple epoch params
    groupOutcomes{i}(:,nEp+1,:) = groupOutcomes{i}(:,OGpE,:) - groupOutcomes{i}(:,OGpL,:);%delta OG post
    groupOutcomes{i}(:,nEp+2,:) = groupOutcomes{i}(:,LA,:) - groupOutcomes{i}(:,ERA,:);% LA-ERA
    groupOutcomes{i}(:,nEp+3,:) = groupOutcomes{i}(:,OGpL,:) - groupOutcomes{i}(:,ERA,:);% LA-ERA
    
end

names={names{1:end},'deltaOG','LA_ERA','lOG_ERA'};
%extract timecourses
allconds=studyData.Gradual.getCommonConditions;
[timeCourse]=getGroupedTimeCourses(groups,allconds,params);


%remove appropriate Bias
condtypes=NaN(size(allconds));
for c=1:length(allconds)
    if strcmp(allconds{c}(1:2),'OG')
        condtypes(c)=1;
    else
        condtypes(c)=2;
    end
end

OGind=find(condtypes==1);
TMind=find(condtypes==2);
% 
 for i=1:length(groups);
     for p=1:length(params)
         OGbias=squeeze(groupOutcomes{i}(p,OGref,:))';
         if p==5;
             TMbias=squeeze(groupOutcomes{i}(p,slowref,:))';             
         else
             TMbias=squeeze(groupOutcomes{i}(p,TMref,:))';             
         end
         %now subtract bias form all conds for OG and TM separately
         for c=OGind
             %keyboard
             timeCourseUnbiased{i}.param{p}.cond{c}=  timeCourse{i}.param{p}.cond{c}-OGbias;  
         end
         for c=TMind
             timeCourseUnbiased{i}.param{p}.cond{c}=  timeCourse{i}.param{p}.cond{c}-TMbias; 
         end                  
     end
 end

%Add additional parameters not computed in epochs and store that in separate variable
params2={'maxError','meanError','strideMonIncrease','ErrorFromMonIncrese','maxErrorReadapt'};

%find index for gradual adaptation
cInd=NaN(2,1);
tpInd=NaN;
tcInd = strfind(allconds,'gradual adaptation');cInd(1,1) = find(not(cellfun('isempty', tcInd)));
tcInd = strfind(allconds,'readaptation');cInd(2,1) = find(not(cellfun('isempty', tcInd)));
tpInd = strfind(params,'netContributionNorm2');ParInd = find(not(cellfun('isempty', tpInd)));

for i=1:length(groups)
    %initialize matrices for data
    NonEpochoutcome{i}.par{1}=NaN(length(groups{i}.adaptData),1);
    NonEpochoutcome{i}.par{2}=NaN(length(groups{i}.adaptData),1);
    NonEpochoutcome{i}.par{3}=NaN(length(groups{i}.adaptData),1);    
    NonEpochoutcome{i}.par{4}=NaN(length(groups{i}.adaptData),1);
    NonEpochoutcome{i}.par{5}=NaN(length(groups{i}.adaptData),1);
    
    %first get gradualAdaptation and readaptation
    tempdata=cell2mat(timeCourseUnbiased{i}.param{ParInd}.cond(cInd(1,1)));%gradual adaptation
    tempdata2=cell2mat(timeCourseUnbiased{i}.param{ParInd}.cond(cInd(2,1)));%readaptation
    
    %extract parameters for all subjects
    for sj=1:length(groups{i}.adaptData)   
        dt=tempdata(:,sj);
        dt4=tempdata2(:,sj);
                
        % Maximum error        
         NonEpochoutcome{i}.par{1}(sj,1)=-1*(findmaxAV(dt.*-1,fullsplit(i)+1,fullsplit(i)+15,5));%in time window 15 strides of full ramp    
         NonEpochoutcome{i}.par{5}(sj,1)=-1*(findmaxAV(dt4.*-1,1,15,5));% in re-adaptation
         
        % Mean error adaptation
        dt3=dt(startsplit(i)+1:(find(~isnan(dt),1,'last')));
        dt3=dt3(1:end-10);
        NonEpochoutcome{i}.par{2}(sj,1)=nanmean(dt3);
         
         %Index start monotonic increase
         dt2 = medfilt1(dt(fullsplit(i)+1:end),5);
         tempout=find_strides_to_ignore(dt2,5,1,0);%look for first 5 strides of monotonic increase starting from full split
         if ~isempty(tempout)
             NonEpochoutcome{i}.par{3}(sj,1)=tempout;

             %determine error of 5 strides monotonic increase
             NonEpochoutcome{i}.par{4}(sj,1)=nanmean(dt2(NonEpochoutcome{i}.par{3}(sj,1)+fullsplit(i)+2:NonEpochoutcome{i}.par{3}(sj,1)+fullsplit(i)+6));
         end
             clear dt dt2 dt3 dt4 tempout
         
    end
    clear tempdata
end

clear tcInd tpInd cInd ParInd


%create extra params for the Catch group
names(length(names)+1:length(names)+3)={'beforeCatch','catch','resumeSplit'};
nEp=length(names);%number of epochs
CatchEp=defineEpochs({'Catch'},{'Catch'},-5,1,0,'nanmean');
ind=length(names)-2:length(names);
for i=1:length(groups)
    if strcmp(groupsnames{i},'Catch')
        groupOutcomes{i}(1:length(params),length(names)-1,1:10)=groups{i}.getEpochData(CatchEp,params);% nLabels x nEpochs x nSubjects
        for sj=1:10
            dt=groups{i}.adaptData{sj};
            ctr=getTrialsInCond(dt,'Catch');
            adaptr=getTrialsInCond(dt,'gradual adaptation');
            aftercatchTr=adaptr(end);
            beforecatchTr=adaptr(find(adaptr<ctr));
            allAftercatch=dt.getParamInTrial(params,aftercatchTr);
            allBeforecatch=dt.getParamInTrial(params,beforecatchTr);
            groupOutcomes{i}(1:length(params),length(names),sj)=nanmean(allAftercatch(1:5,:));
            groupOutcomes{i}(1:length(params),length(names)-2,sj)=nanmean(allBeforecatch(end-20:end-10,:));
        end           
        
    else
        groupOutcomes{i}(1:length(params),ind,1:10)=NaN;    
    end
        
    
    %correct for bias
   groupOutcomes{i}(correctTMbase,ind,:) =  groupOutcomes{i}(correctTMbase,ind,:) - groupOutcomes{i}(correctTMbase,TMref,:);
   groupOutcomes{i}(correctTMslow,ind,:) =  groupOutcomes{i}(correctTMslow,ind,:) - groupOutcomes{i}(correctTMslow,slowref,:);%this is done to correct FyPSmax for TM slow;
   
   %delta catch-resumesplit
   groupOutcomes{i} (:,nEp+1,:)=groupOutcomes{i} (:,nEp-1,:)-groupOutcomes{i} (:,nEp,:);
     
   %delta before catch after catch
   groupOutcomes{i} (:,nEp+2,:)=groupOutcomes{i} (:,nEp-2,:)-groupOutcomes{i} (:,nEp,:);
    
end
names={names{1:end},'catch_resumeSplit','forgettingSplit'};