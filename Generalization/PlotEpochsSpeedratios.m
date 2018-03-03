%N19_ExtractAllData;

indSubFlag=1;
sameScaleFlag=0;
%specify parameters of interest
pars={'netContributionNorm2','stepTimeContributionNorm2','spatialContributionNorm2','velocityContributionNorm2'};
eps={'TMafter'};
%groupOrder={'Gradual','AbruptFeedback','AbruptNoFeedback','Catch','FullAbrupt'};
groupOrder={'Interference2to1','Nimbus3to1','Perception3to1','InclineDecline3to1'};
colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];%DO NOT TOUCH!!


%find parameter of interest
for p=1:length(pars)
    tpInd = strfind(params,pars{p});ParInd(p) = find(not(cellfun('isempty', tpInd)));
end
for e=1:length(eps)
%teInd = strfind(names,eps{e});epInd(e) = find(not(cellfun('isempty', teInd)));
epInd(e)=1;
end


nrows=length(pars);
ncols=length(eps);

%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end

ha=tight_subplot(nrows,ncols,[.03 .05],.04,.05);
fullscreen

%plot data
xval = 1:length(groupOrder);
for p=1:length(pars)
    for e=1:length(eps)
        %subplot(nrows,ncols,p*nrows-ncols+e)
        %hold on
          hold(ha(p,e))
        for i = 1:length(groupOrder)
          
            bar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),'FaceColor',colcodes(groupInd(i),:));
            errorbar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),nanstd(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:))./sqrt(10),'LineWidth',2,'Color','k')
            if indSubFlag==1;
                plot(ha(p,e),xval(i)+0.2,squeeze(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),'ok')
            end
            %xorder(i)=groupInd(i);            
        end
        if e==1
            ylabel(ha(p,e),pars{p})            
        end
        if p==nrows
            xlabel(ha(p,e),eps{e})
        end
        if p==1 && e==ncols
           ll=findobj(ha(p,e),'Type','Bar');
           legend(ha(p,e),ll(fliplr(xval)),groupOrder) 
        end
        
        if sameScaleFlag==0
            lims=get(ha(p,e),'YLim');
            set(ha(p,e),'YLim',[min(lims) max(lims)],'YTick',[min(lims) max(lims)]);
            set(ha(p,e),'YTickLabel',[min(lims) max(lims)],'XLim',[0.5 length(xval)+0.5],'FontSize',12);
        end
        
    end
    %lims=cell2mat(get(ha(p,:),'YLim'));
    if sameScaleFlag==1;
        lims=get(ha(p,:),'YLim');
        if length(eps)>1
            lims=cell2mat(lims);
        end
        set(ha(p,:),'YLim',[min(min(lims)) max(max(lims))],'YTick',[min(min(lims)) max(max(lims))],'XLim',[0.5 length(xval)+0.5],'FontSize',12);
        set(ha(p,1),'YTickLabel',[min(min(lims)) max(max(lims))]);
    end
end


% subplot(nrows,ncols,1)
% 
% 
% set(gca,'XTick','','YTick',[0 0.1 0.2 0.3 0.4],'FontSize',16)
% title('Error first 5 strides of full ramp')

