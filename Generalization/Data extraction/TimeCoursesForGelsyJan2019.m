%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script extracts the grouped outcomes and timecourses            %
% Input: Datafile created by UICreateStudy                            %
%                                                                     %
%                                                                     %
% Output: - groupOutcomes        nParams,nEpochs,nSubjects)           %
%         - timeCourse           timeCourse(group),param(p).cond(c)   %
%         - timeCourseUnbiased                                        %
%         - NEpochOutcomes       outcomes that are not based on epochs%
%                                NEpochOutcomes(group).param(p)       %     
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all
%close all



 for g=1:8%length(groupsnames)
     ts=struct;
     tc=timeCourseUnbiased{g};
     allconds=timeCourse{g}.condNames;
     
     %OG base
     Idx=find(startsWith(timeCourse{g}.condNames,'OG base'));     
     ts.OGbase.netContribution=tc.param{1}.cond{Idx}';
     ts.OGbase.velocityContribution=tc.param{2}.cond{Idx}';clear Idx;
     
     %TM base
     Idx=find(startsWith(timeCourse{g}.condNames,'TM base'));     
     ts.TMbase.netContribution=tc.param{3}.cond{Idx}';
     ts.TMbase.velocityContribution=tc.param{4}.cond{Idx}';clear Idx;
     
     %TM base
     Idx=find(startsWith(timeCourse{g}.condNames,'gradual'));     
     ts.Adaptation.netContribution=tc.param{3}.cond{Idx}';
     ts.Adaptation.velocityContribution=tc.param{4}.cond{Idx}';clear Idx;
     
     %OG post
     Idx=find(startsWith(timeCourse{g}.condNames,'OG post'));     
     ts.OGpost.netContribution=tc.param{1}.cond{Idx}';
     ts.OGpost.velocityContribution=tc.param{2}.cond{Idx}';clear Idx;
     
     %re-adaptation
     Idx=find(startsWith(timeCourse{g}.condNames,'readaptation'));     
     ts.Readaptation.netContribution=tc.param{3}.cond{Idx}';
     ts.Readaptation.velocityContribution=tc.param{4}.cond{Idx}';clear Idx;
     
     %TM post
     Idx=find(startsWith(timeCourse{g}.condNames,'TM post'));     
     ts.TMpost.netContribution=tc.param{3}.cond{Idx}';
     ts.TMpost.velocityContribution=tc.param{4}.cond{Idx}';clear Idx;
     
     eval(['Indiv_' groupsnames{g} '=ts;']);
     clear ts
     
     
 end
 