[d,p,stats] = manova1([T.netContributionNorm2_OG_P,T.spatialContributionNorm2_OG_P],T.group);

[p1,TAB,stats2] = anova1([T.netContributionNorm2_OG_P],T.group);

 [c,m,h,nms] = multcompare(stats2);%does not work for manova;
 
 [c,m,h,nms] = multcompare(stats2,'Display','off','ctype','hsd');%does not work for manova;
 
 p3 = dunnett(stats2, [2:3], 1);