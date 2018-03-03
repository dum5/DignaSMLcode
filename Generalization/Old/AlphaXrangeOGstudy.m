%plot schematic alpha and x in abrubt OG data

clear all; close all

%in this dataset, prameters need to be recomputed first
cd('S:\Shared\Digna\Data Harrisson\Abrubt YoungReprocessed');


rawfiles={'OG20RAW.mat','OG21RAW.mat','OG23RAW.mat','OG35RAW.mat','OG36RAW.mat','OG37RAW.mat','OG41RAW.mat','OG95RAW.mat','OG97RAW.mat','OG98RAW.mat'};
paramsfiles={'OG20params.mat','OG21params.mat','OG23params.mat','OG35params.mat','OG36params.mat','OG37params.mat','OG41params.mat','OG95params.mat','OG97params.mat','OG98params.mat'};
% for i=1:length(rawfiles)
%     load(rawfiles{i});
%     dt=rawExpData.process;
%     adaptData=dt.makeDataObj;
%     save(paramsfiles{i},'adaptData')
%     clear dt adaptData
% end


% %make bar plots for early and late alpha and X
% figure
% for i=1:length(rawfiles)
%   load(paramsfiles{i}); 
%     dt=adaptData; 
%    
%     dt=removeBadStrides(dt);
%     [veryEarlyPoints,earlyAlphaSlow,lateAlphaSlow] = getEarlyLateData(dt,'AlphaSlow','adaptation',0,50,50,5);
%     [veryEarlyPoints,earlyAlphaFast,lateAlphaFast] = getEarlyLateData(dt,'AlphaFast','adaptation',0,50,50,5);
%     [veryEarlyPoints,earlyXSlow,lateXSlow] = getEarlyLateData(dt,'XSlow','adaptation',0,50,50,5);
%     [veryEarlyPoints,earlyXFast,lateXFast] = getEarlyLateData(dt,'XFast','adaptation',0,50,50,5);
%     
%     subplot(3,4,i)
%     hold on
%     bar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaSlow) nanmean(lateAlphaFast)], 'FaceColor','r')
%     bar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)], 'FaceColor',[0.5 0.5 0.5])
%     h1=errorbar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaSlow) nanmean(lateAlphaFast)],...
%         [nanstd(earlyAlphaSlow) nanstd(earlyAlphaFast) nanstd(lateAlphaSlow) nanstd(lateAlphaFast)]);
%    h2=errorbar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)],...
%         [nanstd(earlyXSlow) nanstd(earlyXFast) nanstd(lateXSlow) nanstd(lateXFast)]);
%     set(h1,'Color','k','LineStyle','none');set(h2,'Color','k','LineStyle','none');
%     set(gca,'XTick',[1 2 4 5],'XTickLabel',{'slow','fast','slow','fast'},'FontSize',16,'XLim',[0 6])
%     title(['subject ',num2str(i)])
%     if i==4;legend('Alpha','X');end
%     
%    
%     clear adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
%     
% end

%plot timecourse of parameters for baselines and adaptation
slowPar='toeOffHipStanceAnkSlow';
fastPar='toeOffHipStanceAnkFast';

figure(1)
figure(2)
for i=1:length(rawfiles)
  load(paramsfiles{i});
    dt=adaptData; 
    dt=addNewParameter(dt,'toeOffHipStanceAnkSlow',@(x,y)-1*(x-y),{'takeOffLengthFast','BetaFast'},'range alphaX slow leg');
    dt=addNewParameter(dt,'toeOffHipStanceAnkFast',@(x,y)-1*(x-y),{'takeOffLengthSlow','BetaSlow'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
    slow_adapt = getParamInCond(dt,slowPar,'adaptation');
    fast_adapt = getParamInCond(dt,fastPar,'adaptation');
    slow_TMbase = getParamInCond(dt,slowPar,'TM base');
    fast_TMbase = getParamInCond(dt,fastPar,'TM base'); 
    slow_slowBase=getParamInCond(dt,slowPar,'slow base');
    fast_slowBase=getParamInCond(dt,fastPar,'slow base');
    slow_fastBase=getParamInCond(dt,slowPar,'fast base');
    fast_fastBase=getParamInCond(dt,fastPar,'fast base');
    
    get(figure(1))   
    subplot(3,4,i)
    hold on
    plot([slow_slowBase; slow_fastBase; slow_TMbase; slow_adapt],'ok','MarkerSize',2,'MarkerFaceColor',[0.9 0.5 0],'MarkerEdgeColor','none')
    plot([fast_slowBase; fast_fastBase; fast_TMbase; fast_adapt],'ok','MarkerSize',2,'MarkerFaceColor',[0 0.45 0.75],'MarkerEdgeColor','none')
    title(['subject ',num2str(i)])
    if i==4;legend(slowPar,fastPar);end
    
    l1=length(slow_slowBase);
    l2=length([slow_slowBase;slow_fastBase]);
    l3=length([slow_slowBase;slow_fastBase;slow_TMbase]);
   
    plot([l1 l1],[min([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase]) max([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase])],'-k');
    plot([l2 l2],[min([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase]) max([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase])],'-k');
    plot([l3 l3],[min([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase]) max([slow_slowBase;slow_fastBase;slow_TMbase; fast_slowBase;fast_fastBase;fast_TMbase])],'-k');
    
    get(figure(2))
    subplot(3,4,i)
    hold on
    bar([1,6],[mean(slow_slowBase) mean(fast_slowBase)],'BarWidth',0.2,'FaceColor',[0.2 1 0.6])
    bar([2,7],[mean(slow_fastBase) mean(fast_fastBase)],'BarWidth',0.2,'FaceColor',[1 0.85 0]);
    bar([3,8],[mean(slow_TMbase) mean(fast_TMbase)],'BarWidth',0.2,'FaceColor',[0.5 0.2 0.6]);
    bar([4,9],[nanmean(slow_adapt(end-39:end)) nanmean(fast_adapt(end-39:end))],'BarWidth',0.2,'FaceColor',[0 0.6 1]);
     if i==4;legend('slowBase','fastBase','TMbase','late adapt');end
     h1=errorbar([1,6],[mean(slow_slowBase) mean(fast_slowBase)],[std(slow_slowBase) std(fast_slowBase)]);set(h1,'LineStyle','none','Color','k');
     h1=errorbar([2,7],[mean(slow_fastBase) mean(fast_fastBase)],[std(slow_fastBase) std(fast_fastBase)]);set(h1,'LineStyle','none','Color','k');
     h1=errorbar([3,8],[mean(slow_TMbase) mean(fast_TMbase)],[std(slow_TMbase) std(fast_TMbase)]);set(h1,'LineStyle','none','Color','k');
     h1=errorbar([4,9],[mean(slow_adapt(end-39:end)) mean(fast_adapt(end-39:end))],[std(slow_adapt(end-39:end)) std(fast_adapt(end-39:end))]);set(h1,'LineStyle','none','Color','k');
     set(gca,'XTick',[2 7],'XTickLabel',{'Slow leg','Fast leg'})
     title(['subject ',num2str(i)])
     
    clear adaptData dt slow_adapt fast_adapt slow_TMbase fast_TMbase slow_slowBase fast_slowBase slow_fastBase fast_fastBase
    
end

fsad


figure
for i=1:length(rawfiles)
  load(paramsfiles{i});
    dt=adaptData; 
   dt=addNewParameter(dt,'alphaXrangeSlow',@(x,y)abs(x)+abs(y),{'AlphaSlow','XSlow'},'range alphaX slow leg');
   dt=addNewParameter(dt,'alphaXrangeFast',@(x,y)abs(x)+abs(y),{'AlphaFast','XFast'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
    [veryEarlyPoints,earlyAlphaSlow,lateAlphaSlow] = getEarlyLateData(dt,'AlphaXrangeSlow','adaptation',0,50,50,5);
    [veryEarlyPoints,earlyAlphaFast,lateAlphaFast] = getEarlyLateData(dt,'AlphaXrangeFast','adaptation',0,50,50,5);
   
    subplot(3,4,i)
    hold on
    bar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(lateAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaFast)], 'FaceColor','g')
    %bar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)], 'FaceColor',[0.5 0.5 0.5])
    h1=errorbar([1 2 4 5],[nanmean(earlyAlphaSlow) nanmean(lateAlphaSlow) nanmean(earlyAlphaFast) nanmean(lateAlphaFast)],...
        [nanstd(earlyAlphaSlow) nanstd(lateAlphaSlow) nanstd(earlyAlphaFast) nanstd(lateAlphaFast)]);
   %h2=errorbar([1 2 4 5],[nanmean(earlyXSlow) nanmean(earlyXFast) nanmean(lateXSlow) nanmean(lateXFast)],...
       % [nanstd(earlyXSlow) nanstd(earlyXFast) nanstd(lateXSlow) nanstd(lateXFast)]);
    set(h1,'Color','k','LineStyle','none');set(h2,'Color','k','LineStyle','none');
    set(gca,'XTick',[1 2 4 5],'XTickLabel',{'early','late','early','late'},'FontSize',16,'XLim',[0 6])
    title(['subject ',num2str(i)])
    if i==4;legend('Range');end
    
   
    clear adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end

figure
for i=1:length(rawfiles)
  load(paramsfiles{i});
    dt=adaptData; 
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
    if i==4;legend('Range slow','Range fast');end
    
   
    clear adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end




figure
for i=1:length(rawfiles)
  load(paramsfiles{i});
    dt=adaptData; 
%    dt=addNewParameter(dt,'alphaXrangeSlow',@(x,y)abs(x)+abs(y),{'AlphaSlow','XSlow'},'range alphaX slow leg');
%    dt=addNewParameter(dt,'alphaXrangeFast',@(x,y)abs(x)+abs(y),{'AlphaFast','XFast'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
    slow = getParamInCond(dt,'stepLengthSlow','adaptation');
    fast = getParamInCond(dt,'stepLengthFast','adaptation');
   slowa = getParamInCond(dt,'stepLengthSlow','TM base');
    fasta = getParamInCond(dt,'stepLengthFast','TM base'); 
   
    subplot(3,4,i)
    hold on
    plot([slowa; slow],'ok')
    plot([fasta; fast],'og')
    title(['subject ',num2str(i)])
    if i==4;legend('SL slow','SL fast');end
    
   
    clear adaptData dt earlyAlphaSlow lataAlphaSlow earlyAlphaFast lateAlphaFast earlyXSlow lateXSlow earlyXFast lateXFast
    
end



figure
x1=[1 4 7];
x2=[2 5 8];

for i=1:length(rawfiles)
  load(paramsfiles{i});
    dt=adaptData; 
%    dt=addNewParameter(dt,'alphaXrangeSlow',@(x,y)abs(x)+abs(y),{'AlphaSlow','XSlow'},'range alphaX slow leg');
%    dt=addNewParameter(dt,'alphaXrangeFast',@(x,y)abs(x)+abs(y),{'AlphaFast','XFast'},'range alphaX fast leg');
    dt=removeBadStrides(dt);
    slow = getParamInCond(dt,'stepLengthSlow','adaptation');
    fast = getParamInCond(dt,'stepLengthFast','adaptation');
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