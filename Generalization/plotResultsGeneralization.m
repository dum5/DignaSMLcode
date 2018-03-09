clear all
close all

generateParamsTable;

%%Experiment 1
%groups: Control Feedback Gradual
Exp1Table=T(T.group=='AbruptNoFeedback' | T.group=='AbruptFeedback' | T.group=='Gradual',:);
Exp1cols=colcodes([3,4,1],:);
prettyLabels={'Control','Small explicit','Small implicit'};
groupind=[3,4,1];
bpars={'maxError','meanError','';'netContributionNorm2','spatialContributionNorm2','stepTimeContributionNorm2'}

fh=figure;
ph=subplot(1,1,1);
[fh,ph,stats]=plotTimeAndBarsGeneralization(Exp1Table,timeCourseUnbiased,groupind,startsplit,0,fh,ph,{'gradual adaptation'},allconds,'netContributionNorm2',bpars,params,Exp1cols,prettyLabels);
