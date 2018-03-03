clear all
close all

%% Load if not calculated
load('Z:\Users\Wouter\Generalization Young\Paramfiles Study after ReviewEventGui\GeneralizationStudy-9-8')
groupsnames=fieldnames(studyData);

eE=1;
eL=1;
%[eps] = defineEpochs({'startRamp','fullRamp','lA'},{'gradual adaptation', 'gradual adaptation' 'gradual adaptation'},[15 15 -40],[150 190 0],[0 0 10],'nanmedian');
[eps] = defineEpochs({'eA','lA'},{'gradual adaptation', 'gradual adaptation'},[15 -40],[1 0],[0 10],'nanmedian');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[0],[eL],'nanmedian');

for i=1:5
    baseEp=getBaseEpoch; %defines baseEp
    mOrder={'TA', 'MG','SEMT', 'VL', 'RF'};
    nMusc=length(mOrder);
    type='s';
    labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
    labelPrefixLong= strcat(labelPrefix,[type]); %Actual names
    dt=eval(['studyData.',groupsnames{i}]);
    if i==3
        dt=dt.removeSubs({'GYAC01','GYAC02'});
    elseif i==2
        dt=dt.removeSubs({'GYAA02','GYAA03'});
    elseif i==4
        dt=dt.removeSubs({'GYAF02'});
    end
    
    dt=dt.normalizeToBaselineEpoch(labelPrefixLong,baseEp);
    groups{i}=dt;clear dt
    %eval(['studyData.',groupsnames{i},'=dt;'])
    %clear dt    
    %Renaming normalized parameters, for convenience:
    ll=groups{i}.adaptData{1}.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'s(\d+)','_s$1');
    %l2=regexprep(regexprep(ll,'^Norm',''),'s\d+','_s');
    %l2=regexprep(regexprep(ll,'^Norm',''),'s\d*','_');
    groups{i}=groups{i}.renameParams(ll,l2);
    
end



newLabelPrefix=fliplr(strcat(labelPrefix,'_s'));

%fh=plotAvgTimeCourse(this,params,conditions,binwidth,trialMarkerFlag,indivFlag,indivSubs,colorOrder,biofeedback,removeBiasFlag,groupNames,medianFlag,plotHandles)

%[data]=getGroupedDataFromInds(this,inds,label,padWithNaNFlag)

%getGroupedData(this,label,conds,removeBiasFlag,numberOfStrides,exemptFirst,exemptLast,padWithNaNFlag)


dt=getGroupedData(groups{2},'sTA_s1','gradual adaptation', 1, 840, 0, 0, 0);
sTA1.Full=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{3},'sTA_s1','gradual adaptation', 1, 840, 190, 0, 0);
sTA1.Cont=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{4},'sTA_s1','gradual adaptation', 1, 840, 190, 0, 0);
sTA1.FB=squeeze(dt{1})'; clear dt

dt=getGroupedData(groups{2},'sTA_s2','gradual adaptation', 1, 840, 0, 0, 0);
sTA2.Full=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{3},'sTA_s2','gradual adaptation', 1, 840, 190, 0, 0);
sTA2.Cont=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{4},'sTA_s2','gradual adaptation', 1, 840, 190, 0, 0);
sTA2.FB=squeeze(dt{1})'; clear dt

dt=getGroupedData(groups{2},'sTA_s3','gradual adaptation', 1, 840, 0, 0, 0);
sTA3.Full=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{3},'sTA_s3','gradual adaptation', 1, 840, 190, 0, 0);
sTA3.Cont=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{4},'sTA_s3','gradual adaptation', 1, 840, 190, 0, 0);
sTA3.FB=squeeze(dt{1})'; clear dt

dt=getGroupedData(groups{2},'sTA_s4','gradual adaptation', 1, 840, 0, 0, 0);
sTA4.Full=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{3},'sTA_s4','gradual adaptation', 1, 840, 190, 0, 0);
sTA4.Cont=squeeze(dt{1})'; clear dt
dt=getGroupedData(groups{4},'sTA_s4','gradual adaptation', 1, 840, 190, 0, 0);
sTA4.FB=squeeze(dt{1})'; clear dt


ha=tight_subplot(4,1,[.01 .3],.06,.04);
x=1:840;

hold(ha(1))
plot(ha(1),nanmean(sTA1.Full),'or','MarkerFaceColor','r','MarkerSize',4)
plot(ha(1),nanmean(sTA1.Cont),'ob','MarkerFaceColor','b','MarkerSize',4)
plot(ha(1),nanmean(sTA1.FB),'ok','MarkerFaceColor','k','MarkerSize',4)
patch(ha(1),[x,fliplr(x)],[nanmean(sTA1.Full)+nanstd(sTA1.Full)./sqrt(size(sTA1.Full,1)) fliplr(nanmean(sTA1.Full)-nanstd(sTA1.Full)./sqrt(size(sTA1.Full,1)))],'r','FaceAlpha',0.2,'LineStyle','none');
patch(ha(1),[x,fliplr(x)],[nanmean(sTA1.Cont)+nanstd(sTA1.Cont)./sqrt(size(sTA1.Cont,1)) fliplr(nanmean(sTA1.Cont)-nanstd(sTA1.Cont)./sqrt(size(sTA1.Cont,1)))],'b','FaceAlpha',0.2,'LineStyle','none');
patch(ha(1),[x,fliplr(x)],[nanmean(sTA1.FB)+nanstd(sTA1.FB)./sqrt(size(sTA1.FB,1)) fliplr(nanmean(sTA1.FB)-nanstd(sTA1.FB)./sqrt(size(sTA1.FB,1)))],'k','FaceAlpha',0.2,'LineStyle','none');
ylabel(ha(1),'TA stance1')
ll=findobj(ha(1),'Type','Line');
legend(ll,{'Feedback','Control','Full Abrupt'})

hold(ha(2))
plot(ha(2),nanmean(sTA2.Full),'or','MarkerFaceColor','r','MarkerSize',4)
plot(ha(2),nanmean(sTA2.Cont),'ob','MarkerFaceColor','b','MarkerSize',4)
plot(ha(2),nanmean(sTA2.FB),'ok','MarkerFaceColor','k','MarkerSize',4)
patch(ha(2),[x,fliplr(x)],[nanmean(sTA2.Full)+nanstd(sTA2.Full)./sqrt(size(sTA2.Full,1)) fliplr(nanmean(sTA2.Full)-nanstd(sTA2.Full)./sqrt(size(sTA2.Full,1)))],'r','FaceAlpha',0.2,'LineStyle','none');
patch(ha(2),[x,fliplr(x)],[nanmean(sTA2.Cont)+nanstd(sTA2.Cont)./sqrt(size(sTA2.Cont,1)) fliplr(nanmean(sTA2.Cont)-nanstd(sTA2.Cont)./sqrt(size(sTA2.Cont,1)))],'b','FaceAlpha',0.2,'LineStyle','none');
patch(ha(2),[x,fliplr(x)],[nanmean(sTA2.FB)+nanstd(sTA2.FB)./sqrt(size(sTA2.FB,1)) fliplr(nanmean(sTA2.FB)-nanstd(sTA2.FB)./sqrt(size(sTA2.FB,1)))],'k','FaceAlpha',0.2,'LineStyle','none');
ylabel(ha(2),'TA stance2')

hold(ha(3))
plot(ha(3),nanmean(sTA3.Full),'or','MarkerFaceColor','r','MarkerSize',4)
plot(ha(3),nanmean(sTA3.Cont),'ob','MarkerFaceColor','b','MarkerSize',4)
plot(ha(3),nanmean(sTA3.FB),'ok','MarkerFaceColor','k','MarkerSize',4)
patch(ha(3),[x,fliplr(x)],[nanmean(sTA3.Full)+nanstd(sTA3.Full)./sqrt(size(sTA3.Full,1)) fliplr(nanmean(sTA3.Full)-nanstd(sTA3.Full)./sqrt(size(sTA3.Full,1)))],'r','FaceAlpha',0.2,'LineStyle','none');
patch(ha(3),[x,fliplr(x)],[nanmean(sTA3.Cont)+nanstd(sTA3.Cont)./sqrt(size(sTA3.Cont,1)) fliplr(nanmean(sTA3.Cont)-nanstd(sTA3.Cont)./sqrt(size(sTA3.Cont,1)))],'b','FaceAlpha',0.2,'LineStyle','none');
patch(ha(3),[x,fliplr(x)],[nanmean(sTA3.FB)+nanstd(sTA3.FB)./sqrt(size(sTA3.FB,1)) fliplr(nanmean(sTA3.FB)-nanstd(sTA3.FB)./sqrt(size(sTA3.FB,1)))],'k','FaceAlpha',0.2,'LineStyle','none');
ylabel(ha(3),'TA stance3')

hold(ha(4))
plot(ha(4),nanmean(sTA4.Full),'or','MarkerFaceColor','r','MarkerSize',4)
plot(ha(4),nanmean(sTA4.Cont),'ob','MarkerFaceColor','b','MarkerSize',4)
plot(ha(4),nanmean(sTA4.FB),'ok','MarkerFaceColor','k','MarkerSize',4)
patch(ha(4),[x,fliplr(x)],[nanmean(sTA4.Full)+nanstd(sTA4.Full)./sqrt(size(sTA4.Full,1)) fliplr(nanmean(sTA4.Full)-nanstd(sTA4.Full)./sqrt(size(sTA4.Full,1)))],'r','FaceAlpha',0.2,'LineStyle','none');
patch(ha(4),[x,fliplr(x)],[nanmean(sTA4.Cont)+nanstd(sTA4.Cont)./sqrt(size(sTA4.Cont,1)) fliplr(nanmean(sTA4.Cont)-nanstd(sTA4.Cont)./sqrt(size(sTA4.Cont,1)))],'b','FaceAlpha',0.2,'LineStyle','none');
patch(ha(4),[x,fliplr(x)],[nanmean(sTA4.FB)+nanstd(sTA4.FB)./sqrt(size(sTA4.FB,1)) fliplr(nanmean(sTA4.FB)-nanstd(sTA4.FB)./sqrt(size(sTA4.FB,1)))],'k','FaceAlpha',0.2,'LineStyle','none');
ylabel(ha(4),'TA stance4');xlabel('Strides from full ramp')
set(ha(4),'XTick',[0 200 400 600 800],'XTickLabel',{'0','200','400','600','800'});

set(ha,'XLim',[0 850],'YLim',[0 2],'box','off','FontSize',14)

% sTA2.Full=getGroupedDataFromInds(groups{2},1:850,'sTA_s3',1);
% sTA2.Con=getGroupedDataFromInds(groups{3},151:1000,'sTA_s3',1);


% 
% f=figure;
% ha=tight_subplot(1,2,[.03 .005],.04,.04);
% 
% %dt.plotAvgTimeCourse('sTA_s3',{'TM base','gradual adaptation'},1)
% 
% evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
% 
% [fh,ha,labels,dataE,dataRef]=plotCheckerboards(dt,newLabelPrefix,eps,f,ha,reps,true,'nanmedian');
% set(ha,'CLim',[-1 1]*0.5,'XTick',(0:numel(evLabel)-1)/12);
% colorbar
% 
% set(ha,'FontSize',14)
% pos=get(ha,'Position');
% gca
% colorbar
