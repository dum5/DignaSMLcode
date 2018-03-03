%N19_ExtractAllData;

%specify parameters of interest
pars={'FyPSmax'};
eps={'FullSplit'};
groupOrder={'AbruptNoFeedback','FullAbrupt'};
colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];%DO NOT TOUCH!!


%find parameter of interest
for p=1:length(pars)
    tpInd = strfind(params,pars{p});ParInd(p) = find(not(cellfun('isempty', tpInd)));
end
for e=1:length(eps)
teInd = strfind(names,eps{e});epInd(e) = find(not(cellfun('isempty', teInd)));
end

%nrows=length(pars);
ncols=length(pars);

%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end

ha=tight_subplot(2,ncols,[.03 .05],.04,.05);
fullscreen

%plot data
xval = 1:length(groupOrder);
for p=1:length(pars)
    for e=1:length(eps)
        %subplot(nrows,ncols,p*nrows-ncols+e)
        %hold on
          hold(ha(1,p))
        for i = 1:length(groupOrder)
          
            bar(ha(1,p),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),'FaceColor',colcodes(groupInd(i),:));
            errorbar(ha(1,p),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),nanstd(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:))./sqrt(10),'LineWidth',2,'Color','k')
            %xorder(i)=groupInd(i);            
        end
        if e==1
            ylabel(ha(1,p),pars{p})            
        end
        if p==nrows
            %xlabel(ha(1,p),eps{e})
        end
        if p==length(pars)
           ll=findobj(ha(1,p),'Type','Bar');
           legend(ha(1,p),ll(fliplr(xval)),groupOrder) 
        end
        
        
    end
    %title('OG post')
    set(ha(1,p),'FontSize',14)
    lim=get(ha(1,p),'YLim');
    set(ha(1,p),'YTick',[min(lim) max(lim)],'YTickLabel',[min(lim) max(lim)],'XLim',[0.5 2.5])
    
    %lims=cell2mat(get(ha(p,:),'YLim'));
%     lims=get(ha(p,:),'YLim');
%     set(ha(p,:),'YLim',[min(min(lims)) max(max(lims))],'YTick',[min(min(lims)) max(max(lims))]);
%     set(ha(p,1),'YTickLabel',[min(min(lims)) 0 max(max(lims))]);
end


% subplot(nrows,ncols,1)
% 
% 
% set(gca,'XTick','','YTick',[0 0.1 0.2 0.3 0.4],'FontSize',16)
% title('Error first 5 strides of full ramp')

