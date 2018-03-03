%% Computation of parameters
clear all
close all


% This section calculates the parameters we wanted to compute. First lines
% are selecting the StudyFile and %commented% is the savings of "old"
% figures
[file,path]=uigetfile('Z:\Users\Wouter\Generalization Young\Paramfiles Study after ReviewEventGui\*.mat','choose file to load');
load([path,file]);


%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groups{i}=eval(['studyData.',groupsnames{i}]);
    %groups{i}.groupID=groupsnames{i};This is not allowed for
    %groupAdaptationData
    groups{i}=groups{i}.removeBadStrides;
end

groupOrder={'Gradual','AbruptFeedback','AbruptNoFeedback','Catch','FullAbrupt'};

%define stride numbers associated with specific events in each protocol
startsplit=NaN(1,length(groups));fullsplit=NaN(1,length(groups));
for i=1:length(groups)
    if strcmp(groupsnames{i},'Gradual')
        startsplit(i)=150;
        fullsplit(i)=750;
        inds{i}=1:10;
    elseif strcmp(groupsnames{i},'FullAbrupt')
        startsplit(i)=0;
        fullsplit(i)=0;
         inds{i}=11:20;
    elseif strcmp(groupsnames{i},'AbruptNoFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
         inds{i}=21:30;
    elseif strcmp(groupsnames{i},'AbruptFeedback')
        startsplit(i)=150;
        fullsplit(i)=190;
         inds{i}=31:40;
    elseif strcmp(groupsnames{i},'Catch')
        startsplit(i)=150;
        fullsplit(i)=190;    
         inds{i}=41:50;
    end   
end


n=1;
maxError=NaN(50,1);
for i=1:length(groups)
    for sj=1:length(groups{i}.adaptData)
        dt=groups{i}.adaptData{sj}.getParamInCond('netContributionNorm2','gradual adaptation');
        bias=groups{i}.adaptData{sj}.getParamInCond('netContributionNorm2','TM base');bias=nanmedian(bias(2:91));
        dt=dt-bias;
        maxError(n,1)=-1*(findmaxAV(dt.*-1,fullsplit(i)+1,fullsplit(i)+15,5));
        n=n+1;
    end
end



%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end

colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];%DO NOT TOUCH!!

figure
subplot(2,2,1)
hold on
xval = 1:length(groupOrder);
for i = 1:length(groupOrder)
    bar(xval(i),nanmean(netOGP(inds{groupInd(i)})),'FaceColor',colcodes(groupInd(i),:));
    errorbar(xval(i),nanmean(netOGP(inds{groupInd(i)})),nanstd(netOGP(inds{groupInd(i)}))./sqrt(10),'LineWidth',2,'Color','k')
    
    %bar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),'FaceColor',colcodes(groupInd(i),:));
    %errorbar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),nanstd(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:))./sqrt(10),'LineWidth',2,'Color','k')
    %xorder(i)=groupInd(i);
end
set(gca,'XTickLabel',{''})
title('Maximum error 15 strides full ramp')
