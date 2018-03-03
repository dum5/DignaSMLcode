%plot schematic alpha and x in Dulce Data

clear all; close all

load('S:\Shared\Wouter\studyData2.mat')

figure



for i=1:length(studyData.Control.adaptData)
  
    dt=studyData.Control.adaptData{1,i};  
    dt=removeBadStrides(dt);
    [veryEarlyPoints,earlyAlphaSlow,lateAlphaSlow] = getEarlyLateData(dt,'AlphaSlow','Gradual adaptation',0,50,50,5);
    [veryEarlyPoints,earlyAlphaFast,lateAlphaFast] = getEarlyLateData(dt,'AlphaFast','Gradual adaptation',0,50,50,5);
    [veryEarlyPoints,earlyXSlow,lateXSlow] = getEarlyLateData(dt,'XSlow','Gradual adaptation',0,50,50,5);
    [veryEarlyPoints,earlyXFast,lateXFast] = getEarlyLateData(dt,'XFast','Gradual adaptation',0,50,50,5);
    
    subplot(3,4,i)
    hold on
    bar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaSlow) nanmean(lateAlphaFast)], 'FaceColor','r')
    bar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)], 'FaceColor',[0.5 0.5 0.5])
    h1=errorbar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaSlow) nanmean(lateAlphaFast)],...
        [nanstd(earlyAlphaSlow) nanstd(earlyAlphaFast) nanstd(lateAlphaSlow) nanstd(lateAlphaFast)]);
   h2=errorbar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)],...
        [nanstd(earlyXSlow) nanstd(earlyXFast) nanstd(lateXSlow) nanstd(lateXFast)]);
    set(h1,'Color','k','LineStyle','none');set(h2,'Color','k','LineStyle','none');
    set(gca,'XTick',[1 2 4 5],'XTickLabel',{'slow','fast','slow','fast'},'FontSize',16,'XLim',[0 6])
    title(['subject ',num2str(i)])
    if i==4;legend('Alpha','X');end
    
   
    clear dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end

figure
for i=1:length(studyData.Control.adaptData)
  
    dt=studyData.Control.adaptData{1,i};  
    dt=removeBadStrides(dt); 
   dt=addNewParameter(dt,'alphaXrangeSlow',@(x,y)abs(x)+abs(y),{'AlphaSlow','XSlow'},'range alphaX slow leg');
   dt=addNewParameter(dt,'alphaXrangeFast',@(x,y)abs(x)+abs(y),{'AlphaFast','XFast'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
    slow = getParamInCond(dt,'AlphaXrangeSlow','adaptation');
    fast = getParamInCond(dt,'AlphaXrangeFast','adaptation');
    
   
    subplot(3,4,i)
    hold on
    plot(slow,'ok')
    plot(fast,'og')
    title(['subject ',num2str(i)])
    set(gca,'XLim',[300 1200])
    if i==4;legend('Range slow','Range fast');end
    
   
    clear slow fast adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end



figure
x1=[1 4 7];
x2=[2 5 8];
for i=1:length(studyData.Control.adaptData)
  
    dt=studyData.Control.adaptData{1,i};  
    dt=removeBadStrides(dt); 
%    dt=addNewParameter(dt,'alphaXrangeSlow',@(x,y)abs(x)+abs(y),{'AlphaSlow','XSlow'},'range alphaX slow leg');
%    dt=addNewParameter(dt,'alphaXrangeFast',@(x,y)abs(x)+abs(y),{'AlphaFast','XFast'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
     slow = getParamInCond(dt,'stepLengthSlow','Gradual adaptation');
    fast = getParamInCond(dt,'stepLengthFast','Gradual adaptation');
    meanSL=(slow+fast)./2;
   slowa = getParamInCond(dt,'stepLengthSlow','TM base');
    fasta = getParamInCond(dt,'stepLengthFast','TM base'); 
    meanSLa=(slowa+fasta)./2;
   
    subplot(3,4,i)
    hold on
    bar1=bar(x1,[nanmean(slowa) nanmean(fasta) nanmean(meanSLa)],'FaceColor',[0.5 0.5 0.5],'BarWidth',0.3); 
    bar2=bar(x2,[nanmean(slow(end-49:end)) nanmean(fast(end-49:end)) nanmean(meanSL(end-49:end))],'FaceColor',[0.2 0.2 0.2],'BarWidth',0.3); 
   
     title(['subject ',num2str(i)])
    if i==4;legend('TM base','late adapt');end
   h1=errorbar(x1,[nanmean(slowa) nanmean(fasta) nanmean(meanSLa)],[nanstd(slowa) nanstd(fasta) nanstd(meanSLa)],'Color','k','LineStyle','none'); 
   h2=errorbar(x2,[nanmean(slow(end-49:end)) nanmean(fast(end-49:end)) nanmean(meanSL(end-49:end))],[nanstd(slow(end-49:end)) nanstd(fast(end-49:end)) nanstd(meanSL(end-49:end))],'Color','k','LineStyle','none');
   set(gca,'XTick',[1.5 4.5 7.5],'XTickLabel',{'Slow Leg','Fast Leg','Mean'}) 
   
    clear adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end