function [fh,ph,stats]=plotTimeAndBarsGeneralization(T,timeCourseUnbiased,groupInd,startsplit,posthoc,fh,ph,conds,allconds,tpars,bpars,allpars,colcodes,grouplabels);

nstrides=880;
%plot timecourses
for p=1:size(ph,1)
    hold(ph(p,1))
    par=find(~cellfun(@isempty,strfind(allpars,tpars)));  
    cond=find(~cellfun(@isempty,strfind(allconds,conds)));
    if strcmp(conds{p},'gradual adaptation') %this allows for having different starting points per group
        tstart=NaN(length(groupInd));
        for i=1:length(groupInd)
            tstart(i)=startsplit(groupInd(i))+1;
        end    
    else tstart=repmat(start(1),length(groupInd),1);        
    end
    for i = 1:length(groupInd)
        tempdata=cell2mat(timeCourseUnbiased{groupInd(i)}.param{par}.cond(cond))';     
        dt=nanmean(tempdata(:,tstart(i):tstart(i)+nstrides-1));
        nt=nanstd(tempdata(:,tstart(i):tstart(i)+nstrides-1))./sqrt(size(tempdata,1));
        nstrides=find(~isnan(dt),1,'last');
        dt=dt(1:nstrides);nt=nt(1:nstrides);
        plot(1:nstrides,dt,'ok','MarkerFaceColor',colcodes(i,:)); 
        patch([1:nstrides,fliplr(1:nstrides)],[dt+nt fliplr(dt-nt)],colcodes(i,:),'FaceAlpha',0.5,'LineStyle','none');hold on   
        clear dt nt tempdata
    end
    xlabel('Stride number')
    ylabel(tpars)
    ll=findobj(gca,'Type','Line');
    if p==1
    legend(flipud(ll),grouplabels) 
    end
    a=T;b=posthoc;c=bpars;stats=[];
    %%just for now
%     ylabel('Error Size')
%     plot([40 40],[-0.4 0.1],'--k','LineWidth',2,'Color',[0.5 0.5 0.5])
%     plot([600 600],[-0.4 0.1],'--k','LineWidth',2,'Color',[0.5 0.5 0.5])
%     set(gca,'YLim',[-0.4 0.1])
           
    


end