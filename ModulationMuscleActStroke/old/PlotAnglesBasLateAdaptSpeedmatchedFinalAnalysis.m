clear all; close all
td='S:\Shared\Digna\Synergy study\Raw files\';
load([td 'MergedAngleDataWithS7.mat'])

patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); 
controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); 

pnrs=[1 2 5 8 9 10 13 14 15 16];
cnrs=[1 2 4 5 6 7 9 10 12 16];



for c=1:10
    meancontroldata.baselineData.fastLimb(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastLimb(6:end-5,:));
    meancontroldata.baselineData.slowLimb(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowLimb(6:end-5,:));
    meancontroldata.baselineData.fastHip(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastHip(6:end-5,:));
    meancontroldata.baselineData.slowHip(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowHip(6:end-5,:));
    meancontroldata.baselineData.fastKnee(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastKnee(6:end-5,:));
    meancontroldata.baselineData.slowKnee(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowKnee(6:end-5,:));
    meancontroldata.baselineData.fastAnk(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastAnk(6:end-5,:));
    meancontroldata.baselineData.slowAnk(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowAnk(6:end-5,:));
    
    meancontroldata.AdaptData.fastLimb(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastLimb(end-44:end-5,:));
    meancontroldata.AdaptData.slowLimb(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowLimb(end-44:end-5,:));
    meancontroldata.AdaptData.fastHip(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastHip(end-44:end-5,:));
    meancontroldata.AdaptData.slowHip(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowHip(end-44:end-5,:));
    meancontroldata.AdaptData.fastKnee(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastKnee(end-44:end-5,:));
    meancontroldata.AdaptData.slowKnee(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowKnee(end-44:end-5,:));
    meancontroldata.AdaptData.fastAnk(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastAnk(end-44:end-5,:));
    meancontroldata.AdaptData.slowAnk(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowAnk(end-44:end-5,:));
    
    
    meanstrokedata.baselineData.fastLimb(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastLimb(6:end-5,:));
    meanstrokedata.baselineData.slowLimb(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowLimb(6:end-5,:));
    meanstrokedata.baselineData.fastHip(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastHip(6:end-5,:));
    meanstrokedata.baselineData.slowHip(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowHip(6:end-5,:));
    meanstrokedata.baselineData.fastKnee(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastKnee(6:end-5,:));
    meanstrokedata.baselineData.slowKnee(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowKnee(6:end-5,:));
    meanstrokedata.baselineData.fastAnk(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastAnk(6:end-5,:));
    meanstrokedata.baselineData.slowAnk(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowAnk(6:end-5,:));
    
    meanstrokedata.AdaptData.fastLimb(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastLimb(end-44:end-5,:));
    meanstrokedata.AdaptData.slowLimb(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowLimb(end-44:end-5,:));
    meanstrokedata.AdaptData.fastHip(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastHip(end-44:end-5,:));
    meanstrokedata.AdaptData.slowHip(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowHip(end-44:end-5,:));
    meanstrokedata.AdaptData.fastKnee(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastKnee(end-44:end-5,:));
    meanstrokedata.AdaptData.slowKnee(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowKnee(end-44:end-5,:));
    meanstrokedata.AdaptData.fastAnk(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastAnk(end-44:end-5,:));
    meanstrokedata.AdaptData.slowAnk(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowAnk(end-44:end-5,:));
    
    
    meancontroldata.baselineData.fastHipVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastHipVEL(6:end-5,:));
    meancontroldata.baselineData.slowHipVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowHipVEL(6:end-5,:));
    meancontroldata.baselineData.fastKneeVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastKneeVEL(6:end-5,:));
    meancontroldata.baselineData.slowKneeVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowKneeVEL(6:end-5,:));
    meancontroldata.baselineData.fastAnkVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.fastAnkVEL(6:end-5,:));
    meancontroldata.baselineData.slowAnkVEL(c,:)=nanmean(controldata(cnrs(c)).baselineData.slowAnkVEL(6:end-5,:));
    
    meancontroldata.AdaptData.fastHipVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastHipVEL(end-44:end-5,:));
    meancontroldata.AdaptData.slowHipVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowHipVEL(end-44:end-5,:));
    meancontroldata.AdaptData.fastKneeVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastKneeVEL(end-44:end-5,:));
    meancontroldata.AdaptData.slowKneeVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowKneeVEL(end-44:end-5,:));
    meancontroldata.AdaptData.fastAnkVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.fastAnkVEL(end-44:end-5,:));
    meancontroldata.AdaptData.slowAnkVEL(c,:)=nanmean(controldata(cnrs(c)).AdaptData.slowAnkVEL(end-44:end-5,:));
    
    
    meanstrokedata.baselineData.fastHipVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastHipVEL(6:end-5,:));
    meanstrokedata.baselineData.slowHipVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowHipVEL(6:end-5,:));
    meanstrokedata.baselineData.fastKneeVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastKneeVEL(6:end-5,:));
    meanstrokedata.baselineData.slowKneeVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowKneeVEL(6:end-5,:));
    meanstrokedata.baselineData.fastAnkVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.fastAnkVEL(6:end-5,:));
    meanstrokedata.baselineData.slowAnkVEL(c,:)=nanmean(strokedata(pnrs(c)).baselineData.slowAnkVEL(6:end-5,:));
    
    meanstrokedata.AdaptData.fastHipVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastHipVEL(end-44:end-5,:));
    meanstrokedata.AdaptData.slowHipVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowHipVEL(end-44:end-5,:));
    meanstrokedata.AdaptData.fastKneeVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastKneeVEL(end-44:end-5,:));
    meanstrokedata.AdaptData.slowKneeVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowKneeVEL(end-44:end-5,:));
    meanstrokedata.AdaptData.fastAnkVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.fastAnkVEL(end-44:end-5,:));
    meanstrokedata.AdaptData.slowAnkVEL(c,:)=nanmean(strokedata(pnrs(c)).AdaptData.slowAnkVEL(end-44:end-5,:));
    
    
    
end



%compute stance knee angles, i.e. between IHS and CHS
stancedata.str_bas_fast= mean(meanstrokedata.baselineData.fastKnee(:,1:45)');
stancedata.str_adap_fast= mean(meanstrokedata.AdaptData.fastKnee(:,1:45)');
stancedata.str_bas_slow= mean(meanstrokedata.baselineData.slowKnee(:,1:45)');
stancedata.str_adap_slow= mean(meanstrokedata.AdaptData.slowKnee(:,1:45)');

stancedata.con_bas_fast= mean(meancontroldata.baselineData.fastKnee(:,1:45)');
stancedata.con_adap_fast= mean(meancontroldata.AdaptData.fastKnee(:,1:45)');
stancedata.con_bas_slow= mean(meancontroldata.baselineData.slowKnee(:,1:45)');
stancedata.con_adap_slow= mean(meancontroldata.AdaptData.slowKnee(:,1:45)');

stancedata.str_dif_fast=stancedata.str_adap_fast-stancedata.str_bas_fast;
stancedata.str_dif_slow=stancedata.str_adap_slow-stancedata.str_bas_slow;

stancedata.con_dif_fast=stancedata.con_adap_fast-stancedata.con_bas_fast;
stancedata.con_dif_slow=stancedata.con_adap_slow-stancedata.con_bas_slow;

x1=[0.8 1.8];x2=[1.2 2.2];
figure
subplot 221
hold on
bar(x1,[nanmean(stancedata.con_bas_fast) nanmean(stancedata.con_adap_fast)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(stancedata.str_bas_fast) nanmean(stancedata.str_adap_fast)],'FaceColor','r','BarWidth',0.3)
legend('control','stroke')
title('Knee angle between IHS and CHS')
h1=errorbar(x1,[nanmean(stancedata.con_bas_fast) nanmean(stancedata.con_adap_fast)],[nanstd(stancedata.con_bas_fast) nanstd(stancedata.con_adap_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(stancedata.str_bas_fast) nanmean(stancedata.str_adap_fast)],[nanstd(stancedata.str_bas_fast) nanstd(stancedata.str_adap_fast)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''},'YTick',[0 5 10 20]);ylabel('fast')
subplot 223
hold on
bar(x1,[nanmean(stancedata.con_bas_slow) nanmean(stancedata.con_adap_slow)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(stancedata.str_bas_slow) nanmean(stancedata.str_adap_slow)],'FaceColor','r','BarWidth',0.3)
h1=errorbar(x1,[nanmean(stancedata.con_bas_slow) nanmean(stancedata.con_adap_slow)],[nanstd(stancedata.con_bas_slow) nanstd(stancedata.con_adap_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(stancedata.str_bas_slow) nanmean(stancedata.str_adap_slow)],[nanstd(stancedata.str_bas_slow) nanstd(stancedata.str_adap_slow)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'Baseline','Late Adaptation'},'YTick',[0 5 10 20]);ylabel('slow')


x=[1 2];
figure
subplot 221
hold on
bar(x,[nanmean(stancedata.con_dif_fast) nanmean(stancedata.str_dif_fast)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(stancedata.con_dif_fast) nanmean(stancedata.str_dif_fast)],[nanstd(stancedata.con_dif_fast) nanstd(stancedata.str_dif_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
title('Knee angle between IHS and CHS Adap-Bas')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''});ylabel('fast')
subplot 223
hold on 
bar(x,[nanmean(stancedata.con_dif_slow) nanmean(stancedata.str_dif_slow)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(stancedata.con_dif_slow) nanmean(stancedata.str_dif_slow)],[nanstd(stancedata.con_dif_slow) nanstd(stancedata.str_dif_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'CON','STR'});ylabel('slow')

%compute mean swing knee angles, i.e. second half of swing
swingData.str_bas_fast= mean(meanstrokedata.baselineData.fastKnee(:,81:100)');
swingData.str_adap_fast= mean(meanstrokedata.AdaptData.fastKnee(:,81:100)');
swingData.str_bas_slow= mean(meanstrokedata.baselineData.slowKnee(:,81:100)');
swingData.str_adap_slow= mean(meanstrokedata.AdaptData.slowKnee(:,81:100)');

swingData.con_bas_fast= mean(meancontroldata.baselineData.fastKnee(:,81:100)');
swingData.con_adap_fast= mean(meancontroldata.AdaptData.fastKnee(:,81:100)');
swingData.con_bas_slow= mean(meancontroldata.baselineData.slowKnee(:,81:100)');
swingData.con_adap_slow= mean(meancontroldata.AdaptData.slowKnee(:,81:100)');

swingData.str_dif_fast=swingData.str_adap_fast-swingData.str_bas_fast;
swingData.str_dif_slow=swingData.str_adap_slow-swingData.str_bas_slow;

swingData.con_dif_fast=swingData.con_adap_fast-swingData.con_bas_fast;
swingData.con_dif_slow=swingData.con_adap_slow-swingData.con_bas_slow;

x1=[0.8 1.8];x2=[1.2 2.2];
figure
subplot 221
hold on
bar(x1,[nanmean(swingData.con_bas_fast) nanmean(swingData.con_adap_fast)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(swingData.str_bas_fast) nanmean(swingData.str_adap_fast)],'FaceColor','r','BarWidth',0.3)
legend('control','stroke')
title('Knee flexion angle second half of swing')
h1=errorbar(x1,[nanmean(swingData.con_bas_fast) nanmean(swingData.con_adap_fast)],[nanstd(swingData.con_bas_fast) nanstd(swingData.con_adap_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(swingData.str_bas_fast) nanmean(swingData.str_adap_fast)],[nanstd(swingData.str_bas_fast) nanstd(swingData.str_adap_fast)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''},'YTick',[0 10 20 30 40]);ylabel('fast')
subplot 223
hold on
bar(x1,[nanmean(swingData.con_bas_slow) nanmean(swingData.con_adap_slow)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(swingData.str_bas_slow) nanmean(swingData.str_adap_slow)],'FaceColor','r','BarWidth',0.3)
h1=errorbar(x1,[nanmean(swingData.con_bas_slow) nanmean(swingData.con_adap_slow)],[nanstd(swingData.con_bas_slow) nanstd(swingData.con_adap_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(swingData.str_bas_slow) nanmean(swingData.str_adap_slow)],[nanstd(swingData.str_bas_slow) nanstd(swingData.str_adap_slow)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'Baseline','Late Adaptation'},'YTick',[0 10 20 30 40]);ylabel('slow')


x=[1 2];
figure
subplot 221
hold on
bar(x,[nanmean(swingData.con_dif_fast) nanmean(swingData.str_dif_fast)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(swingData.con_dif_fast) nanmean(swingData.str_dif_fast)],[nanstd(swingData.con_dif_fast) nanstd(swingData.str_dif_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
title('Knee flexion angle second half of swing Adap-Bas')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''});ylabel('fast')
subplot 223
hold on 
bar(x,[nanmean(swingData.con_dif_slow) nanmean(swingData.str_dif_slow)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(swingData.con_dif_slow) nanmean(swingData.str_dif_slow)],[nanstd(swingData.con_dif_slow) nanstd(swingData.str_dif_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'CON','STR'});ylabel('slow')


%compute swing knee angular velocities, i.e. second half of swing
swingVelData.str_bas_fast= mean(meanstrokedata.baselineData.fastKneeVEL(:,81:100)');
swingVelData.str_adap_fast= mean(meanstrokedata.AdaptData.fastKneeVEL(:,81:100)');
swingVelData.str_bas_slow= mean(meanstrokedata.baselineData.slowKneeVEL(:,81:100)');
swingVelData.str_adap_slow= mean(meanstrokedata.AdaptData.slowKneeVEL(:,81:100)');

swingVelData.con_bas_fast= mean(meancontroldata.baselineData.fastKneeVEL(:,81:100)');
swingVelData.con_adap_fast= mean(meancontroldata.AdaptData.fastKneeVEL(:,81:100)');
swingVelData.con_bas_slow= mean(meancontroldata.baselineData.slowKneeVEL(:,81:100)');
swingVelData.con_adap_slow= mean(meancontroldata.AdaptData.slowKneeVEL(:,81:100)');

swingVelData.str_dif_fast=swingVelData.str_adap_fast-swingVelData.str_bas_fast;
swingVelData.str_dif_slow=swingVelData.str_adap_slow-swingVelData.str_bas_slow;

swingVelData.con_dif_fast=swingVelData.con_adap_fast-swingVelData.con_bas_fast;
swingVelData.con_dif_slow=swingVelData.con_adap_slow-swingVelData.con_bas_slow;

x1=[0.8 1.8];x2=[1.2 2.2];
figure
subplot 221
hold on
bar(x1,[nanmean(swingVelData.con_bas_fast) nanmean(swingVelData.con_adap_fast)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(swingVelData.str_bas_fast) nanmean(swingVelData.str_adap_fast)],'FaceColor','r','BarWidth',0.3)
legend('control','stroke')
title('Knee angle Velocity second half of swing')
h1=errorbar(x1,[nanmean(swingVelData.con_bas_fast) nanmean(swingVelData.con_adap_fast)],[nanstd(swingVelData.con_bas_fast) nanstd(swingVelData.con_adap_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(swingVelData.str_bas_fast) nanmean(swingVelData.str_adap_fast)],[nanstd(swingVelData.str_bas_fast) nanstd(swingVelData.str_adap_fast)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''},'YTick',[-300 -200 -100 0]);ylabel('fast')
subplot 223
hold on
bar(x1,[nanmean(swingVelData.con_bas_slow) nanmean(swingVelData.con_adap_slow)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(swingVelData.str_bas_slow) nanmean(swingVelData.str_adap_slow)],'FaceColor','r','BarWidth',0.3)
h1=errorbar(x1,[nanmean(swingVelData.con_bas_slow) nanmean(swingVelData.con_adap_slow)],[nanstd(swingVelData.con_bas_slow) nanstd(swingVelData.con_adap_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(swingVelData.str_bas_slow) nanmean(swingVelData.str_adap_slow)],[nanstd(swingVelData.str_bas_slow) nanstd(swingVelData.str_adap_slow)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'Baseline','Late Adaptation'});ylabel('slow')


x=[1 2];
figure
subplot 221
hold on
bar(x,[nanmean(swingVelData.con_dif_fast) nanmean(swingVelData.str_dif_fast)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(swingVelData.con_dif_fast) nanmean(swingVelData.str_dif_fast)],[nanstd(swingVelData.con_dif_fast) nanstd(swingVelData.str_dif_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
title('Knee angle Velocity second half of swing Adap-Bas')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''},'YTick',[-300 -200 -100 0]);ylabel('fast')
subplot 223
hold on 
bar(x,[nanmean(swingVelData.con_dif_slow) nanmean(swingVelData.str_dif_slow)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(swingVelData.con_dif_slow) nanmean(swingVelData.str_dif_slow)],[nanstd(swingVelData.con_dif_slow) nanstd(swingVelData.str_dif_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'CON','STR'});ylabel('slow')



