%clear all; close all
td='S:\Shared\Digna\Synergy study\Raw files\';
load([td 'MergedAngleData6.mat'])

stancecontroldata.baselineData.fastKnee=NaN(15,150);
stancecontroldata.baselineData.slowKnee=NaN(15,150);
stancecontroldata.AdaptData.fastKnee=NaN(15,950);
stancecontroldata.AdaptData.slowKnee=NaN(15,950);

stancestrokedata.baselineData.fastKnee=NaN(15,150);
stancestrokedata.baselineData.slowKnee=NaN(15,150);
stancestrokedata.AdaptData.fastKnee=NaN(15,950);
stancestrokedata.AdaptData.slowKnee=NaN(15,950);

for c=1:15
    meancontroldata.baselineData.fastLimb(c,:)=nanmean(controldata(c).baselineData.fastLimb);
    meancontroldata.baselineData.slowLimb(c,:)=nanmean(controldata(c).baselineData.slowLimb);
    meancontroldata.baselineData.fastHip(c,:)=nanmean(controldata(c).baselineData.fastHip);
    meancontroldata.baselineData.slowHip(c,:)=nanmean(controldata(c).baselineData.slowHip);
    meancontroldata.baselineData.fastKnee(c,:)=nanmean(controldata(c).baselineData.fastKnee);
    meancontroldata.baselineData.slowKnee(c,:)=nanmean(controldata(c).baselineData.slowKnee);
    meancontroldata.baselineData.fastAnk(c,:)=nanmean(controldata(c).baselineData.fastAnk);
    meancontroldata.baselineData.slowAnk(c,:)=nanmean(controldata(c).baselineData.slowAnk);
    
    meancontroldata.AdaptData.fastLimb(c,:)=nanmean(controldata(c).AdaptData.fastLimb(end-39:end,:));
    meancontroldata.AdaptData.slowLimb(c,:)=nanmean(controldata(c).AdaptData.slowLimb(end-39:end,:));
    meancontroldata.AdaptData.fastHip(c,:)=nanmean(controldata(c).AdaptData.fastHip(end-39:end,:));
    meancontroldata.AdaptData.slowHip(c,:)=nanmean(controldata(c).AdaptData.slowHip(end-39:end,:));
    meancontroldata.AdaptData.fastKnee(c,:)=nanmean(controldata(c).AdaptData.fastKnee(end-39:end,:));
    meancontroldata.AdaptData.slowKnee(c,:)=nanmean(controldata(c).AdaptData.slowKnee(end-39:end,:));
    meancontroldata.AdaptData.fastAnk(c,:)=nanmean(controldata(c).AdaptData.fastAnk(end-39:end,:));
    meancontroldata.AdaptData.slowAnk(c,:)=nanmean(controldata(c).AdaptData.slowAnk(end-39:end,:));
    
    
    meanstrokedata.baselineData.fastLimb(c,:)=nanmean(strokedata(c).baselineData.fastLimb);
    meanstrokedata.baselineData.slowLimb(c,:)=nanmean(strokedata(c).baselineData.slowLimb);
    meanstrokedata.baselineData.fastHip(c,:)=nanmean(strokedata(c).baselineData.fastHip);
    meanstrokedata.baselineData.slowHip(c,:)=nanmean(strokedata(c).baselineData.slowHip);
    meanstrokedata.baselineData.fastKnee(c,:)=nanmean(strokedata(c).baselineData.fastKnee);
    meanstrokedata.baselineData.slowKnee(c,:)=nanmean(strokedata(c).baselineData.slowKnee);
    meanstrokedata.baselineData.fastAnk(c,:)=nanmean(strokedata(c).baselineData.fastAnk);
    meanstrokedata.baselineData.slowAnk(c,:)=nanmean(strokedata(c).baselineData.slowAnk);
    
    meanstrokedata.AdaptData.fastLimb(c,:)=nanmean(strokedata(c).AdaptData.fastLimb(end-39:end,:));
    meanstrokedata.AdaptData.slowLimb(c,:)=nanmean(strokedata(c).AdaptData.slowLimb(end-39:end,:));
    meanstrokedata.AdaptData.fastHip(c,:)=nanmean(strokedata(c).AdaptData.fastHip(end-39:end,:));
    meanstrokedata.AdaptData.slowHip(c,:)=nanmean(strokedata(c).AdaptData.slowHip(end-39:end,:));
    meanstrokedata.AdaptData.fastKnee(c,:)=nanmean(strokedata(c).AdaptData.fastKnee(end-39:end,:));
    meanstrokedata.AdaptData.slowKnee(c,:)=nanmean(strokedata(c).AdaptData.slowKnee(end-39:end,:));
    meanstrokedata.AdaptData.fastAnk(c,:)=nanmean(strokedata(c).AdaptData.fastAnk(end-39:end,:));
    meanstrokedata.AdaptData.slowAnk(c,:)=nanmean(strokedata(c).AdaptData.slowAnk(end-39:end,:));
    
    
    meancontroldata.baselineData.fastHipVEL(c,:)=nanmean(controldata(c).baselineData.fastHipVEL);
    meancontroldata.baselineData.slowHipVEL(c,:)=nanmean(controldata(c).baselineData.slowHipVEL);
    meancontroldata.baselineData.fastKneeVEL(c,:)=nanmean(controldata(c).baselineData.fastKneeVEL);
    meancontroldata.baselineData.slowKneeVEL(c,:)=nanmean(controldata(c).baselineData.slowKneeVEL);
    meancontroldata.baselineData.fastAnkVEL(c,:)=nanmean(controldata(c).baselineData.fastAnkVEL);
    meancontroldata.baselineData.slowAnkVEL(c,:)=nanmean(controldata(c).baselineData.slowAnkVEL);
    
    meancontroldata.AdaptData.fastHipVEL(c,:)=nanmean(controldata(c).AdaptData.fastHipVEL(end-39:end,:));
    meancontroldata.AdaptData.slowHipVEL(c,:)=nanmean(controldata(c).AdaptData.slowHipVEL(end-39:end,:));
    meancontroldata.AdaptData.fastKneeVEL(c,:)=nanmean(controldata(c).AdaptData.fastKneeVEL(end-39:end,:));
    meancontroldata.AdaptData.slowKneeVEL(c,:)=nanmean(controldata(c).AdaptData.slowKneeVEL(end-39:end,:));
    meancontroldata.AdaptData.fastAnkVEL(c,:)=nanmean(controldata(c).AdaptData.fastAnkVEL(end-39:end,:));
    meancontroldata.AdaptData.slowAnkVEL(c,:)=nanmean(controldata(c).AdaptData.slowAnkVEL(end-39:end,:));
    
    
    meanstrokedata.baselineData.fastHipVEL(c,:)=nanmean(strokedata(c).baselineData.fastHipVEL);
    meanstrokedata.baselineData.slowHipVEL(c,:)=nanmean(strokedata(c).baselineData.slowHipVEL);
    meanstrokedata.baselineData.fastKneeVEL(c,:)=nanmean(strokedata(c).baselineData.fastKneeVEL);
    meanstrokedata.baselineData.slowKneeVEL(c,:)=nanmean(strokedata(c).baselineData.slowKneeVEL);
    meanstrokedata.baselineData.fastAnkVEL(c,:)=nanmean(strokedata(c).baselineData.fastAnkVEL);
    meanstrokedata.baselineData.slowAnkVEL(c,:)=nanmean(strokedata(c).baselineData.slowAnkVEL);
    
    meanstrokedata.AdaptData.fastHipVEL(c,:)=nanmean(strokedata(c).AdaptData.fastHipVEL(end-39:end,:));
    meanstrokedata.AdaptData.slowHipVEL(c,:)=nanmean(strokedata(c).AdaptData.slowHipVEL(end-39:end,:));
    meanstrokedata.AdaptData.fastKneeVEL(c,:)=nanmean(strokedata(c).AdaptData.fastKneeVEL(end-39:end,:));
    meanstrokedata.AdaptData.slowKneeVEL(c,:)=nanmean(strokedata(c).AdaptData.slowKneeVEL(end-39:end,:));
    meanstrokedata.AdaptData.fastAnkVEL(c,:)=nanmean(strokedata(c).AdaptData.fastAnkVEL(end-39:end,:));
    meanstrokedata.AdaptData.slowAnkVEL(c,:)=nanmean(strokedata(c).AdaptData.slowAnkVEL(end-39:end,:));
    
    stancecontroldata.baselineData.fastKnee(c,1:145)=nanmean(controldata(c).baselineData.fastKnee(end-144:end,1:45)');
    stancecontroldata.baselineData.slowKnee(c,1:145)=nanmean(controldata(c).baselineData.slowKnee(end-144:end,1:45)');
    stancecontroldata.AdaptData.fastKnee(c,1:length(controldata(c).AdaptData.fastKnee))=nanmean(controldata(c).AdaptData.fastKnee(:,1:45)');
    stancecontroldata.AdaptData.slowKnee(c,1:length(controldata(c).AdaptData.slowKnee))=nanmean(controldata(c).AdaptData.slowKnee(:,1:45)');
    
    stancestrokedata.baselineData.fastKnee(c,1:145)=nanmean(strokedata(c).baselineData.fastKnee(end-144:end,1:45)')';
    stancestrokedata.baselineData.slowKnee(c,1:145)=nanmean(strokedata(c).baselineData.slowKnee(end-144:end,1:45)')';
    stancestrokedata.AdaptData.fastKnee(c,1:length(strokedata(c).AdaptData.fastKnee))=nanmean(strokedata(c).AdaptData.fastKnee(:,1:45)')';
    stancestrokedata.AdaptData.slowKnee(c,1:length(strokedata(c).AdaptData.slowKnee))=nanmean(strokedata(c).AdaptData.slowKnee(:,1:45)')';
    
    
end

clear dt
dt.str_bas_fast= mean(meanstrokedata.baselineData.fastKnee(:,1:15)');
dt.str_adap_fast= mean(meanstrokedata.AdaptData.fastKnee(:,1:15)');
dt.str_bas_slow= mean(meanstrokedata.baselineData.slowKnee(:,1:15)');
dt.str_adap_slow= mean(meanstrokedata.AdaptData.slowKnee(:,1:15)');

dt.con_bas_fast= mean(meancontroldata.baselineData.fastKnee(:,1:15)');
dt.con_adap_fast= mean(meancontroldata.AdaptData.fastKnee(:,1:15)');
dt.con_bas_slow= mean(meancontroldata.baselineData.slowKnee(:,1:15)');
dt.con_adap_slow= mean(meancontroldata.AdaptData.slowKnee(:,1:15)');

% clear dt
% dt.str_bas_fast= mean(abs(meanstrokedata.baselineData.fastKneeVEL(:,60:100)'));
% dt.str_adap_fast= mean(abs(meanstrokedata.AdaptData.fastKneeVEL(:,60:100)'));
% dt.str_bas_slow= mean(abs(meanstrokedata.baselineData.slowKneeVEL(:,60:100)'));
% dt.str_adap_slow= mean(abs(meanstrokedata.AdaptData.slowKneeVEL(:,60:100)'));
% 
% dt.con_bas_fast= mean(abs(meancontroldata.baselineData.fastKneeVEL(:,60:100)'));
% dt.con_adap_fast= mean(abs(meancontroldata.AdaptData.fastKneeVEL(:,60:100)'));
% dt.con_bas_slow= mean(abs(meancontroldata.baselineData.slowKneeVEL(:,60:100)'));
% dt.con_adap_slow= mean(abs(meancontroldata.AdaptData.slowKneeVEL(:,60:100)'));

dt.str_dif_fast=dt.str_adap_fast-dt.str_bas_fast;
dt.str_dif_slow=dt.str_adap_slow-dt.str_bas_slow;

dt.con_dif_fast=dt.con_adap_fast-dt.con_bas_fast;
dt.con_dif_slow=dt.con_adap_slow-dt.con_bas_slow;

x1=[0.8 1.8];x2=[1.2 2.2];
figure
subplot 221
hold on
bar(x1,[nanmean(dt.con_bas_fast) nanmean(dt.con_adap_fast)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(dt.str_bas_fast) nanmean(dt.str_adap_fast)],'FaceColor','r','BarWidth',0.3)
legend('control','stroke')
title('Knee angle between IHS and CTO')
h1=errorbar(x1,[nanmean(dt.con_bas_fast) nanmean(dt.con_adap_fast)],[nanstd(dt.con_bas_fast) nanstd(dt.con_adap_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(dt.str_bas_fast) nanmean(dt.str_adap_fast)],[nanstd(dt.str_bas_fast) nanstd(dt.str_adap_fast)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''},'YTick',[0 5 10 20]);ylabel('fast')
subplot 223
hold on
bar(x1,[nanmean(dt.con_bas_slow) nanmean(dt.con_adap_slow)],'FaceColor','g','BarWidth',0.3)
bar(x2,[nanmean(dt.str_bas_slow) nanmean(dt.str_adap_slow)],'FaceColor','r','BarWidth',0.3)
h1=errorbar(x1,[nanmean(dt.con_bas_slow) nanmean(dt.con_adap_slow)],[nanstd(dt.con_bas_slow) nanstd(dt.con_adap_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
h2=errorbar(x2,[nanmean(dt.str_bas_slow) nanmean(dt.str_adap_slow)],[nanstd(dt.str_bas_slow) nanstd(dt.str_adap_slow)]);set(h2,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'Baseline','Late Adaptation'},'YTick',[0 5 10 20]);ylabel('slow')


x=[1 2];
figure
subplot 221
hold on
bar(x,[nanmean(dt.con_dif_fast) nanmean(dt.str_dif_fast)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(dt.con_dif_fast) nanmean(dt.str_dif_fast)],[nanstd(dt.con_dif_fast) nanstd(dt.str_dif_fast)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
title('Knee angle between IHS and CTO Adap-Bas')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{''});ylabel('fast')
subplot 223
hold on 
bar(x,[nanmean(dt.con_dif_slow) nanmean(dt.str_dif_slow)],'FaceColor',[0.5 0.5 0.5])
h1=errorbar(x,[nanmean(dt.con_dif_slow) nanmean(dt.str_dif_slow)],[nanstd(dt.con_dif_slow) nanstd(dt.str_dif_slow)]);set(h1,'LineStyle','none','LineWidth',2,'Color','k')
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'CON','STR'});ylabel('slow')
%plot baseline angles stroke and control
fdfsd

figure
subplot 411
hold on
plot([60:1000],nanmean(stancecontroldata.baselineData.fastKnee),'ok','MarkerFaceColor','r')
plot([151:1100],nanmean(stancecontroldata.AdaptData.fastKnee),'ok','MarkerFaceColor','g')
h=legend('Baseline','Adaptation');set(h,'FontSize',20)
h=title('Fast Leg');set(h,'FontSize',20)
ylabel('control')
subplot 412
hold on
plot([60:1000],nanmean(stancestrokedata.baselineData.fastKnee),'ok','MarkerFaceColor','r')
plot([151:1100],nanmean(stancestrokedata.AdaptData.fastKnee),'ok','MarkerFaceColor','g')
ylabel('stroke')
subplot 413
hold on
plot([60:1000],nanmean(stancecontroldata.baselineData.slowKnee),'ok','MarkerFaceColor','r')
plot([151:1100],nanmean(stancecontroldata.AdaptData.slowKnee),'ok','MarkerFaceColor','g')
h=legend('Baseline','Adaptation');set(h,'FontSize',20)
h=title('Slow Leg');set(h,'FontSize',20)
ylabel('control')
subplot 414
hold on
plot([60:1000],nanmean(stancestrokedata.baselineData.slowKnee),'ok','MarkerFaceColor','r')
plot([151:1100],nanmean(stancestrokedata.AdaptData.slowKnee),'ok','MarkerFaceColor','g')
ylabel('stroke')

x1=1:140;
x2=141:1000;
figure
subplot 211
hold on
plot([x1],nanmean(stancecontroldata.baselineData.fastKnee(:,1:length(x1))),'ok','MarkerFaceColor','g')
plot([x2],nanmean(stancecontroldata.AdaptData.fastKnee(:,1:length(x2))),'ok','MarkerFaceColor',[0.07 0.21 0.14])
plot([x1],nanmean(stancestrokedata.baselineData.fastKnee(:,1:length(x1))),'ok','MarkerFaceColor','r')
plot([x2],nanmean(stancestrokedata.AdaptData.fastKnee(:,1:length(x2))),'ok','MarkerFaceColor',[0.85 0.5 0])
h=legend('Baseline control','Adaptation control','Baseline stroke','Adaptation stroke');set(h,'FontSize',20)
patch([x1 fliplr(x1)]',[nanmean(stancecontroldata.baselineData.fastKnee(:,1:length(x1)))+nanstd(stancecontroldata.baselineData.fastKnee(:,1:length(x1))) fliplr(nanmean(stancecontroldata.baselineData.fastKnee(:,1:length(x1)))-nanstd(stancecontroldata.baselineData.fastKnee(:,1:length(x1))))],'g','FaceAlpha',0.5,'EdgeColor','none')
patch([x1 fliplr(x1)]',[nanmean(stancestrokedata.baselineData.fastKnee(:,1:length(x1)))+nanstd(stancestrokedata.baselineData.fastKnee(:,1:length(x1))) fliplr(nanmean(stancestrokedata.baselineData.fastKnee(:,1:length(x1)))-nanstd(stancestrokedata.baselineData.fastKnee(:,1:length(x1))))],'r','FaceAlpha',0.5,'EdgeColor','none')
patch([x2 fliplr(x2)]',[nanmean(stancecontroldata.AdaptData.fastKnee(:,1:length(x2)))+nanstd(stancecontroldata.AdaptData.fastKnee(:,1:length(x2))) fliplr(nanmean(stancecontroldata.AdaptData.fastKnee(:,1:length(x2)))-nanstd(stancecontroldata.AdaptData.fastKnee(:,1:length(x2))))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x2 fliplr(x2)]',[nanmean(stancestrokedata.AdaptData.fastKnee(:,1:length(x2)))+nanstd(stancestrokedata.AdaptData.fastKnee(:,1:length(x2))) fliplr(nanmean(stancestrokedata.AdaptData.fastKnee(:,1:length(x2)))-nanstd(stancestrokedata.AdaptData.fastKnee(:,1:length(x2))))],[0.85 0.5 0],'FaceAlpha',0.5,'EdgeColor','none')

h=title('Fast Leg');set(h,'FontSize',20)
ylabel('Average Knee angle between IHC and CHC');set(gca,'FontSize',20)

subplot 212
hold on
plot([x1],nanmean(stancecontroldata.baselineData.slowKnee(:,1:length(x1))),'ok','MarkerFaceColor','g')
plot([x2],nanmean(stancecontroldata.AdaptData.slowKnee(:,1:length(x2))),'ok','MarkerFaceColor',[0.07 0.21 0.14])
plot([x1],nanmean(stancestrokedata.baselineData.slowKnee(:,1:length(x1))),'ok','MarkerFaceColor','r')
plot([x2],nanmean(stancestrokedata.AdaptData.slowKnee(:,1:length(x2))),'ok','MarkerFaceColor',[0.85 0.5 0])
patch([x1 fliplr(x1)]',[nanmean(stancecontroldata.baselineData.slowKnee(:,1:length(x1)))+nanstd(stancecontroldata.baselineData.slowKnee(:,1:length(x1))) fliplr(nanmean(stancecontroldata.baselineData.slowKnee(:,1:length(x1)))-nanstd(stancecontroldata.baselineData.slowKnee(:,1:length(x1))))],'g','FaceAlpha',0.5,'EdgeColor','none')
patch([x1 fliplr(x1)]',[nanmean(stancestrokedata.baselineData.slowKnee(:,1:length(x1)))+nanstd(stancestrokedata.baselineData.slowKnee(:,1:length(x1))) fliplr(nanmean(stancestrokedata.baselineData.slowKnee(:,1:length(x1)))-nanstd(stancestrokedata.baselineData.slowKnee(:,1:length(x1))))],'r','FaceAlpha',0.5,'EdgeColor','none')
patch([x2 fliplr(x2)]',[nanmean(stancecontroldata.AdaptData.slowKnee(:,1:length(x2)))+nanstd(stancecontroldata.AdaptData.slowKnee(:,1:length(x2))) fliplr(nanmean(stancecontroldata.AdaptData.slowKnee(:,1:length(x2)))-nanstd(stancecontroldata.AdaptData.slowKnee(:,1:length(x2))))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x2 fliplr(x2)]',[nanmean(stancestrokedata.AdaptData.slowKnee(:,1:length(x2)))+nanstd(stancestrokedata.AdaptData.slowKnee(:,1:length(x2))) fliplr(nanmean(stancestrokedata.AdaptData.slowKnee(:,1:length(x2)))-nanstd(stancestrokedata.AdaptData.slowKnee(:,1:length(x2))))],[0.85 0.5 0],'FaceAlpha',0.5,'EdgeColor','none')

h=title('Slow Leg');set(h,'FontSize',20)
set(gca,'FontSize',20)


    


fsd

figure
subplot 421
hold on; title('Baseline Fast');ylabel('Limb Angle');
plot(meancontroldata.baselineData.fastLimb','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.fastLimb','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 422
hold on; title('Baseline Slow');
plot(meancontroldata.baselineData.slowLimb','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.slowLimb','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 423
hold on;ylabel('Hip Angle');
plot(meancontroldata.baselineData.fastHip','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.fastHip','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 424
hold on;
plot(meancontroldata.baselineData.slowHip','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.slowHip','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 425
hold on;ylabel('Knee Angle');
plot(meancontroldata.baselineData.fastKnee','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.fastKnee','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 426
hold on;
plot(meancontroldata.baselineData.slowKnee','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.slowKnee','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 427
hold on;ylabel('Ankle Angle');
plot(meancontroldata.baselineData.fastAnk','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.fastAnk','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 428
hold on;
plot(meancontroldata.baselineData.slowAnk','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.baselineData.slowAnk','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

figure
subplot 421
hold on; title('Adaptation Fast');ylabel('Limb Angle');
plot(meancontroldata.AdaptData.fastLimb','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.fastLimb','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 422
hold on; title('Adaptation Slow');
plot(meancontroldata.AdaptData.slowLimb','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.slowLimb','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 423
hold on;ylabel('Hip Angle');
plot(meancontroldata.AdaptData.fastHip','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.fastHip','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 424
hold on;
plot(meancontroldata.AdaptData.slowHip','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.slowHip','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 425
hold on;ylabel('Knee Angle');
plot(meancontroldata.AdaptData.fastKnee','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.fastKnee','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 426
hold on;
plot(meancontroldata.AdaptData.slowKnee','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.slowKnee','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 427
hold on;ylabel('Ankle Angle');
plot(meancontroldata.AdaptData.fastAnk','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.fastAnk','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 428
hold on;
plot(meancontroldata.AdaptData.slowAnk','Color',[0.07 0.21 0.14],'LineWidth',2)
plot(meanstrokedata.AdaptData.slowAnk','Color',[0.64 0.08 0.28],'LineWidth',2)
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

x=1:100;

figure
subplot 321
hold on; title('Baseline Fast');ylabel('Limb Angle');
plot(nanmean(meancontroldata.baselineData.fastLimb),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.fastLimb)+nanstd(meancontroldata.baselineData.fastLimb) fliplr(nanmean(meancontroldata.baselineData.fastLimb)-nanstd(meancontroldata.baselineData.fastLimb))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.fastLimb),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.fastLimb)+nanstd(meanstrokedata.baselineData.fastLimb) fliplr(nanmean(meanstrokedata.baselineData.fastLimb)-nanstd(meanstrokedata.baselineData.fastLimb))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 322
hold on; title('Baseline Slow');
plot(nanmean(meancontroldata.baselineData.slowLimb),'Color',[0.07 0.21 0.14],'LineWidth',2)
plot(nanmean(meanstrokedata.baselineData.slowLimb),'Color',[0.64 0.08 0.28],'LineWidth',2)
h=legend('control','stroke');set(h,'FontSize',20);
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.slowLimb)+nanstd(meancontroldata.baselineData.slowLimb) fliplr(nanmean(meancontroldata.baselineData.slowLimb)-nanstd(meancontroldata.baselineData.slowLimb))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.slowLimb)+nanstd(meanstrokedata.baselineData.slowLimb) fliplr(nanmean(meanstrokedata.baselineData.slowLimb)-nanstd(meanstrokedata.baselineData.slowLimb))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})



subplot 323
hold on; ylabel('Hip Angle');
plot(nanmean(meancontroldata.baselineData.fastHip),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.fastHip)+nanstd(meancontroldata.baselineData.fastHip) fliplr(nanmean(meancontroldata.baselineData.fastHip)-nanstd(meancontroldata.baselineData.fastHip))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.fastHip),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.fastHip)+nanstd(meanstrokedata.baselineData.fastHip) fliplr(nanmean(meanstrokedata.baselineData.fastHip)-nanstd(meanstrokedata.baselineData.fastHip))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 324
hold on; 
plot(nanmean(meancontroldata.baselineData.slowHip),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.slowHip)+nanstd(meancontroldata.baselineData.slowHip) fliplr(nanmean(meancontroldata.baselineData.slowHip)-nanstd(meancontroldata.baselineData.slowHip))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.slowHip),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.slowHip)+nanstd(meanstrokedata.baselineData.slowHip) fliplr(nanmean(meanstrokedata.baselineData.slowHip)-nanstd(meanstrokedata.baselineData.slowHip))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 325
hold on; ylabel('Knee Angle');
plot(nanmean(meancontroldata.baselineData.fastKnee),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.fastKnee)+nanstd(meancontroldata.baselineData.fastKnee) fliplr(nanmean(meancontroldata.baselineData.fastKnee)-nanstd(meancontroldata.baselineData.fastKnee))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.fastKnee),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.fastKnee)+nanstd(meanstrokedata.baselineData.fastKnee) fliplr(nanmean(meanstrokedata.baselineData.fastKnee)-nanstd(meanstrokedata.baselineData.fastKnee))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 326
hold on; 
plot(nanmean(meancontroldata.baselineData.slowKnee),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.slowKnee)+nanstd(meancontroldata.baselineData.slowKnee) fliplr(nanmean(meancontroldata.baselineData.slowKnee)-nanstd(meancontroldata.baselineData.slowKnee))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.slowKnee),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.slowKnee)+nanstd(meanstrokedata.baselineData.slowKnee) fliplr(nanmean(meanstrokedata.baselineData.slowKnee)-nanstd(meanstrokedata.baselineData.slowKnee))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

figure
subplot 321
hold on; title('Adapt Fast');ylabel('Limb Angle');
plot(nanmean(meancontroldata.AdaptData.fastLimb),'Color',[0.07 0.21 0.14],'LineWidth',2)
plot(nanmean(meanstrokedata.AdaptData.fastLimb),'Color',[0.64 0.08 0.28],'LineWidth',2)

patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.fastLimb)+nanstd(meancontroldata.AdaptData.fastLimb) fliplr(nanmean(meancontroldata.AdaptData.fastLimb)-nanstd(meancontroldata.AdaptData.fastLimb))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.fastLimb)+nanstd(meanstrokedata.AdaptData.fastLimb) fliplr(nanmean(meanstrokedata.AdaptData.fastLimb)-nanstd(meanstrokedata.AdaptData.fastLimb))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 322
hold on; title('Adapt Slow');
plot(nanmean(meancontroldata.AdaptData.slowLimb),'Color',[0.07 0.21 0.14],'LineWidth',2)
plot(nanmean(meanstrokedata.AdaptData.slowLimb),'Color',[0.64 0.08 0.28],'LineWidth',2)
h=legend('control','stroke');set(h,'FontSize',20);
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.slowLimb)+nanstd(meancontroldata.AdaptData.slowLimb) fliplr(nanmean(meancontroldata.AdaptData.slowLimb)-nanstd(meancontroldata.AdaptData.slowLimb))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.slowLimb)+nanstd(meanstrokedata.AdaptData.slowLimb) fliplr(nanmean(meanstrokedata.AdaptData.slowLimb)-nanstd(meanstrokedata.AdaptData.slowLimb))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})



subplot 323
hold on; ylabel('Hip Angle');
plot(nanmean(meancontroldata.AdaptData.fastHip),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.fastHip)+nanstd(meancontroldata.AdaptData.fastHip) fliplr(nanmean(meancontroldata.AdaptData.fastHip)-nanstd(meancontroldata.AdaptData.fastHip))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.fastHip),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.fastHip)+nanstd(meanstrokedata.AdaptData.fastHip) fliplr(nanmean(meanstrokedata.AdaptData.fastHip)-nanstd(meanstrokedata.AdaptData.fastHip))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 324
hold on; 
plot(nanmean(meancontroldata.AdaptData.slowHip),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.slowHip)+nanstd(meancontroldata.AdaptData.slowHip) fliplr(nanmean(meancontroldata.AdaptData.slowHip)-nanstd(meancontroldata.AdaptData.slowHip))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.slowHip),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.slowHip)+nanstd(meanstrokedata.AdaptData.slowHip) fliplr(nanmean(meanstrokedata.AdaptData.slowHip)-nanstd(meanstrokedata.AdaptData.slowHip))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 325
hold on; ylabel('Knee Angle');
plot(nanmean(meancontroldata.AdaptData.fastKnee),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.fastKnee)+nanstd(meancontroldata.AdaptData.fastKnee) fliplr(nanmean(meancontroldata.AdaptData.fastKnee)-nanstd(meancontroldata.AdaptData.fastKnee))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.fastKnee),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.fastKnee)+nanstd(meanstrokedata.AdaptData.fastKnee) fliplr(nanmean(meanstrokedata.AdaptData.fastKnee)-nanstd(meanstrokedata.AdaptData.fastKnee))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})


subplot 326
hold on; 
plot(nanmean(meancontroldata.AdaptData.slowKnee),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.slowKnee)+nanstd(meancontroldata.AdaptData.slowKnee) fliplr(nanmean(meancontroldata.AdaptData.slowKnee)-nanstd(meancontroldata.AdaptData.slowKnee))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.slowKnee),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.slowKnee)+nanstd(meanstrokedata.AdaptData.slowKnee) fliplr(nanmean(meanstrokedata.AdaptData.slowKnee)-nanstd(meanstrokedata.AdaptData.slowKnee))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

%plot velocities
x=1:100;

figure
subplot 221
hold on; title('Baseline Fast');ylabel('Hip Ang Vel');
plot(nanmean(meancontroldata.baselineData.fastHipVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.fastHipVEL)+nanstd(meancontroldata.baselineData.fastHipVEL) fliplr(nanmean(meancontroldata.baselineData.fastHipVEL)-nanstd(meancontroldata.baselineData.fastHipVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.fastHipVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.fastHipVEL)+nanstd(meanstrokedata.baselineData.fastHipVEL) fliplr(nanmean(meanstrokedata.baselineData.fastHipVEL)-nanstd(meanstrokedata.baselineData.fastHipVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 222
hold on; title('Baseline Slow');
plot(nanmean(meancontroldata.baselineData.slowHipVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
plot(nanmean(meanstrokedata.baselineData.slowHipVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
h=legend('control','stroke');set(h,'FontSize',20)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.slowHipVEL)+nanstd(meancontroldata.baselineData.slowHipVEL) fliplr(nanmean(meancontroldata.baselineData.slowHipVEL)-nanstd(meancontroldata.baselineData.slowHipVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.slowHipVEL)+nanstd(meanstrokedata.baselineData.slowHipVEL) fliplr(nanmean(meanstrokedata.baselineData.slowHipVEL)-nanstd(meanstrokedata.baselineData.slowHipVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 223
hold on; ylabel('Knee Ang Vel');
plot(nanmean(meancontroldata.baselineData.fastKneeVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.fastKneeVEL)+nanstd(meancontroldata.baselineData.fastKneeVEL) fliplr(nanmean(meancontroldata.baselineData.fastKneeVEL)-nanstd(meancontroldata.baselineData.fastKneeVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.fastKneeVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.fastKneeVEL)+nanstd(meanstrokedata.baselineData.fastKneeVEL) fliplr(nanmean(meanstrokedata.baselineData.fastKneeVEL)-nanstd(meanstrokedata.baselineData.fastKneeVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 224
hold on; 
plot(nanmean(meancontroldata.baselineData.slowKneeVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.baselineData.slowKneeVEL)+nanstd(meancontroldata.baselineData.slowKneeVEL) fliplr(nanmean(meancontroldata.baselineData.slowKneeVEL)-nanstd(meancontroldata.baselineData.slowKneeVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.baselineData.slowKneeVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.baselineData.slowKneeVEL)+nanstd(meanstrokedata.baselineData.slowKneeVEL) fliplr(nanmean(meanstrokedata.baselineData.slowKneeVEL)-nanstd(meanstrokedata.baselineData.slowKneeVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

figure
subplot 221
hold on; title('Adaptation Fast');ylabel('Hip Ang Vel');
plot(nanmean(meancontroldata.AdaptData.fastHipVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.fastHipVEL)+nanstd(meancontroldata.AdaptData.fastHipVEL) fliplr(nanmean(meancontroldata.AdaptData.fastHipVEL)-nanstd(meancontroldata.AdaptData.fastHipVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.fastHipVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.fastHipVEL)+nanstd(meanstrokedata.AdaptData.fastHipVEL) fliplr(nanmean(meanstrokedata.AdaptData.fastHipVEL)-nanstd(meanstrokedata.AdaptData.fastHipVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 222
hold on; title('Adaptation Slow');
plot(nanmean(meancontroldata.AdaptData.slowHipVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
plot(nanmean(meanstrokedata.AdaptData.slowHipVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
h=legend('control','stroke');set(h,'FontSize',20)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.slowHipVEL)+nanstd(meancontroldata.AdaptData.slowHipVEL) fliplr(nanmean(meancontroldata.AdaptData.slowHipVEL)-nanstd(meancontroldata.AdaptData.slowHipVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.slowHipVEL)+nanstd(meanstrokedata.AdaptData.slowHipVEL) fliplr(nanmean(meanstrokedata.AdaptData.slowHipVEL)-nanstd(meanstrokedata.AdaptData.slowHipVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 223
hold on; ylabel('Knee Ang Vel');
plot(nanmean(meancontroldata.AdaptData.fastKneeVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.fastKneeVEL)+nanstd(meancontroldata.AdaptData.fastKneeVEL) fliplr(nanmean(meancontroldata.AdaptData.fastKneeVEL)-nanstd(meancontroldata.AdaptData.fastKneeVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.fastKneeVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.fastKneeVEL)+nanstd(meanstrokedata.AdaptData.fastKneeVEL) fliplr(nanmean(meanstrokedata.AdaptData.fastKneeVEL)-nanstd(meanstrokedata.AdaptData.fastKneeVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})

subplot 224
hold on; 
plot(nanmean(meancontroldata.AdaptData.slowKneeVEL),'Color',[0.07 0.21 0.14],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meancontroldata.AdaptData.slowKneeVEL)+nanstd(meancontroldata.AdaptData.slowKneeVEL) fliplr(nanmean(meancontroldata.AdaptData.slowKneeVEL)-nanstd(meancontroldata.AdaptData.slowKneeVEL))],[0.07 0.21 0.14],'FaceAlpha',0.5,'EdgeColor','none')
plot(nanmean(meanstrokedata.AdaptData.slowKneeVEL),'Color',[0.64 0.08 0.28],'LineWidth',2)
patch([x fliplr(x)]',[nanmean(meanstrokedata.AdaptData.slowKneeVEL)+nanstd(meanstrokedata.AdaptData.slowKneeVEL) fliplr(nanmean(meanstrokedata.AdaptData.slowKneeVEL)-nanstd(meanstrokedata.AdaptData.slowKneeVEL))],[0.64 0.08 0.28],'FaceAlpha',0.5,'EdgeColor','none')
set(gca,'XTick',[0,15, 45, 60], 'XTickLabel',{'IHS' 'CTO','CHS','ITO'})



