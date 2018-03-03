clear all
close all

load('Z:\Users\Digna\Projects\Synergy study\Raw files\GroupDataWithAngles.mat')

%slowDS1pos
%fastDS1pos
%each variable will have one column

Stroke.base=NaN(16,12);
Stroke.adapt=NaN(16,12);
Controls.base=NaN(16,12);
Controls.adapt=NaN(16,12);


for i=[1:15];
    %stroke baseline
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle1','TM base');Stroke.base(i,1)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle7','TM base');Stroke.base(i,2)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle2','TM base');Stroke.base(i,3)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle8','TM base');Stroke.base(i,4)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle11','TM base');Stroke.base(i,5)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle5','TM base');Stroke.base(i,6)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle12','TM base');Stroke.base(i,7)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle6','TM base');Stroke.base(i,8)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle11','TM base');Stroke.base(i,9)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle5','TM base');Stroke.base(i,10)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle12','TM base');Stroke.base(i,11)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle6','TM base');Stroke.base(i,12)=nanmean(dt(5:end-5));clear dt
    
    %stroke adapt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle1','Adaptation');Stroke.adapt(i,1)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle7','Adaptation');Stroke.adapt(i,2)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle2','Adaptation');Stroke.adapt(i,3)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle8','Adaptation');Stroke.adapt(i,4)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle11','Adaptation');Stroke.adapt(i,5)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle5','Adaptation');Stroke.adapt(i,6)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle12','Adaptation');Stroke.adapt(i,7)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeAngle6','Adaptation');Stroke.adapt(i,8)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle11','Adaptation');Stroke.adapt(i,9)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle5','Adaptation');Stroke.adapt(i,10)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle12','Adaptation');Stroke.adapt(i,11)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Stroke.adaptData{i}.getParamInCond('skneeVelAngle6','Adaptation');Stroke.adapt(i,12)=nanmean(dt(end-45:end-5));clear dt
    
    
    %Controls baseline
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle1','TM base');Controls.base(i,1)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle7','TM base');Controls.base(i,2)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle2','TM base');Controls.base(i,3)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle8','TM base');Controls.base(i,4)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle11','TM base');Controls.base(i,5)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle5','TM base');Controls.base(i,6)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle12','TM base');Controls.base(i,7)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle6','TM base');Controls.base(i,8)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle11','TM base');Controls.base(i,9)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle5','TM base');Controls.base(i,10)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle12','TM base');Controls.base(i,11)=nanmean(dt(5:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle6','TM base');Controls.base(i,12)=nanmean(dt(5:end-5));clear dt
   
    %Controls adapt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle1','Adaptation');Controls.adapt(i,1)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle7','Adaptation');Controls.adapt(i,2)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle2','Adaptation');Controls.adapt(i,3)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle8','Adaptation');Controls.adapt(i,4)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle11','Adaptation');Controls.adapt(i,5)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle5','Adaptation');Controls.adapt(i,6)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle12','Adaptation');Controls.adapt(i,7)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeAngle6','Adaptation');Controls.adapt(i,8)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle11','Adaptation');Controls.adapt(i,9)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle5','Adaptation');Controls.adapt(i,10)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle12','Adaptation');Controls.adapt(i,11)=nanmean(dt(end-45:end-5));clear dt
    dt=studyData.Controls.adaptData{i}.getParamInCond('skneeVelAngle6','Adaptation');Controls.adapt(i,12)=nanmean(dt(end-45:end-5));clear dt
end

%make matrix for base and late adapt such that values can be subtracted

Stroke.Diff=Stroke.adapt-Stroke.base;
Controls.Diff=Controls.adapt-Controls.base;

%SLOW FIGS
figure
x1=[0.75 1.75];x2=[1.25 2.25]; 
subplot(3,2,1)
hold on
title('Slow Early DS')
bar(x1,[nanmean(Stroke.base(:,1)) nanmean(Stroke.adapt(:,1))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,1)) nanmean(Controls.adapt(:,1))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,1)) nanmean(Stroke.adapt(:,1))],[nanstd(Stroke.base(:,1)) nanstd(Stroke.adapt(:,1))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,1)) nanmean(Controls.adapt(:,1))],[nanstd(Controls.base(:,1)) nanstd(Controls.adapt(:,1))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle')


subplot(3,2,2)
hold on
title('Slow Late DS')
bar(x1,[nanmean(Stroke.base(:,3)) nanmean(Stroke.adapt(:,3))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,3)) nanmean(Controls.adapt(:,3))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,3)) nanmean(Stroke.adapt(:,3))],[nanstd(Stroke.base(:,3)) nanstd(Stroke.adapt(:,3))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,3)) nanmean(Controls.adapt(:,3))],[nanstd(Controls.base(:,3)) nanstd(Controls.adapt(:,3))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
legend('Stroke','Control')

subplot(3,2,3)
hold on
title('Slow Late Swing1')
bar(x1,[nanmean(Stroke.base(:,5)) nanmean(Stroke.adapt(:,5))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,5)) nanmean(Controls.adapt(:,5))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,5)) nanmean(Stroke.adapt(:,5))],[nanstd(Stroke.base(:,5)) nanstd(Stroke.adapt(:,5))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,5)) nanmean(Controls.adapt(:,5))],[nanstd(Controls.base(:,5)) nanstd(Controls.adapt(:,5))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle')

subplot(3,2,4)
hold on
title('Slow Late Swing2')
bar(x1,[nanmean(Stroke.base(:,7)) nanmean(Stroke.adapt(:,7))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,7)) nanmean(Controls.adapt(:,7))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,7)) nanmean(Stroke.adapt(:,7))],[nanstd(Stroke.base(:,7)) nanstd(Stroke.adapt(:,7))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,7)) nanmean(Controls.adapt(:,7))],[nanstd(Controls.base(:,7)) nanstd(Controls.adapt(:,7))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);

subplot(3,2,5)
hold on
title('Slow Late Swing1')
bar(x1,[nanmean(Stroke.base(:,9)) nanmean(Stroke.adapt(:,9))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,9)) nanmean(Controls.adapt(:,9))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,9)) nanmean(Stroke.adapt(:,9))],[nanstd(Stroke.base(:,9)) nanstd(Stroke.adapt(:,9))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,9)) nanmean(Controls.adapt(:,9))],[nanstd(Controls.base(:,9)) nanstd(Controls.adapt(:,9))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Velocity')

subplot(3,2,6)
hold on
title('Slow Late Swing2')
bar(x1,[nanmean(Stroke.base(:,11)) nanmean(Stroke.adapt(:,11))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,11)) nanmean(Controls.adapt(:,11))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,11)) nanmean(Stroke.adapt(:,11))],[nanstd(Stroke.base(:,11)) nanstd(Stroke.adapt(:,11))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,11)) nanmean(Controls.adapt(:,11))],[nanstd(Controls.base(:,11)) nanstd(Controls.adapt(:,11))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);


figure
x1=[0.75];x2=[1.25]; 
subplot(3,2,1)
hold on
title('Slow Early DS')
bar(x1,[nanmean(Stroke.Diff(:,1))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,1))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,1))],[nanstd(Stroke.Diff(:,1))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,1))],[nanstd(Controls.Diff(:,1))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle adapt-base')

subplot(3,2,2)
hold on
title('Slow Late DS')
bar(x1,[nanmean(Stroke.Diff(:,3))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,3))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,3))],[nanstd(Stroke.Diff(:,3))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,3))],[nanstd(Controls.Diff(:,3))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
legend('Stroke','Control')

subplot(3,2,3)
hold on
title('Slow Late Swing1')
bar(x1,[nanmean(Stroke.Diff(:,5))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,5))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,5))],[nanstd(Stroke.Diff(:,5))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,5))],[nanstd(Controls.Diff(:,5))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle adapt-base')


subplot(3,2,4)
hold on
title('Slow Late DS')
bar(x1,[nanmean(Stroke.Diff(:,7))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,7))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,7))],[nanstd(Stroke.Diff(:,7))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,7))],[nanstd(Controls.Diff(:,7))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);


subplot(3,2,5)
hold on
title('Slow Late Swing1')
bar(x1,[nanmean(Stroke.Diff(:,9))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,9))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,9))],[nanstd(Stroke.Diff(:,9))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,9))],[nanstd(Controls.Diff(:,9))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Velocity adapt-base')

subplot(3,2,6)
hold on
title('Slow Late DS')
bar(x1,[nanmean(Stroke.Diff(:,11))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,11))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,11))],[nanstd(Stroke.Diff(:,11))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,11))],[nanstd(Controls.Diff(:,11))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);

%FAST FIGS
figure
x1=[0.75 1.75];x2=[1.25 2.25]; 
subplot(3,2,1)
hold on
title('Fast Early DS')
bar(x1,[nanmean(Stroke.base(:,2)) nanmean(Stroke.adapt(:,2))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,2)) nanmean(Controls.adapt(:,2))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,2)) nanmean(Stroke.adapt(:,2))],[nanstd(Stroke.base(:,2)) nanstd(Stroke.adapt(:,2))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,2)) nanmean(Controls.adapt(:,2))],[nanstd(Controls.base(:,2)) nanstd(Controls.adapt(:,2))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle')


subplot(3,2,2)
hold on
title('Fast Late DS')
bar(x1,[nanmean(Stroke.base(:,4)) nanmean(Stroke.adapt(:,4))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,4)) nanmean(Controls.adapt(:,4))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,4)) nanmean(Stroke.adapt(:,4))],[nanstd(Stroke.base(:,4)) nanstd(Stroke.adapt(:,4))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,4)) nanmean(Controls.adapt(:,4))],[nanstd(Controls.base(:,4)) nanstd(Controls.adapt(:,4))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
legend('Stroke','Control')

subplot(3,2,3)
hold on
title('Fast Late Swing1')
bar(x1,[nanmean(Stroke.base(:,6)) nanmean(Stroke.adapt(:,6))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,6)) nanmean(Controls.adapt(:,6))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,6)) nanmean(Stroke.adapt(:,6))],[nanstd(Stroke.base(:,6)) nanstd(Stroke.adapt(:,6))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,6)) nanmean(Controls.adapt(:,6))],[nanstd(Controls.base(:,6)) nanstd(Controls.adapt(:,6))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle')

subplot(3,2,4)
hold on
title('Fast Late Swing2')
bar(x1,[nanmean(Stroke.base(:,8)) nanmean(Stroke.adapt(:,8))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,8)) nanmean(Controls.adapt(:,8))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,8)) nanmean(Stroke.adapt(:,8))],[nanstd(Stroke.base(:,8)) nanstd(Stroke.adapt(:,8))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,8)) nanmean(Controls.adapt(:,8))],[nanstd(Controls.base(:,8)) nanstd(Controls.adapt(:,8))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);

subplot(3,2,5)
hold on
title('Fast Late Swing1')
bar(x1,[nanmean(Stroke.base(:,10)) nanmean(Stroke.adapt(:,10))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,10)) nanmean(Controls.adapt(:,10))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,10)) nanmean(Stroke.adapt(:,10))],[nanstd(Stroke.base(:,10)) nanstd(Stroke.adapt(:,10))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,10)) nanmean(Controls.adapt(:,10))],[nanstd(Controls.base(:,10)) nanstd(Controls.adapt(:,10))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Velocity')

subplot(3,2,6)
hold on
title('Fast Late Swing2')
bar(x1,[nanmean(Stroke.base(:,12)) nanmean(Stroke.adapt(:,12))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.base(:,12)) nanmean(Controls.adapt(:,12))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.base(:,12)) nanmean(Stroke.adapt(:,12))],[nanstd(Stroke.base(:,12)) nanstd(Stroke.adapt(:,12))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.base(:,12)) nanmean(Controls.adapt(:,12))],[nanstd(Controls.base(:,12)) nanstd(Controls.adapt(:,12))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);


figure
x1=[0.75];x2=[1.25]; 
subplot(3,2,1)
hold on
title('Fast Early DS')
bar(x1,[nanmean(Stroke.Diff(:,2))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,2))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,2))],[nanstd(Stroke.Diff(:,2))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,2))],[nanstd(Controls.Diff(:,2))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle adapt-base')

subplot(3,2,2)
hold on
title('Fast Late DS')
bar(x1,[nanmean(Stroke.Diff(:,4))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,4))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,4))],[nanstd(Stroke.Diff(:,4))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,4))],[nanstd(Controls.Diff(:,4))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
legend('Stroke','Control')

subplot(3,2,3)
hold on
title('Fast Late Swing1')
bar(x1,[nanmean(Stroke.Diff(:,6))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,6))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,6))],[nanstd(Stroke.Diff(:,6))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,6))],[nanstd(Controls.Diff(:,6))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Angle adapt-base')


subplot(3,2,4)
hold on
title('Fast Late DS')
bar(x1,[nanmean(Stroke.Diff(:,8))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,8))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,8))],[nanstd(Stroke.Diff(:,8))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,8))],[nanstd(Controls.Diff(:,8))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);


subplot(3,2,5)
hold on
title('Fast Late Swing1')
bar(x1,[nanmean(Stroke.Diff(:,10))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,10))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,10))],[nanstd(Stroke.Diff(:,10))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,10))],[nanstd(Controls.Diff(:,10))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);
ylabel('Knee Velocity adapt-base')

subplot(3,2,6)
hold on
title('Fast Late DS')
bar(x1,[nanmean(Stroke.Diff(:,12))],'FaceColor','r','BarWidth',0.3);
bar(x2,[nanmean(Controls.Diff(:,12))],'FaceColor','g','BarWidth',0.3);
errorbar(x1,[nanmean(Stroke.Diff(:,12))],[nanstd(Stroke.Diff(:,12))],'LineStyle','none','LineWidth',2,'Color','k');
errorbar(x2,[nanmean(Controls.Diff(:,12))],[nanstd(Controls.Diff(:,12))],'LineStyle','none','LineWidth',2,'Color','k');
set(gca,'XTick',[1 2],'XTickLabel',{'base','lA'},'FontSize',20);