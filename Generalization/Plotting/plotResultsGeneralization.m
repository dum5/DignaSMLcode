% clear all
% close all
% 
GenerateParamsTable;
prettyLabels={'Small implicit','Full abrupt','Control','Small explicit','Catch','Small implicit','TM Full Abrupt','TM Control'};
ngroups=length(groupInd);
posthoc=0;
%create table with groups of interest
% if ngroups==2
%     SelectTable=T(T.group==groupOrder{1}|T.group==groupOrder{2},:);
% elseif ngroups==3
%     SelectTable=T(T.group==groupOrder{1}|T.group==groupOrder{2}|T.group==groupOrder{3},:);    
% elseif ngroups==4
%     SelectTable=T(T.group==groupOrder{1}|T.group==groupOrder{2}|T.group==groupOrder{3}|T.group==groupOrder{4},:);   
% elseif ngroups==5
%     SelectTable=T(T.group==groupOrder{1}|T.group==groupOrder{2}|T.group==groupOrder{3}|T.group==groupOrder{4}|T.group==groupOrder{5},:);   
% end


bpars={'maxError','meanError','';'netContributionNorm2','spatialContributionNorm2','stepTimeContributionNorm2'};
tpars={'netContributionNorm2'};

fh=figure;
ph=subplot(1,1,1);
[fh,ph,stats]=plotTimeAndBarsGeneralization(T,timeCourseUnbiased,groupInd,startsplit,0,fh,ph,{'gradual adaptation'},allconds,'netContributionNorm2',bpars,params,colcodes,prettyLabels{groupInd});

%[fh,ph,stats]=plotTimeAndBarsGeneralization(T,timeCourseUnbiased,groupInd,startsplit,posthoc,fh,ph,conds,allconds,tpars,bpars,allpars,colcodes,grouplabels);


[fh,ph,stats]=plotTimeAndBarsGeneralization(T,timeCourseUnbiased,groupInd,startsplit,posthoc,fh,ph,conds,allconds,tpars,bpars,params,colcodes,prettyLabels{groupInd});
