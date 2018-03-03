% post hoc analysis for OGpost as a % of TM post

clear all
close all

InterimAnalysisAllContributions

groupnames=fieldnames(AllTimecourses);


colcodes1=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];colcodes=colcodes1;

xlegend={'Feedback','Control','Catch','Full Abrupt'};

figure
subplot 221
hold on
x=0;
for i = [4 3 5 2]
    x=x+1;
    bar(x-0.25, eval(['nanmean(AllData.',groupnames{i},'.OGp{4})']),'FaceColor',colcodes1(i,:),'BarWidth',0.3);
    bar(x+0.25, eval(['nanmean(AllData.',groupnames{i},'.OGpMax{4})']),'FaceColor',colcodes1(i,:),'BarWidth',0.3,'FaceAlpha',0.5);
    errorbar(x-0.25, eval(['nanmean(AllData.',groupnames{i},'.OGp{4})']),eval(['nanstd(AllData.',groupnames{i},'.OGp{4})']),'Color','k','LineWidth',2)
    errorbar(x+0.25, eval(['nanmean(AllData.',groupnames{i},'.OGpMax{4})']),eval(['nanstd(AllData.',groupnames{i},'.OGpMax{4})']),'Color','k','LineWidth',2)
    plot(repmat(x-0.25,1,10),eval(['AllData.',groupnames{i},'.OGp{4}']),'ok')
    plot(repmat(x+0.25,1,10),eval(['AllData.',groupnames{i},'.OGpMax{4}']),'ok')
end
 set(gca,'XtickLabel',xlegend,'XTick',1:4,'box','off','XLim',[0.5 4.5],'FontSize',20);
 title('OGpost s2-6 vs maximized')
 ylabel('Step Length Asymmetry')

subplot 222
hold on
x=0;
for i = [4 3 5 2]
    x=x+1;
    bar(x-0.25, eval(['nanmean(AllData.',groupnames{i},'.TMp{4})']),'FaceColor',colcodes1(i,:),'BarWidth',0.3);
    bar(x+0.25, eval(['nanmean(AllData.',groupnames{i},'.TMpMax{4})']),'FaceColor',colcodes1(i,:),'BarWidth',0.3,'FaceAlpha',0.5);
    errorbar(x-0.25, eval(['nanmean(AllData.',groupnames{i},'.TMp{4})']),eval(['nanstd(AllData.',groupnames{i},'.TMp{4})']),'Color','k','LineWidth',2)
    errorbar(x+0.25, eval(['nanmean(AllData.',groupnames{i},'.TMpMax{4})']),eval(['nanstd(AllData.',groupnames{i},'.TMpMax{4})']),'Color','k','LineWidth',2)
    plot(repmat(x-0.25,1,10),eval(['AllData.',groupnames{i},'.TMp{4}']),'ok')
    plot(repmat(x+0.25,1,10),eval(['AllData.',groupnames{i},'.TMpMax{4}']),'ok')
end
 set(gca,'XtickLabel',xlegend,'XTick',1:4,'box','off','XLim',[0.5 4.5],'FontSize',20);
 title('TMpost s2-6 vs maximized')
 ylabel('Step Length Asymmetry')



subplot 223
hold on
x=0;
for i = [4 3 5 2]
    x=x+1;
    bars=bar(x,nanmean(OGtoTM1(:,i)),'FaceColor',colcodes(i,:));
    errorbar(x,nanmean(OGtoTM1(:,i)),nanstd(OGtoTM1(:,i))./sqrt(10),'Color','k','LineWidth',2)
    plot(repmat(x,1,10),OGtoTM1(:,i),'ok')
end
 set(gca,'XtickLabel',xlegend,'XTick',1:4,'box','off','XLim',[0.5 4.5],'FontSize',20);
 title('OGpost as % of TMpost')
 ylabel('% transfer')
 
 

subplot 224
hold on
x=0;
for i = [4 3 5 2]
    x=x+1;
    bars=bar(x,nanmean(OGtoTM2(:,i)),'FaceColor',colcodes(i,:));
    errorbar(x,nanmean(OGtoTM2(:,i)),nanstd(OGtoTM2(:,i))./sqrt(10),'Color','k','LineWidth',2)
    plot(repmat(x,1,10),OGtoTM2(:,i),'ok')
end
 set(gca,'XtickLabel',xlegend,'XTick',1:4,'box','off','XLim',[0.5 4.5],'FontSize',20);
 title('OGpost as % of TMpost')
 ylabel('% transfer Maximized')
    
% figure
% x=0;
% for i = [4 3 5 2]
%     x=x+1;
%     subplot(2,2,x)
%     hold on
%     title(xlegend{x})
%     dt=eval(['AllTimecourses.' groupnames{i},'.OGp{1,4}']);
%     plot(dt(1:20,:))
%     plot(nanmean(dt(1:20,:)'),'o-k','LineWidth',2)
%     set(gca,'YLim',[-0.1 0.3],'FontSize',20)
%     xlabel('Stride No')   
%     ylabel('OG post Net')
% end