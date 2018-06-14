
%N19_ExtractAllData;

%specify parameters of interest
pars={'netContributionNorm2','stepTimeContributionNorm2','spatialContributionNorm2','velocityContributionNorm2'};
Conds={'OGpost'};
start=1;%0 is if you want full split, specify number if same for all groups;-1 is from start of split
nstrides=880;

%groupOrder={'Gradual','AbruptFeedback','AbruptNoFeedback','Catch','FullAbrupt'};
groupOrder={'FullAbrupt','AbruptNoFeedback'};
colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];

%find parameter of interest
for p=1:length(pars)
    tpInd = strfind(params,pars{p});ParInd(p) = find(not(cellfun('isempty', tpInd)));
end
for c=1:length(Conds)
     tcInd = strfind(allconds,Conds{c});CInd(c) = find(not(cellfun('isempty', tcInd)));
end

%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end

%consider making option to plot conditions one after another in one axis.
figure
for p=1:length(pars)
    subplot(2,length(pars),p)
   %subplot(2,1,1)
    hold on
    if start(1)==0 %this allows for having different starting points per group
        tstart=NaN(length(groupOrder));
        for i=1:length(groupOrder)
            tstart(i)=fullsplit(groupInd(i))+1;
        end
    elseif start(1)==-1
        tstart=NaN(length(groupOrder));
        for i=1:length(groupOrder)
            tstart(i)=startsplit(groupInd(i))+1;
        end
    else tstart=repmat(start(1),length(groupOrder),1);        
    end
    for i = 1:length(groupOrder)
        tempdata=cell2mat(timeCourseUnbiased{groupInd(i)}.param{ParInd(p)}.cond(CInd))';     
        dt=nanmean(tempdata(:,tstart(i):tstart(i)+nstrides-1));
        nt=nanstd(tempdata(:,tstart(i):tstart(i)+nstrides-1))./sqrt(10);
        nstrides=find(~isnan(dt),1,'last');
        dt=dt(1:nstrides);nt=nt(1:nstrides);
        plot(1:nstrides,dt,'ok','MarkerFaceColor',colcodes(groupInd(i),:)); 
        patch([1:nstrides,fliplr(1:nstrides)],[dt+nt fliplr(dt-nt)],colcodes(groupInd(i),:),'FaceAlpha',0.5,'LineStyle','none');hold on   
        clear dt nt tempdata
    end
    xlabel('Stride number')
    ylabel(pars{p})
    ll=findobj(gca,'Type','Line');
    legend(ll,fliplr(groupOrder)) 
    
    %%just for now
%     ylabel('Error Size')
%     plot([40 40],[-0.4 0.1],'--k','LineWidth',2,'Color',[0.5 0.5 0.5])
%     plot([600 600],[-0.4 0.1],'--k','LineWidth',2,'Color',[0.5 0.5 0.5])
%     set(gca,'YLim',[-0.4 0.1])
           
    
end

