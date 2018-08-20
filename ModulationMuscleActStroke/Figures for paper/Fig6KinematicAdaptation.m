%% Assuming that the variables groups() exists (From N19_loadGroupedData)
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Initialize: change settings if needed%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%settings
matchSpeedFlag=0;
removeP07Flag=1;
binWidth=10;
labels={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};
faceCols=[1 1 1;0 0 0];
patchCols=[0.7 0.7 0.7;1 1 1];



%epoch settings
eF=1;
eL=1;

%strides for group epoch bars
eps=defineEpochs({'Base','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 15 -40 15],...
    [eF,eF,eF,eF],[eL,eL,eL,eL],'nanmean');
statEps=defineEpochs({'eA','lA','eP'},{'Adaptation','Adaptation','Washout'},[15 -40 15],...
    [eF,eF,eF],[eL,eL,eL],'nanmean');
%strides for time courses
eps2=defineEpochs({'Base','eA','lA','eP'},{'TM base','Adaptation','Adaptation','Washout'},[-40 500 -40 200],...
    [eF,eF,eF,eF],[eL,eL,eL,eL],'nanmean');

%load data
[Name,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,Name]; 
load(loadName)

%generate grouAdaptationData and remove bias
patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15'});%P016 removed %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsSlowList=strcat('C00',{'01','02','04','05','06','09','10','12','16'}); %C07 removed%Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s

if removeP07Flag
    patients2=patients.removeSubs({'P0007'});
    controls2=controls.removeSubs({'C0007'});   
end
switch matchSpeedFlag
    case 1 %Speed matched groups   
        patients2=patients2.getSubGroup(patientFastList);
        controls2=controls2.getSubGroup(controlsSlowList);       
    case 0 %Full groups
       %no action required
end

groups{1}=controls2;
groups{2}=patients2;

groupsUnbiased{1}=groups{1}.removeBadStrides.removeBaselineEpoch(eps(1,:),[]);
groupsUnbiased{2}=groups{2}.removeBadStrides.removeBaselineEpoch(eps(1,:),[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run stats using rm model%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[SPmodel,SPbtab,SPwtab,SPmaineff,SPposthocGroup,SPposthocEpoch,SPposthocEpochByGroup,SPposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'spatialContributionNorm2',statEps,0.05);

[STmodel,STbtab,STwtab,STmaineff,STposthocGroup,STposthocEpoch,STposthocEpochByGroup,STposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'stepTimeContributionNorm2',statEps,0.05);

[SVmodel,SVbtab,SVwtab,SVmaineff,SVposthocGroup,SVposthocEpoch,SVposthocEpochByGroup,SVposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'velocityContributionNorm2',statEps,0.05);

[NETmodel,NETbtab,NETwtab,NETmaineff,NETposthocGroup,NETposthocEpoch,NETposthocEpochByGroup,NETposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'netContributionNorm2',statEps,0.05);

[AFmodel,AFbtab,AFwtab,AFmaineff,AFposthocGroup,AFposthocEpoch,AFposthocEpochByGroup,AFposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'alphaFast',statEps,0.05);

[ASmodel,ASbtab,ASwtab,ASmaineff,ASposthocGroup,ASposthocEpoch,ASposthocEpochByGroup,ASposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'alphaSlow',statEps,0.05);

[XFmodel,XFbtab,XFwtab,XFmaineff,XFposthocGroup,XFposthocEpoch,XFposthocEpochByGroup,XFposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'XFast',statEps,0.05);

[XSmodel,XSbtab,XSwtab,XSmaineff,XSposthocGroup,XSposthocEpoch,XSposthocEpochByGroup,XSposthocGroupByEpoch]=...
    groupAdaptationData.AnovaEpochs(groupsUnbiased,{'controls','stroke'},'XSlow',statEps,0.05);

%%%%%%%%%%%%%%%%%%%
%%Do the plotting%%
%%%%%%%%%%%%%%%%%%%

fh=figure;
fullscreen
set(fh,'Color',[1 1 1])
xpos=[0.03 0.51];
ypos=[0.7722 0.5370 0.3017 0.0665];
w=[0.45 0.2310];
h=0.1820;

M=length(labels);
for i=1:M
    ph(i,1)=subplot(M,3,[1:2]+3*(i-1));
    set(ph(i,1),'Position',[xpos(1),ypos(i),w(1),h])
    ph(i,2)=subplot(M,3,[3]+3*(i-1));
    set(ph(i,2),'Position',[xpos(2),ypos(i),w(2),h])
end


%plot time courses
for i=1:M
    hold(ph(i,1))
    for g=1:length(groupsUnbiased);
        Inds=0;
        meanData=[];
        minData=[];
        maxData=[];
        for E=1:length(eps2)
            if eps2.EarlyOrLate(E)==0;
                numberOfStrides=eps2.Stride_No(E)*-1;
            else numberOfStrides=eps2.Stride_No(E);
            end
            
            %get data
            dt=getGroupedData(groupsUnbiased{g},labels{i},eps2.Condition{E},0,numberOfStrides,eps2.ExemptFirst(E),eps2.ExemptLast(E),1);
            dt=squeeze(dt{1});
            dt2=smoothData(dt,binWidth,'nanmean');
%             %smoothing
%             start=1:size(dt,1)-(binWidth-1);
%             stop=start+binWidth-1;
%             nbins=length(start);
%             
%             dt2=NaN(length(start),size(dt,2));
%             %running average for each subject
%             for s=1:size(dt,2)
%                 for binNum=1:length(start)
%                     dt2(binNum,s)=nanmean(dt(start(binNum):stop(binNum),s));
%                 end
%             end
            if Inds(1)==0
                Inds=1:size(dt2,1);
            else
                Inds=Inds(end)+21:Inds(end)+size(dt2,1)+20;
            end
           %plot here directly, ohterwise patches mess up
            plot(ph(i,1),Inds,nanmean(dt2,2),'ok','MarkerSize',5,'MarkerFaceColor',faceCols(g,:),'MarkerEdgeColor',faceCols(g,:))
            patch(ph(i,1),[Inds fliplr(Inds)],[nanmean(dt2,2)+(nanstd(dt2')'./sqrt(size(dt2,2))); flipud(nanmean(dt2,2)-(nanstd(dt2')'./sqrt(size(dt2,2))))],patchCols(g,:),'FaceAlpha',0.25,'EdgeColor','k');
            
%             meanData=[meanData;nan(20,1);nanmean(dt2,2)];%group AVG
%             meanData=[meanData;nan(20,1);nanmean(dt2,2)];%group AVG
%             meanData=[meanData;nan(20,1);nanmean(dt2,2)];%group AVG
%             meanData=[meanData;nan(20,1);nanmean(dt2,2)];%group AVG
%             minData=[minData;nan(20,1);nanmean(dt2,2)-nanstd(dt2')'./sqrt(size(dt2,2))];%mean-SEM
%             maxData=[maxData;nan(20,1);nanmean(dt2,2)+nanstd(dt2')'./sqrt(size(dt2,2))];%mean+SEM
            
        end
        pa=findobj(ph(i,1),'Type','Patch');
        for n=1:length(pa)
            uistack(pa(n),'bottom')            
        end
        pt=patch(ph(i,1),[1:31 fliplr(1:31)],[-1*ones(1,31) ones(1,31)],[0.7 0.7 0.7],'FaceAlpha',1,'EdgeColor','none');uistack(pt,'bottom') 
        pt=patch(ph(i,1),[52:66 fliplr(52:66)],[-1*ones(1,15) ones(1,15)],[0.7 0.7 0.7],'FaceAlpha',1,'EdgeColor','none');uistack(pt,'bottom') 
        pt=patch(ph(i,1),[563:593 fliplr(563:593)],[-1*ones(1,31) ones(1,31)],[0.7 0.7 0.7],'FaceAlpha',1,'EdgeColor','none');uistack(pt,'bottom') 
        pt=patch(ph(i,1),[614:628 fliplr(614:628)],[-1*ones(1,15) ones(1,15)],[0.7 0.7 0.7],'FaceAlpha',1,'EdgeColor','none');uistack(pt,'bottom') 
        
%         meanData=meanData(21:end,1);
%         minData=minData(21:end,1);
%         maxData=maxData(21:end,1);
        
        %plot Data
       
        
        
        
    end
end



%get epoch data and generate data for plot
for i=1:length(groups)
    contrasts{i}=table;
    for p=1:length(labels) 
        contrasts{i}.(['eA_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(2,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
        contrasts{i}.(['lA_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(3,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
        contrasts{i}.(['eP_lA_',labels{p}])=squeeze(groups{i}.getEpochData(eps(4,:),labels{p})-groups{i}.getEpochData(eps(3,:),labels{p}));
        contrasts{i}.(['eP_B_',labels{p}])=squeeze(groups{i}.getEpochData(eps(4,:),labels{p})-groups{i}.getEpochData(eps(1,:),labels{p}));
    end    
end
contrastnames={'eA_B','lA_B','eP_lA','eP_B'};

spatialDataControls=NaN(length(controls2.adaptData),4);
spatialDataStroke=NaN(length(patients2.adaptData),4);
temporalDataControls=NaN(length(controls2.adaptData),4);
temporalDataStroke=NaN(length(patients2.adaptData),4);
velocityDataControls=NaN(length(controls2.adaptData),4);
velocityDataStroke=NaN(length(patients2.adaptData),4);
netDataControls=NaN(length(controls2.adaptData),4);
netDataStroke=NaN(length(patients2.adaptData),4);

for c=1:length(contrastnames)
    spatialDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','spatialContributionNorm2']);
    spatialDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','spatialContributionNorm2']);
    temporalDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','stepTimeContributionNorm2']);
    temporalDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','stepTimeContributionNorm2']);
    velocityDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','velocityContributionNorm2']);
    velocityDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','velocityContributionNorm2']);
    netDataControls(:,c)=contrasts{1}.([contrastnames{c},'_','netContributionNorm2']);
    netDataStroke(:,c)=contrasts{2}.([contrastnames{c},'_','netContributionNorm2']);
    
end

%run paired t-test stats with Bonferroni correction for each parameter
stat=table;
stat.param=repmat({''},length(contrastnames)*length(labels),1);
row=1;
for l=1:length(labels)
    for c=1:length(contrastnames)
        stat.param(row)=labels(l);
        stat.contrast(row)=contrastnames(c);
        [h,p,ci]=ttest2(contrasts{1}.([contrastnames{c},'_',labels{l}]),contrasts{2}.([contrastnames{c},'_',labels{l}]));
        %[p,h]=ranksum(contrasts{1}.([contrastnames{c},'_',labels{l}]),contrasts{2}.([contrastnames{c},'_',labels{l}]));ci=[0 0];
        stat.meandif(row)=nanmean(contrasts{1}.([contrastnames{c},'_',labels{l}]))-nanmean(contrasts{2}.([contrastnames{c},'_',labels{l}]));
        stat.lowerbound(row)=ci(1);
        stat.upperboutn(row)=ci(2);
        stat.pval(row)=p;
        stat.pvalBonferroni(row)=p*length(contrastnames);   
        row=row+1;
        
    end
end

set(ph(:,:),'FontSize',16,'TitleFontSizeMultiplier',1.1,'box','off');


%generate plots for between epoch measures
xval=[1 2;4 5;7 8;10 11];
nc=size(spatialDataControls,1);
ns=size(spatialDataStroke,1);
hold(ph(1,2));
bar(ph(1,2),xval(:,1),nanmean(spatialDataControls),'FaceColor',faceCols(1,:),'BarWidth',0.2)
errorbar(ph(1,2),xval(:,1),nanmean(spatialDataControls),nanstd(spatialDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(1,2),xval(:,2),nanmean(spatialDataStroke),'FaceColor',faceCols(2,:),'BarWidth',0.2)
errorbar(ph(1,2),xval(:,2),nanmean(spatialDataStroke),nanstd(spatialDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(1,2),xval(1,:),[0.15 0.15],'-k','LineWidth',2)
ll=findobj(ph(1,2),'Type','Bar');
legend(ll(end:-1:1),{'CONTROL','STROKE'},'box','off','Position',[0.6800 0.9135 0.0762 0.0569]);

hold(ph(2,2));
bar(ph(2,2),xval(:,1),nanmean(temporalDataControls),'FaceColor',faceCols(1,:),'BarWidth',0.2)
errorbar(ph(2,2),xval(:,1),nanmean(temporalDataControls),nanstd(temporalDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(2,2),xval(:,2),nanmean(temporalDataStroke),'FaceColor',faceCols(2,:),'BarWidth',0.2)
errorbar(ph(2,2),xval(:,2),nanmean(temporalDataStroke),nanstd(temporalDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')

hold(ph(3,2));
bar(ph(3,2),xval(:,1),nanmean(velocityDataControls),'FaceColor',faceCols(1,:),'BarWidth',0.2)
errorbar(ph(3,2),xval(:,1),nanmean(velocityDataControls),nanstd(velocityDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(3,2),xval(:,2),nanmean(velocityDataStroke),'FaceColor',faceCols(2,:),'BarWidth',0.2)
errorbar(ph(3,2),xval(:,2),nanmean(velocityDataStroke),nanstd(velocityDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')

hold(ph(4,2));
bar(ph(4,2),xval(:,1),nanmean(netDataControls),'FaceColor',faceCols(1,:),'BarWidth',0.2)
errorbar(ph(4,2),xval(:,1),nanmean(netDataControls),nanstd(netDataControls)./sqrt(nc),'Color','k','LineWidth',2,'LineStyle','none')
bar(ph(4,2),xval(:,2),nanmean(netDataStroke),'FaceColor',faceCols(2,:),'BarWidth',0.2)
errorbar(ph(4,2),xval(:,2),nanmean(netDataStroke),nanstd(netDataStroke)./sqrt(ns),'Color','k','LineWidth',2,'LineStyle','none')
plot(ph(4,2),xval(1,:),[-0.3 -0.3],'-k','LineWidth',2)

%set titles and labels
set(ph(:,2),'XTick',nanmean(xval,2),'XTickLabel',{''},'XLim',[0.5 11.5])
set(ph(4,2),'XTickLabel',{'eA_B','lA_B','eP_l_A','eP_B'})
set(ph(:,1),'XTick',[20 365 700],'XTickLabel',{''},'XLim',[1 804])
set(ph(4,1),'XTickLabel',{'BASE','ADAPTATION','POST-ADAPTATION'})

set(ph(1,1),'YLim',[-0.1 0.2],'YTick',[-0.1 0 0.1 0.2])
set(ph(2,1),'YLim',[-0.05 0.2],'YTick',[0 0.1 0.2])
set(ph(3,1),'YLim',[-0.4 0.2],'YTick',[-0.4 -0.2 0 0.2])
set(ph(4,1),'YLim',[-0.4 0.2],'YTick',[-0.4 -0.2 0 0.2])

set(ph(1,2),'YLim',[-0.2 0.2],'YTick',[-0.2 0 0.2])
set(ph(2,2),'YLim',[-0.2 0.2],'YTick',[-0.2 0 0.2])
set(ph(3,2),'YLim',[-0.4 0.4],'YTick',[-0.4 -0.2 0 0.2 0.4])
set(ph(4,2),'YLim',[-0.4 0.2],'YTick',[-0.4 -0.2 0 0.2])

title(ph(1,1),'StepPosition')
title(ph(2,1),'StepTime')
title(ph(3,1),'StepVelocity')
title(ph(4,1),'StepAsym')
title(ph(1,2),'StepPosition')
title(ph(2,2),'StepTime')
title(ph(3,2),'StepVelocity')
title(ph(4,2),'StepAsym')

set(gcf,'Renderer','painters');




