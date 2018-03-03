%N19_ExtractAllData

%specify parameters of interest
pars={'netContributionNorm2','spatialContributionNorm2'};
eps={'deltaOG','LA-ERA'};
nEpochPars=[];%{'maxError'}%{'ErrorFromMonIncrese'};
groupOrder={'AbruptNoFeedback','Catch','FullAbrupt'};
colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];%DO NOT TOUCH!!

epInd=NaN(size(eps));
%find parameter of interest
for p=1:length(pars)
    tpInd = strfind(params,pars{p});ParInd(p) = find(not(cellfun('isempty', tpInd)));
end
for e=1:length(eps)
teInd = strfind(names,eps{e});
if~ isempty(find(not(cellfun('isempty', teInd))))
    epInd(e) = find(not(cellfun('isempty', teInd)));
end
end
for n=1:length(nEpochPars)
    tneInd = strfind(params2,cell2mat(nEpochPars)); neInd(n) = find(not(cellfun('isempty', tneInd)));
end

%sort groups in the right order for plots
groupInd=NaN(1,length(groupOrder));
for i=1:length(groupOrder)
    tempInd = strfind(groupsnames,groupOrder{i});groupInd(i) = find(not(cellfun('isempty', tempInd))); 
end


figure
hold on
%plot data
for i = 1:length(groupOrder)
    if isempty(nEpochPars)
        plot(squeeze(groupOutcomes{groupInd(i)}(ParInd(1),epInd(1),:)),squeeze(groupOutcomes{groupInd(i)}(ParInd(2),epInd(2),:)),'ok','MarkerFaceColor',colcodes(groupInd(i),:),'MarkerSize',10)
    elseif isempty(pars)
        plot(NonEpochoutcome{groupInd(i)}.par{neInd},NonEpochoutcome{groupInd(i)}.par{neInd},'ok','MarkerFaceColor',colcodes(groupInd(i),:));
    else
        plot(NonEpochoutcome{groupInd(i)}.par{neInd},squeeze(groupOutcomes{groupInd(i)}(ParInd(1),epInd(2),:)),'ok','MarkerFaceColor',colcodes(groupInd(i),:));
    end
end
legend(groupOrder)
if isempty(nEpochPars)
    xlabel([pars{1},' ', eps{1}])
    ylabel([pars{2},' ', eps{2}])
else
    xlabel(cell2mat(nEpochPars))
    ylabel([pars{1},' ', eps{1}])
    
end



ll=findobj(gca,'Type','Line');
xval=[];
yval=[];
for l=1:length(ll)
    xval=[xval;ll(l).XData'];
    yval=[yval;ll(l).YData'];    
end
[r,m,b] = regression(xval,yval,'one');
rfit=b+xval.*m;
plot(xval,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
[r2,p]=corrcoef(xval,yval);
title(['R = ',num2str(r2(2)),' p = ',num2str(p(2))]);
set(gca,'FontSize',16)

% 
% for p=1:length(pars)
%     for e=1:length(eps)
%         %subplot(nrows,ncols,p*nrows-ncols+e)
%         %hold on
%           hold(ha(p,e))
%         for i = 1:length(groupOrder)
%           
%             bar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),'FaceColor',colcodes(groupInd(i),:));
%             errorbar(ha(p,e),xval(i),nanmean(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:)),nanstd(groupOutcomes{groupInd(i)}(ParInd(p),epInd(e),:))./sqrt(10),'LineWidth',2,'Color','k')
%             %xorder(i)=groupInd(i);            
%         end
%         if e==1
%             ylabel(ha(p,e),pars{p})            
%         end
%         if p==nrows
%             xlabel(ha(p,e),eps{e})
%         end
%         if p==1 && e==ncols
%            ll=findobj(ha(p,e),'Type','Bar');
%            legend(ha(p,e),ll(fliplr(xval)),groupOrder) 
%         end
%     end
%     lims=cell2mat(get(ha(p,:),'YLim'));
%     set(ha(p,:),'YLim',[min(min(lims)) max(max(lims))],'YTick',[min(min(lims)) 0 max(max(lims))]);
%     set(ha(p,1),'YTickLabel',[min(min(lims)) 0 max(max(lims))]);
% end
% 
