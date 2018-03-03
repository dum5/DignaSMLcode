%some of the conditions were not consistent, this function replaces the
%conditionneames that were different

%TM slow and TM fast were swapped, so this function fixes it. 

clear all
close all


[file,path]=uigetfile('Z:\SubjectData\E04 Generalization Young');
load([path,file]);

%make names consistent for gradual and catch group
%this is only needed for reprocessed data, since the old files were edited
%manually
studyData.Gradual=studyData.Gradual.renameConditions({'TM fastbase'},{'TM fast'});
studyData.Gradual=studyData.Gradual.renameConditions({'TM fast'},{'TM fast'});

studyData.Gradual=studyData.Gradual.renameConditions({'TM slowbase'},{'TM slow'});
studyData.Gradual=studyData.Gradual.renameConditions({'TM slow'},{'TM slow'});

studyData.Gradual=studyData.Gradual.renameConditions({'TM base'},{'TM base'});
studyData.Gradual=studyData.Gradual.renameConditions({'TM basemed'},{'TM base'});
studyData.Catch=studyData.Catch.renameConditions({'TM basemed'},{'TM base'});

%then swap slow and fast baseline names
%this needs to be done for old and reprocessed data files
groupsnames=fieldnames(studyData);
for i=1:length(groupsnames)
   dt=eval(['studyData.',groupsnames{i}]);
   
   dt=dt.renameConditions({'TM fast'},{'temp'});
   dt=dt.renameConditions({'TM slow'},{'TM fast'});
   dt=dt.renameConditions({'temp'},{'TM slow'});
   
   eval(['studyData.',groupsnames{i},'=dt;']);
   clear dt
end

save([path,file],'studyData','-v7.3') 
 