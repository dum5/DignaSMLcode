%N19_ExtractAllData;

%specify parameters of interest
pars={'maxError','ErrorFromMonIncrese','strideMonIncrease'};
eps={'','',''};
groupOrder={'AbruptNoFeedback','FullAbrupt'};
colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];%DO NOT TOUCH!!

ParInd=[];epInd=[];
%find parameter of interest
for e=1:length(eps)
    if isempty(eps{e})
        tpInd = strfind(params2,pars{e});ParInd(e) = find(not(cellfun('isempty', tpInd)));
        epInd(e)=NaN;
    else
        tpInd = strfind(params,pars{e});ParInd(e) = find(not(cellfun('isempty', tpInd)));
        teInd = strfind(names,eps{e});epInd(e) = find(not(cellfun('isempty', teInd)));
    end
end

ncols=length(eps);

%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end


ha=tight_subplot(2,ncols,[.3 .05],.04,.05);
fullscreen

%plot data
xval = 1:length(groupOrder);
for e=1:length(eps)
    hold(ha(1,e))
    for i = 1:length(groupOrder)
        if isempty(eps{e})
            bar(ha(1,e),xval(i),nanmean(NonEpochoutcome{groupInd(i)}.par{ParInd(e)}),'FaceColor',colcodes(groupInd(i),:));
            errorbar(ha(1,e),xval(i),nanmean(NonEpochoutcome{groupInd(i)}.par{ParInd(e)}),nanstd(NonEpochoutcome{groupInd(i)}.par{ParInd(e)})./sqrt(10),'LineWidth',2,'Color','k')
        else
            bar(ha(1,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(e),epInd(e),:)),'FaceColor',colcodes(groupInd(i),:));
            errorbar(ha(1,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(e),epInd(e),:)),nanstd(groupOutcomes{groupInd(i)}(ParInd(e),epInd(e),:))./sqrt(10),'LineWidth',2,'Color','k')
        end
    end
    %ylabel(ha(1,e),pars{e})
    if e==length(eps) 
        ll=findobj(ha(1,e),'Type','Bar');
        legend(ha(1,e),ll(fliplr(xval)),groupOrder)
    end
    
    lim=get(ha(1,e),'YLim');
    set(ha(1,e),'FontSize',14)
    title(ha(1,e),pars{e})
    set(ha(1,e),'YTick',[min(lim) max(lim)],'YTickLabel',[min(lim) max(lim)],'XLim',[0.5 2.5])
%     set(ha(1,:),'YLim',[min(min(lims)) max(max(lims))],'YTick',[min(min(lims)) max(max(lims))]);
%     set(ha(1,1),'YTickLabel',[min(min(lims)) 0 max(max(lims))]);
    set(ha,'box','off')
    
%     just for now
%     set(ha(1,:),'YTick',[min(min(lims)) 0],'YLim',[min(min(lims)) 0]);
%     set(ha(1,1),'YTickLabel',[min(min(lims)) 0]);
%     ylabel(ha(1,1),'Error');
%     title(ha(1,1),'Max Early')
%     title(ha(1,2),'Late')
%     title(ha(1,3),'Mean')
%     set(gcf,'Color',[1 1 1])
%     set(ha,'FontSize',12)
    
end


% subplot(nrows,ncols,1)
% 
% 
% set(gca,'XTick','','YTick',[0 0.1 0.2 0.3 0.4],'FontSize',16)
% title('Error first 5 strides of full ramp')

