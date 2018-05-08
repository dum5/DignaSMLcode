clear all
close all

load ControlData

for c=1:size(AnkData,2)
    if max(AnkData(:,c))>30
        AnkData(:,c)=NaN(size(AnkData,1),1);
    end
end

for c=1:size(LGdata,2)
    dt=LGdata(:,c);
    dt=dt-min(dt);
    dt=dt./max(dt);
    LGdata(:,c)=dt;clear dt
    
    dt=MGdata(:,c);
    dt=dt-min(dt);
    dt=dt./max(dt);
    MGdata(:,c)=dt;clear dt
    
    dt=TAdata(:,c);
    dt=dt-min(dt);
    dt=dt./max(dt);
    TAdata(:,c)=dt;clear dt
end

nank=size(find(~isnan(AnkData(1,:))==1),2);
figure
subplot(2,3,1)
hold on
title('ANK')
plot(1:160,nanmean(AnkData,2),'g','LineWidth',2)
p=patch([1:160,fliplr(1:160)],[nanmean(AnkData,2)-nanstd(AnkData')';flipud(nanmean(AnkData,2)+nanstd(AnkData')')],'k')
set(p,'FaceAlpha',0.5,'EdgeColor','none')

subplot(2,3,2)
hold on
title('KNEE')
plot(1:160,nanmean(KneeData,2),'g','LineWidth',2)
p=patch([1:160,fliplr(1:160)],[nanmean(KneeData,2)-nanstd(KneeData')';flipud(nanmean(KneeData,2)+nanstd(KneeData')')],'k')
set(p,'FaceAlpha',0.5,'EdgeColor','none')

subplot(2,3,3)
hold on
title('HIP')
plot(1:160,nanmean(HipData,2),'g','LineWidth',2)
p=patch([1:160,fliplr(1:160)],[nanmean(HipData,2)-nanstd(HipData')';flipud(nanmean(HipData,2)+nanstd(HipData')')],'k')
set(p,'FaceAlpha',0.5,'EdgeColor','none')

