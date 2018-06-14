% clear all
% close all
% 
% GenerateParamsTable;

outcomeParams={'maxError','meanError','netContributionNorm2_lateAdapt',...
    'maxError','meanError','netContributionNorm2_lateAdapt','netContributionNorm2_LA_ERA',...
    'netContributionNorm2_OG_P','spatialContributionNorm2_OG_P','stepTimeContributionNorm2_OG_P',...
    'netContributionNorm2_TM_P','spatialContributionNorm2_TM_P','stepTimeContributionNorm2_TM_P',...
    'netContributionNorm2_pctLearning'};
significanceThreshold=0.05;

for par=1:length(outcomeParams)
    maineff=table;
    posthocGroup=table;
   
   
    [pval,anovatab,model] = anova1(T.(outcomeParams{par}),cellstr(T.group),'off');
    wtab=[];btab=anovatab;%these are for repeated measures or mixed ANOVA's;
    c = multcompare(model,'display','off','CType','lsd');
    c2 = multcompare(model,'display','off','CType','bonferroni');
    c3 = multcompare(model,'display','off','CType','hsd');
    F=cell2mat(anovatab(2,find(strcmp(anovatab(1,:),'F')==1)));
    p=cell2mat(anovatab(2,find(strcmp(anovatab(1,:),'Prob>F')==1)));
    maineff.names={'group';'epoch';'interaction';'modelpval'};maineff.F=[F;NaN;NaN;NaN];maineff.p=[p;NaN;NaN;pval];%table with main effects
    posthocGroup.groups1=groupOrder(c(:,1))';posthocGroup.groups2=groupOrder(c(:,2))';%groups to compare
    posthocGroup.meandiff=c(:,4);posthocGroup.lowerbound=c(:,3);posthocGroup.upperbound=c(:,5);posthocGroup.pvalLSD=c(:,6);
    posthocGroup.pvalBonferroni=c2(:,6);posthocGroup.pvalTukey=c3(:,6);
    [posthocGroup.hBenHoch,dt1,dt2] = BenjaminiHochberg(c(:,6),significanceThreshold);%FDR of 0.05 seems reasonable; 
    clear F p pval c c2 c3 dt1 dt2; 
    
    resultsAnova.(outcomeParams{par}).maineff=maineff;clear maineff;
    resultsAnova.(outcomeParams{par}).btab=btab;clear btab;
    resultsAnova.(outcomeParams{par}).postHoc=posthocGroup;clear posthocGroup;
    
end
 


% [d,p,stats] = manova1([T.netContributionNorm2_OG_P,T.spatialContributionNorm2_OG_P],T.group);
% 
% [p1,TAB,stats2] = anova1([T.netContributionNorm2_OG_P],cellstr(T.group));
% 
%  [c,m,h,nms] = multcompare(stats2);%does not work for manova;
%  
%  [c,m,h,nms] = multcompare(stats2,'Display','off','ctype','hsd');%does not work for manova;
%  
%  p3 = dunnett(stats2, [1:2], 3);
%  
%  select=T(T.group=='Gradual' | T.group=='AbruptFeedback' | T.group=='AbruptNoFeedback',:);