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
[file,path]=uigetfile('*.mat','choose file to load');

load([path,file]);

%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groups{i}=eval(['studyData.',groupsnames{i}]);
    for sj=1:length(groups{i}.adaptData)
       %replace bad stride data with NaN
        Idx=find(startsWith(groups{i}.adaptData{sj}.data.labels,'bad'));
        badIdx=find(groups{i}.adaptData{sj}.data.Data(:,Idx)==1);
        groups{i}.adaptData{sj}.data.Data(badIdx,4:end)=NaN;
        clear Idx badIdx   
        %strides with abs(SLA)>2 are also bad;
        Idx=find(startsWith(groups{i}.adaptData{sj}.data.labels,'netContributionNorm2'));
        badIdx=find(abs(groups{i}.adaptData{sj}.data.Data(:,Idx))>2);
        %keyboard
        groups{i}.adaptData{sj}.data.Data(badIdx,4:end)=NaN;
        clear Idx badIdx   
            
    end
    
end

%define stride numbers associated with specific events in each protocol
startsplit=NaN(1,length(groups));fullsplit=NaN(1,length(groups));
for i=1:length(groups)
    if strcmp(groupsnames{i},'Gradual')
        startsplit(i)=150;
        fullsplit(i)=750;
    elseif strcmp(groupsnames{i},'FullAbrupt')
        %startsplit(i)=0;
        %fullsplit(i)=0;
        startsplit(i)=1;
        fullsplit(i)=1;
    elseif strcmp(groupsnames{i},'AbruptNoFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
    elseif strcmp(groupsnames{i},'AbruptFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
    elseif strcmp(groupsnames{i},'Catch')
        startsplit(i)=150;
        fullsplit(i)=190; 
    elseif strcmp(groupsnames{i},'TMFullAbrupt')
        startsplit(i)=1;
        fullsplit(i)=1;
    elseif strcmp(groupsnames{i},'TMAbruptNoFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;    
    elseif strcmp(groupsnames{i},'GradualNoCatch')
        startsplit(i)=300;
        fullsplit(i)=900; 
    elseif strcmp(groupsnames{i},'GradualCatch')
        startsplit(i)=300;
        fullsplit(i)=900;
    end 
end

%define epochs
eF=1;%this is used for adaptation
eL=5;
%eFbase=0;% this is used for base only to get similar values as before, since we take the median it does not matter if first one is an outlier
%eLBase=1;
%eLAdap=10;%strides exempt for late adaptation
%eLOGP=1;
%nEA=5;%number of strides to characterize early adaptation
%nLateAdap=-40;%number of strides for late adaptation; This was 50, but 40 is more consistent with what we did before
nLate=-40;
nEarly=5;
nCatch=nEarly;
%nLateOGp=-20;
%nbase=90;%number of strides for TM base and OG base
nafter=5;%number of strides for after effects
%nslow=50;%number of strides for slow baseline
%eFSlowbase=0;%consider changing strides for ref base (-40), since that is more consistent with code procedures


names={'OG_B','TM_B','OG_P','OG_LP','TM_P','lateAdapt','lateReadapt','earlyAdapt','FullSplit','EarlyReadapt','TM_LP'};
conds={'OG base','TM base', 'OG post','OG post', 'TM post', 'gradual adaptation', 'readaptation', 'gradual adaptation','gradual adaptation','readaptation','TM post'};
strideNo=[nLate,nLate,nEarly,-10,nEarly,nLate,nLate,nEarly,nEarly,nEarly,-10];
%strideNo=[nbase nbase nafter nLateOGp nafter nLateAdap nLateAdap nEA nEA nEA nslow];
exemptLast=[eL, eL,0,eL,0,eL,eL,0,0,0,eL];
%exemptLast=[eLBase eLBase 0 eLOGP 0 eLAdap eLAdap 0 0 0 0];
summethods=({'nanmedian','nanmedian','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean','nanmean'});

%extract data for epochs and subtract reference condition and remove
%appropriate bias
params={'netContributionNorm2','velocityContributionNorm2','netContributionPNorm','velocityContributionPNorm','netContributionPNorm2','velocityContributionPnorm2'};
%params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'}


correctTMbase=1:6;%indices of parameters that need to be corrected for TM base
correctTMslow=[];%indices of parameters that need to be corrected for TM slow

OGind=[3,4];%epoch associated with OGpost
TMind=[5:11];%epoch associated with treadmill trials, except the reference trial

%find lata Adaptation, because this is a different conditionName for
%distraction people
Index = find(contains(names,'lateAdap'));
for i=1:length(groups)
     nsub=length(groups{i}.adaptData);
    %exemptFirst=[eFbase eFbase eF 0 eF 0 0 startsplit(i) fullsplit(i) 0 eFSlowbase];
    exemptFirst=[0 0 eF 0 eF 0 0 startsplit(i), fullsplit(i), eF, 0]; 
    [epsData{i}] = defineEpochs(names,conds,strideNo, exemptFirst,exemptLast,summethods);%this will be used to compute the baseline bias manually, since predefined function performs poorly for OG trials
    groupOutcomes{i}=NaN(length(params),length(names)+20,nsub);
   if  i>7
       epsData{i}.Condition{Index}='Re-adaptation';
   end
       
end


%idendify reference conditions
OGref=strfind(names,'OG_B');OGref=find(not(cellfun('isempty', OGref)));
TMref=strfind(names,'TM_B');TMref=find(not(cellfun('isempty', TMref)));
slowref=strfind(names,'TM_slowref');slowref=find(not(cellfun('isempty', slowref)));%this one is used for analysis of slow propulsion forces

%find epochs needed to compute multiple epoch params
OGpE=strfind(names,'OG_P');OGpE=find(not(cellfun('isempty', OGpE)));
TMpE=strfind(names,'TM_P');TMpE=find(not(cellfun('isempty', TMpE)));
OGpL=strfind(names,'OG_LP');OGpL=find(not(cellfun('isempty', OGpL)));
LA=strfind(names,'lateAdapt');LA=find(not(cellfun('isempty', LA)));
ERA=strfind(names,'EarlyReadapt');ERA=find(not(cellfun('isempty', ERA)));


%extract data for epochs and subtract reference condition and remove
%appropriate bias
% params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2','FyPSmax'};
% correctTMbase=1:4;%indices of parameters that need to be corrected for TM base
% correctTMslow=5;%indices of parameters that need to be corrected for TM slow

%extract data and remove bias, also compute params based on more than one epoch
nEp=length(names);%number of epochs
for i=1:length(groups)
    nsub=length(groups{i}.adaptData);
    for n=1:length(names)
        try
        groupOutcomes{i}(1:length(params),n,1:nsub)=groups{i}.getEpochData(epsData{i}(n,:),params);
%             if i==8
%                 keyboard
%             end
        catch
            warning(['epoch',names{n},'not available for group:',groupsnames{i}])
        end  
        
    end
    %groupOutcomes{i}(1:length(params),1:length(names),1:nsub)=groups{i}.getEpochData(epsData{i},params);% nLabels x nEpochs x nSubjects
    
    %correct for bias
    for ind=TMind
        groupOutcomes{i}(correctTMbase,ind,:) =  groupOutcomes{i}(correctTMbase,ind,:) - groupOutcomes{i}(correctTMbase,TMref,:);
       % groupOutcomes{i}(correctTMslow,ind,:) =  groupOutcomes{i}(correctTMslow,ind,:) - groupOutcomes{i}(correctTMslow,slowref,:);%this is done to correct FyPSmax for TM slow;
    end
    for ind=OGind
        groupOutcomes{i}(:,ind,:) =  groupOutcomes{i}(:,ind,:) - groupOutcomes{i}(:,OGref,:);
    end
    
    %compute multiple epoch params
    groupOutcomes{i}(:,nEp+1,:) = groupOutcomes{i}(:,OGpE,:) - groupOutcomes{i}(:,OGpL,:);%delta OG post
    groupOutcomes{i}(:,nEp+2,:) = groupOutcomes{i}(:,LA,:) - groupOutcomes{i}(:,ERA,:);% LA-ERA
    groupOutcomes{i}(:,nEp+3,:) = groupOutcomes{i}(:,OGpL,:) - groupOutcomes{i}(:,ERA,:);% OGlp-ERA
    groupOutcomes{i}(:,nEp+4,:) = (groupOutcomes{i}(:,OGpE,:)./groupOutcomes{i}(:,TMpE,:)).*100;% pct generalization
    
end

names={names{1:end},'deltaOG','LA_ERA','lOG_ERA','pctGeneralization'};
%extract timecourses
%allconds=groups{1}.getCommonConditions;
%allconds=studyData.Gradual.getCommonConditions;
%[timeCourse]=getGroupedTimeCourses(groups,allconds,params);


%remove appropriate Bias
% condtypes=NaN(size(allconds));
% for c=1:length(allconds)
%     if strcmp(allconds{c}(1:2),'OG')
%         condtypes(c)=1;
%     else
%         condtypes(c)=2;
%     end
% end
% 
% OGind=find(condtypes==1);
% TMind=find(condtypes==2);
% 
 for i=1:length(groups);
     allconds=groups{i}.getCommonConditions;
     
     timeCourse(i)=getGroupedTimeCourses(groups{i},allconds,params);
     
     %remove appropriate bias for each groups, since conditions vary
     OGind = find(startsWith(allconds,'OG'));
     TMind = find(~startsWith(allconds,'OG'));

     
     for p=1:length(params)
         OGbias=squeeze(groupOutcomes{i}(p,OGref,:))';
%          if p==5;
%              TMbias=squeeze(groupOutcomes{i}(p,slowref,:))';             
%          else
          TMbias=squeeze(groupOutcomes{i}(p,TMref,:))';             
%          end
         %now subtract bias form all conds for OG and TM separately
         for c=OGind
             %keyboard
             timeCourseUnbiased{i}.param{p}.cond{c}=  timeCourse{i}.param{p}.cond{c}-OGbias;  
         end
         for c=TMind
             timeCourseUnbiased{i}.param{p}.cond{c}=  timeCourse{i}.param{p}.cond{c}-TMbias; 
         end                  
     end
     
     if i==5 %for the catch group split up before and after catch
         cInd=find(startsWith(allconds,'catch'));
         gInd=find(startsWith(allconds,'gradual'));
         %gInd=find(startsWith(allconds,'gradual'));        
         for p=1:length(params)
             TMbias=squeeze(groupOutcomes{i}(p,TMref,:))';
             dt=NaN(755,10);
             dt2=NaN(1230,10);
             
             for sj=1:length(groups{5}.adaptData);
                 %find trials before and after catch
                 adapIdx=groups{5}.adaptData{sj}.getTrialsInCond('gradual adaptation');
                 dtt=groups{5}.adaptData{sj}.getParamInTrial(params{p},adapIdx(1:end-1));
                 dtt2=groups{5}.adaptData{sj}.getParamInTrial(params{p},adapIdx(end));
                 dt(1:length(dtt),sj)=dtt;
                 dt2(1:length(dtt2),sj)=dtt2;
             end
             dt=dt-TMbias;
             dt2=dt2-TMbias;
             timeCourseUnbiased{i}.param{p}.cond{gInd}=[dt; timeCourseUnbiased{i}.param{p}.cond{cInd}(1:15,:); dt2];
         end
     end
     
 end

 