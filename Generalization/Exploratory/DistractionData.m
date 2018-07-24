clear all
close all

[file,path]=uigetfile('*.mat','choose file to load');

load([path,file]);

%remove Bias and Bad strides for all groups
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
    groups{i}=eval(['studyData.',groupsnames{i}]);
    groups{i}=groups{i}.removeBadStrides;
end

startsplit=300;
fullsplit=900;

%define epochs
eF=1;%this is used for adaptation
eL=5;
nLate=-40;
nEarly=5;
nCatch=nEarly;
nafter=5;%number of strides for after effects

names={'OG_B','OG_P'};
conds={'OG base','OG post'};
strideNo=[nLate,nEarly];
exemptLast=[eL 0];
exemptFirst=[0 eF];

summethods={'nanmedian','nanmean'};
params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};

for i=1:length(groups)
    nsub=length(groups{i}.adaptData);
    [epsData{i}] = defineEpochs(names,conds,strideNo, exemptFirst,exemptLast,summethods);%this will be used to compute the baseline bias manually, since predefined function performs poorly for OG trials
    groupOutcomes{i}=NaN(length(params),length(names)+20,nsub);
    
end

OGref=1;
OGind=2;

for i=1:length(groups)
    nsub=length(groups{i}.adaptData);
    groupOutcomes{i}(1:length(params),1:length(names),1:nsub)=groups{i}.getEpochData(epsData{i},params);% nLabels x nEpochs x nSubjects
    
    %correct for bias
%     for ind=TMind
%         groupOutcomes{i}(correctTMbase,ind,:) =  groupOutcomes{i}(correctTMbase,ind,:) - groupOutcomes{i}(correctTMbase,TMref,:);
%         groupOutcomes{i}(correctTMslow,ind,:) =  groupOutcomes{i}(correctTMslow,ind,:) - groupOutcomes{i}(correctTMslow,slowref,:);%this is done to correct FyPSmax for TM slow;
%     end
    for ind=OGind
        groupOutcomes{i}(:,ind,:) =  groupOutcomes{i}(:,ind,:) - groupOutcomes{i}(:,OGref,:);
    end
    
end

groupOrder={'GradualCatch','GradualNoCatch'};
%groupOrder={'Catch'};
colcodes=[0.6 0.6 0.6;1 1 1];%DO NOT TOUCH!!


groupInd=NaN(1,length(groupOrder));

for i=1:length(groupOrder)
    tempInd = regexp(groupsnames,['^',groupOrder{i}]);groupInd(i) = find(not(cellfun('isempty', tempInd))); 
    nsub=length(groups{groupInd(i)}.adaptData);
    if i==1
        subcodes=cellstr(repmat(groupsnames{groupInd(i)},nsub,1));
    else
    subcodes=[subcodes;cellstr(repmat(groupsnames{groupInd(i)},nsub,1))];
    end
end

%generate table
T=table;
T.group=nominal(subcodes);

for e=1:length(names)
    for p=1:length(params)
        dt=[];
        for g=1:length(groupOrder)
            nsub=length(groups{groupInd(g)}.adaptData);
            dt=[dt;squeeze(groupOutcomes{groupInd(g)}(p,e,1:nsub))];
        end
        eval(['T.',params{p},'_',names{e},'=dt;'])
        clear dt
    end
end

TgradualNoCatch=T(T.group=='GradualNoCatch',:);
TgradualCatch=T(T.group=='GradualCatch',:);

f1=figure('Name','Experiment 1A');
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 2 2])
subplot(1,1,1)
hold on
bar(1,nanmean(TgradualNoCatch.netContributionNorm2_OG_P),'FaceColor',[0.6 0.6 0.6],'BarWidth',0.7);
errorbar(1,nanmean(TgradualNoCatch.netContributionNorm2_OG_P),nanstd(TgradualNoCatch.netContributionNorm2_OG_P)./sqrt(length(TgradualNoCatch.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
bar(2,nanmean(TgradualCatch.netContributionNorm2_OG_P),'FaceColor',[1 1 1],'BarWidth',0.7);
errorbar(2,nanmean(TgradualCatch.netContributionNorm2_OG_P),nanstd(TgradualCatch.netContributionNorm2_OG_P)./sqrt(length(TgradualCatch.netContributionNorm2_OG_P)),...
    'Color','k','LineWidth',2)
set(gca,'XLim',[0.5 2.5],'YLim',[0 0.07],'XTick',[1 2],'XTickLabel',{'NoCatch','Catch'},'FontSize',12,'FontName','Arial')
title('stepAsym')

