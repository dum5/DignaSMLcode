clear all
close all

matfilespath='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Data\';
load ([matfilespath,'groupedParams30Hz.mat']);
%controls=controls.removeBadStrides;
%patients=patients.removeBadStrides;

B.c.swingslow=squeeze(cell2mat(controls.getGroupedData({'swingTimeSlow'},{'TM base'},0,-40,1,1,1)));
B.c.swingfast=squeeze(cell2mat(controls.getGroupedData({'swingTimeFast'},{'TM base'},0,-40,1,1,1)));
B.c.stanceslow=squeeze(cell2mat(controls.getGroupedData({'stanceTimeSlow'},{'TM base'},0,-40,1,1,1)));
B.c.stancefast=squeeze(cell2mat(controls.getGroupedData({'stanceTimeFast'},{'TM base'},0,-40,1,1,1)));
B.c.DSslow=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportSlow'},{'TM base'},0,-40,1,1,1)));
B.c.DSfast=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportFast'},{'TM base'},0,-40,1,1,1)));

EA.c.swingslow=squeeze(cell2mat(controls.getGroupedData({'swingTimeSlow'},{'Adaptation'},0,20,1,1,1)));
EA.c.swingfast=squeeze(cell2mat(controls.getGroupedData({'swingTimeFast'},{'Adaptation'},0,20,1,1,1)));
EA.c.stanceslow=squeeze(cell2mat(controls.getGroupedData({'stanceTimeSlow'},{'Adaptation'},0,20,1,1,1)));
EA.c.stancefast=squeeze(cell2mat(controls.getGroupedData({'stanceTimeFast'},{'Adaptation'},0,20,1,1,1)));
EA.c.DSslow=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportSlow'},{'Adaptation'},0,20,1,1,1)));
EA.c.DSfast=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportFast'},{'Adaptation'},0,20,1,1,1)));

LA.c.swingslow=squeeze(cell2mat(controls.getGroupedData({'swingTimeSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.c.swingfast=squeeze(cell2mat(controls.getGroupedData({'swingTimeFast'},{'Adaptation'},0,-40,1,1,1)));
LA.c.stanceslow=squeeze(cell2mat(controls.getGroupedData({'stanceTimeSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.c.stancefast=squeeze(cell2mat(controls.getGroupedData({'stanceTimeFast'},{'Adaptation'},0,-40,1,1,1)));
LA.c.DSslow=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.c.DSfast=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportFast'},{'Adaptation'},0,-40,1,1,1)));

EP.c.swingslow=squeeze(cell2mat(controls.getGroupedData({'swingTimeSlow'},{'Washout'},0,20,1,1,1)));
EP.c.swingfast=squeeze(cell2mat(controls.getGroupedData({'swingTimeFast'},{'Washout'},0,20,1,1,1)));
EP.c.stanceslow=squeeze(cell2mat(controls.getGroupedData({'stanceTimeSlow'},{'Washout'},0,20,1,1,1)));
EP.c.stancefast=squeeze(cell2mat(controls.getGroupedData({'stanceTimeFast'},{'Washout'},0,20,1,1,1)));
EP.c.DSslow=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportSlow'},{'Washout'},0,20,1,1,1)));
EP.c.DSfast=squeeze(cell2mat(controls.getGroupedData({'DoubleSupportFast'},{'Washout'},0,20,1,1,1)));


B.p.swingslow=squeeze(cell2mat(patients.getGroupedData({'swingTimeSlow'},{'TM base'},0,-40,1,1,1)));
B.p.swingfast=squeeze(cell2mat(patients.getGroupedData({'swingTimeFast'},{'TM base'},0,-40,1,1,1)));
B.p.stanceslow=squeeze(cell2mat(patients.getGroupedData({'stanceTimeSlow'},{'TM base'},0,-40,1,1,1)));
B.p.stancefast=squeeze(cell2mat(patients.getGroupedData({'stanceTimeFast'},{'TM base'},0,-40,1,1,1)));
B.p.DSslow=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportSlow'},{'TM base'},0,-40,1,1,1)));
B.p.DSfast=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportFast'},{'TM base'},0,-40,1,1,1)));

EA.p.swingslow=squeeze(cell2mat(patients.getGroupedData({'swingTimeSlow'},{'Adaptation'},0,20,1,1,1)));
EA.p.swingfast=squeeze(cell2mat(patients.getGroupedData({'swingTimeFast'},{'Adaptation'},0,20,1,1,1)));
EA.p.stanceslow=squeeze(cell2mat(patients.getGroupedData({'stanceTimeSlow'},{'Adaptation'},0,20,1,1,1)));
EA.p.stancefast=squeeze(cell2mat(patients.getGroupedData({'stanceTimeFast'},{'Adaptation'},0,20,1,1,1)));
EA.p.DSslow=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportSlow'},{'Adaptation'},0,20,1,1,1)));
EA.p.DSfast=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportFast'},{'Adaptation'},0,20,1,1,1)));

LA.p.swingslow=squeeze(cell2mat(patients.getGroupedData({'swingTimeSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.p.swingfast=squeeze(cell2mat(patients.getGroupedData({'swingTimeFast'},{'Adaptation'},0,-40,1,1,1)));
LA.p.stanceslow=squeeze(cell2mat(patients.getGroupedData({'stanceTimeSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.p.stancefast=squeeze(cell2mat(patients.getGroupedData({'stanceTimeFast'},{'Adaptation'},0,-40,1,1,1)));
LA.p.DSslow=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportSlow'},{'Adaptation'},0,-40,1,1,1)));
LA.p.DSfast=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportFast'},{'Adaptation'},0,-40,1,1,1)));

EP.p.swingslow=squeeze(cell2mat(patients.getGroupedData({'swingTimeSlow'},{'Washout'},0,20,1,1,1)));
EP.p.swingfast=squeeze(cell2mat(patients.getGroupedData({'swingTimeFast'},{'Washout'},0,20,1,1,1)));
EP.p.stanceslow=squeeze(cell2mat(patients.getGroupedData({'stanceTimeSlow'},{'Washout'},0,20,1,1,1)));
EP.p.stancefast=squeeze(cell2mat(patients.getGroupedData({'stanceTimeFast'},{'Washout'},0,20,1,1,1)));
EP.p.DSslow=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportSlow'},{'Washout'},0,20,1,1,1)));
EP.p.DSfast=squeeze(cell2mat(patients.getGroupedData({'DoubleSupportFast'},{'Washout'},0,20,1,1,1)));

dt=LA;
figure
ha=tight_subplot(2,6,[.03 .005],.04,.04);

i=1;
bar(ha(i),(1:16),nanmean(dt.c.swingslow));hold(ha(i)) 
plot(ha(i),1:16,dt.c.swingslow,'ok')
title(ha(i),'SwingSlow')
bar(ha(i+1),(1:16),nanmean(dt.p.swingslow));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.swingslow,'ok')
i=3;
bar(ha(i),(1:16),nanmean(dt.c.swingfast));hold(ha(i)) 
plot(ha(i),1:16,dt.c.swingfast,'ok')
title(ha(i),'SwingFast')
bar(ha(i+1),(1:16),nanmean(dt.p.swingfast));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.swingfast,'ok')
i=5;
bar(ha(i),(1:16),nanmean(dt.c.stanceslow));hold(ha(i)) 
plot(ha(i),1:16,dt.c.stanceslow,'ok')
title(ha(i),'StanceSlow')
bar(ha(i+1),(1:16),nanmean(dt.p.stanceslow));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.stanceslow,'ok')
i=7;
bar(ha(i),(1:16),nanmean(dt.c.stancefast));hold(ha(i)) 
plot(ha(i),1:16,dt.c.stancefast,'ok')
title(ha(i),'StanceFast')
bar(ha(i+1),(1:16),nanmean(dt.p.stancefast));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.stancefast,'ok')
i=9;
bar(ha(i),(1:16),nanmean(dt.c.DSslow));hold(ha(i)) 
plot(ha(i),1:16,dt.c.DSslow,'ok')
title(ha(i),'DSslow')
bar(ha(i+1),(1:16),nanmean(dt.p.DSslow));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.DSslow,'ok')
i=11;
bar(ha(i),(1:16),nanmean(dt.c.DSfast));hold(ha(i)) 
plot(ha(i),1:16,dt.c.DSfast,'ok')
title(ha(i),'DSfast')
bar(ha(i+1),(1:16),nanmean(dt.p.DSfast));hold(ha(i+1)) 
plot(ha(i+1),1:16,dt.p.DSfast,'ok')

set(ha(:,:),'YLim',[0 2],'XLim',[0.5 16.5],'FontSize',12,'FontWeight','bold')
set(ha(:,2:end),'YTickLabel',{''},'XTickLabel',{''});
set(ha(:,1),'YTick',[0 1 2],'XTickLabel',{''});
ylabel(ha(1),'Controls')
ylabel(ha(2),'Stroke')



