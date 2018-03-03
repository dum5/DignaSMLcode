
newExpData=expData.computeAngles;

gdEventsRight={'RHS' 'LTO' 'LHS' 'RTO'};
gdEventsLeft={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[15 30 15 40];
figure



trial=5;
dt=newExpData.data{1,trial}.angleData;


Rlimbangle=getDataAsTS(dt,'RLimb');
RlimbangleAligned=Rlimbangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
RlimbangleMatrix=squeeze(RlimbangleAligned.Data(:,1,:));
subplot(4,2,1);hold on
plot(RlimbangleMatrix);
title('right limb angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsRight)

Llimbangle=getDataAsTS(dt,'LLimb');
LlimbangleAligned=Llimbangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
LlimbangleMatrix=squeeze(LlimbangleAligned.Data(:,1,:));
subplot(4,2,2);hold on
plot(LlimbangleMatrix);
title('left limb angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsLeft)


Rhipangle=getDataAsTS(dt,'RThigh');
RhipangleAligned=Rhipangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
RhipangleMatrix=squeeze(RhipangleAligned.Data(:,1,:));
subplot(4,2,3);hold on
plot(RhipangleMatrix);
title('right hip angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsRight)

Lhipangle=getDataAsTS(dt,'LThigh');
LhipangleAligned=Lhipangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
LhipangleMatrix=squeeze(LhipangleAligned.Data(:,1,:));
subplot(4,2,4);hold on
plot(LhipangleMatrix);
title('left hip angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsLeft)


Rkneeangle=getDataAsTS(dt,'Rknee');
RkneeangleAligned=Rkneeangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
RkneeangleMatrix=squeeze(RkneeangleAligned.Data(:,1,:));
subplot(4,2,5);hold on
plot(RkneeangleMatrix);
title('right knee angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsRight)

Lkneeangle=getDataAsTS(dt,'Lknee');
LkneeangleAligned=Lkneeangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
LkneeangleMatrix=squeeze(LkneeangleAligned.Data(:,1,:));
subplot(4,2,6);hold on
plot(LkneeangleMatrix);
title('left knee angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsLeft)


Rankangle=getDataAsTS(dt,'Rank');
RankangleAligned=Rankangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
RankangleMatrix=squeeze(RankangleAligned.Data(:,1,:));
subplot(4,2,7);hold on
plot(RankangleMatrix);
title('right ankle angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsRight)

Lankangle=getDataAsTS(dt,'Lank');
LankangleAligned=Lankangle.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
LankangleMatrix=squeeze(LankangleAligned.Data(:,1,:));
subplot(4,2,8);hold on
plot(LankangleMatrix);
title('left ankle angle')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',gdEventsLeft)