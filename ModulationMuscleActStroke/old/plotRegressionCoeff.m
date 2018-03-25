%%plot regression results

leStrokeBs=[0.208 0.403];
leStrokeBm=[0.47 0.665];
seStrokeBs=[0.936 1.04];
seStrokeBm=[-0.115 -0.0143];

leControlBs=[0.15 0.24];
leControlBm=[0.69 0.78];
seControlBs=[1.15 1.24];
seControlBm=[-0.0641 0.034];

figure
subplot 221
hold on
xBs=[0.75 1.25];
xBm=[1.75 2.25];

plot(xBs,[nanmean(seStrokeBs) nanmean(leStrokeBs)],'-*r','MarkerSize',6,'LineWidth',2)
plot([xBs; xBs],[seStrokeBs; leStrokeBs]','-r')
plot(xBs,[nanmean(seControlBs) nanmean(leControlBs)],'-*g','MarkerSize',6,'LineWidth',2)
plot([xBs; xBs],[seControlBs; leControlBs]','-g')


plot(xBm,[nanmean(seStrokeBm) nanmean(leStrokeBm)],'-*r','MarkerSize',6,'LineWidth',2)
plot([xBm; xBm],[seStrokeBm; leStrokeBm]','-r')
plot(xBm,[nanmean(seControlBm) nanmean(leControlBm)],'-*g','MarkerSize',6,'LineWidth',2)
plot([xBm; xBm],[seControlBm; leControlBm]','-g')

set(gca,'XLim',[0.5 2.5],'XTick',[1 2],'XTickLabel',{'Bs','Bm'})
