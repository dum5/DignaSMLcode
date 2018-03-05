

%get conditions 
base=find(ismember(expData.metaData.conditionName, 'TM base'));base=cell2mat(expData.metaData.trialsInCondition(base));base=base(end);
gdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
tEvents=[15 30 15 40];

COPyData=getDataAsTS(expData.data{1, base}.COPData,'RCOPy');
COPyDataAligned=COPyData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPy=-1*nanmean(COPyDataAligned.Data,3);

COPxData=getDataAsTS(expData.data{1, base}.COPData,'LCOPy');
COPxDataAligned=COPxData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPx=-1*nanmean(COPxDataAligned.Data,3);

COPnetData=getDataAsTS(expData.data{1, base}.COPData,'COPy');
COPnetDataAligned=COPnetData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanCOPnet=-1*nanmean(COPnetDataAligned.Data,3);

RhipData=getDataAsTS(expData.data{1, base}.markerData,'RHIPy');
RhipDataAligned=RhipData.align(expData.data{1,base}.gaitEvents, gdEvents,tEvents);
meanRhip=-1*nanmean(RhipDataAligned.Data,3);

figure
hold on
plot(1:100,meanCOPy)
plot(1:100,meanCOPx)
plot(1:100,meanCOPnet,'k','LineWidth',2)
plot(1:100,meanRhip,'Color',[0.5 0.5 0.5],'LineWidth',2)


legend('RCOPy','LCOPy','netCOPy')

evs=[0 15 45 60];
set(gca,'XTick',evs,'XTickLabel',gdEvents)