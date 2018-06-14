%% Computation of parameters
clear all
close all



% This section calculates the parameters we wanted to compute. First lines
% are selecting the StudyFile and %commented% is the savings of "old"
% figures
[file,path]=uigetfile('Z:\SubjectData\E04 Generalization Young');
load([path,file]);
% figdir=uigetdir('Z:\Users\Wouter\Generalization Young\Results\InterimAnalysis\','choose folder for figures');
% cd=figdir;



%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groupsTM{i}=eval(['studyData.',groupsnames{i}]);
    groupsOG{i}=eval(['studyData.',groupsnames{i}]);
    %groups{i}.groupID=groupsnames{i};This is not allowed for
    %groupAdaptationData
    groupsTM{i}=groupsTM{i}.removeBadStrides;
    groupsOG{i}=groupsOG{i}.removeBadStrides;
    for s=1:length(groupsTM{i}.adaptData)
        groupsTM{i}.adaptData{s}=groupsTM{i}.adaptData{s}.removeBias({'OG base','TM fast'});%only for treadmill, for OG I will remove bias manually
    end
   
end


%define stride numbers associated with specific events in each protocol
startsplit=NaN(1,length(groupsTM));fullsplit=NaN(1,length(groupsTM));
for i=1:length(groupsnames)
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
for i=1:length(groupsnames)    
    [epsData{i}] = defineEpochs({'eA','OG_P','OG_B'},{'gradual adaptation','OG base','OG post'},[5 5 90], [fullsplit(i) 1 1],[0 1 1],{'nanmean' 'nanmean' 'nanmedian'},{'eA','OG_P','OG_B'});%this will be used to compute the baseline bias manually, since predefined function performs poorly for OG trials
end

OGref=3;
OGind=2;


params={'FyPSmax','netContributionNorm2'};
for i=1:length(groupsnames)
    groupOutcomesTM{i}=groupsTM{i}.getEpochData(epsData{i}(1,:),params);  
    groupOutcomesOG{i}=groupsOG{i}.getEpochData(epsData{i}(2:3,:),params);  
    groupOutcomesOG{i}(:,1,:) =  groupOutcomesOG{i}(:,1,:) - groupOutcomesOG{i}(:,2,:);
    
end


%find parameter of interest
tParInd = strfind(params, 'netContributionNorm2');ParInd(1) = find(not(cellfun('isempty', tParInd)));
tParInd = strfind(params, 'FyPSmax');ParInd(2) = find(not(cellfun('isempty', tParInd)));
epInd = 1%strfind(names,'eA');epInd = find(not(cellfun('isempty', epInd)));

%sort groups in the right order for plots
groupOrder={'Gradual','AbruptFeedback','AbruptNoFeedback','Catch','FullAbrupt'};
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupsnames)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end

colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];

%plot data
xval = 1:length(groupOrder);
figure
subplot(2,2,1)
hold on
for i = 1:length(groupOrder)
    bar(xval(i),nanmean(groupOutcomesTM{groupInd(i)}(ParInd(2),epInd,:)),'FaceColor',colcodes(groupInd(i),:));
    errorbar(xval(i),nanmean(groupOutcomesTM{groupInd(i)}(ParInd(2),epInd,:)),nanstd(groupOutcomesTM{groupInd(i)}(ParInd(2),epInd,:))/sqrt(10),'LineWidth',2,'Color','k')  
    xorder(i)=groupInd(i);
end
ll=findobj(gca,'Type','Bar');
legend(ll(fliplr(xval)),groupOrder)
set(gca,'XTick','','FontSize',16)
title('Error first 5 strides of full ramp')

