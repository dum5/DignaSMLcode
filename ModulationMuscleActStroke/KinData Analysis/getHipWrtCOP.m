function [meanHIP,meanCOPs,meanCOPf,meanCOPnet]=getHipWrtCOP(expData,slowLeg,Condition,strides)

%get conditions 
base=find(ismember(expData.metaData.conditionName, Condition));base=cell2mat(expData.metaData.trialsInCondition(base));base=base(end);
if slowLeg=='R'
    gdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
else
     gdEvents={'LHS' 'RTO' 'RHS' 'LTO'};
end
    
tEvents=[15 30 15 40];

COPrData=getDataAsTS(expData.data{1, base}.COPData,'RCOPy');
COPrDataAligned=COPrData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPr=-1*nanmean(COPrDataAligned.Data(:,:,end-strides:end),3);

COPlData=getDataAsTS(expData.data{1, base}.COPData,'LCOPy');
COPlDataAligned=COPlData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPl=-1*nanmean(COPlDataAligned.Data(:,:,end-strides:end),3);

COPnetData=getDataAsTS(expData.data{1, base}.COPData,'COPy');
COPnetDataAligned=COPnetData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPnet=-1*nanmean(COPnetDataAligned.Data(:,:,end-strides:end),3);

RhipData=getDataAsTS(expData.data{1, base}.markerData,'RHIPy');
RhipDataAligned=RhipData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanRhip=-1*nanmean(RhipDataAligned.Data(:,:,end-strides:end),3);
LhipData=getDataAsTS(expData.data{1, base}.markerData,'LHIPy');
LhipDataAligned=LhipData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanLhip=-1*nanmean(LhipDataAligned.Data(:,:,end-strides:end),3);

meanHIP=nanmean([meanLhip,meanRhip]');

if slowLeg=='R'
    meanCOPs=meanCOPr;
    meanCOPf=meanCOPl;
else
    meanCOPs=meanCOPl;
    meanCOPf=meanCOPr;
    

end
% 
% figure
% hold on
% plot(1:100,meanCOPy)
% plot(1:100,meanCOPx)
% plot(1:100,meanCOPnet,'k','LineWidth',2)
% plot(1:100,meanRhip,'Color',[0.5 0.5 0.5],'LineWidth',2)
% 
% 
% legend('RCOPy','LCOPy','netCOPy')
% 
% evs=[0 15 45 60];
% set(gca,'XTick',evs,'XTickLabel',gdEvents)