% post hoc analysis for OGpost as a % of TM post

clear all
close all

InterimAnalysisAllContributions
%Groups={'Full abrupt','No Feedback','Feedback','Control'};



colcodes=[0.6 0 0.6;0.8 0 0;0.2 0.2 1;0.6 0.6 0.6;0.9 0.9 1];
xlegend={'Gradual','Feedback','Control','Catch','Full Abrupt'};


OGpall=[AllData.Gradual.OGLA{1,4} AllData.FullAbrupt.OGLA{1,4} AllData.AbruptNoFeedback.OGLA{1,4} AllData.AbruptFeedback.OGLA{1,4} AllData.Catch.OGLA{1,4}];
figure
subplot 121
hold on
x=0;
for i = [1 4 3 5 2]
    x=x+1;
    bars=bar(x,nanmean(OGpall(:,i)),'FaceColor',colcodes(i,:));
    errorbar(x,nanmean(OGpall(:,i)),nanstd(OGpall(:,i))./sqrt(10),'Color','k','LineWidth',2)
    plot(repmat(x,1,10),OGpall(:,i),'ok')
end
 set(gca,'XtickLabel',xlegend,'XTick',1:5,'box','off','XLim',[0.5 5.5],'FontSize',20);
 title('SLA last 20 strides OGp')
 ylabel('Step Length Asym')
    
    