function [xData,yData,pctOverlap]=CompareOverlap(Data,binWidth,BinRange);

binEdges=BinRange(1):binWidth:BinRange(2);

d = computeCohen_d(Data(:,1),Data(:,2),'independent');

if min(min(Data))<BinRange(1)
    warning('Range of bins may not be accurate')
end
xData=binEdges(2:end)-0.5*binWidth;
yData=NaN(length(xData),size(Data,2));
for g=1:size(Data,2)
    yData(:,g) = histc(Data(:,g),binEdges(1:end-1));
    bar(xData,yData(:,g),'BarWidth',1,'FaceAlpha',0.5)
    
end
minData=NaN(size(yData,1),1);
for it=1:length(minData)
    minData(it,1)=min(yData(it,:));  
    
end
overlap=sum(minData);
pctOverlap=(overlap/10000)*100;
yl=get(gca,'YLim');
text(0.7,0.95*yl(2),['pctOverlap=',num2str(round(pctOverlap))]);
plot([prctile(Data(:,1),5),prctile(Data(:,1),5)],yl,'Color',[0 0.4470 0.7410],'LineWidth',2,'LineStyle','--')
plot([prctile(Data(:,1),95),prctile(Data(:,1),95)],yl,'Color',[0 0.4470 0.7410],'LineWidth',2,'LineStyle','--')
plot([prctile(Data(:,1),50),prctile(Data(:,1),50)],yl,'Color',[0 0.4470 0.7410],'LineWidth',2)

plot([prctile(Data(:,2),5),prctile(Data(:,2),5)],yl,'Color',[0.8500 0.3250 0.0980],'LineWidth',2,'LineStyle','--')
plot([prctile(Data(:,2),95),prctile(Data(:,2),95)],yl,'Color',[0.8500 0.3250 0.0980],'LineWidth',2,'LineStyle','--')
plot([prctile(Data(:,2),50),prctile(Data(:,2),50)],yl,'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
%text(0.7,0.9*yl(2),['Cohens d=',num2str(round(d,2))]);

end