%some of the conditions were not consistent, this function replaces the
%conditionneames that were different

%TM slow and TM fast were swapped, so this function fixes it. 

clear all
close all


[file,path]=uigetfile('Z:\Users\Digna\Projects\Generalization\3to1VS2to1');
load([path,file]);

%make names consistent for gradual and catch group
%this is only needed for reprocessed data, since the old files were edited
%manually
studyData.Perception3to1= studyData.Perception3to1.renameConditions({'catchadaptatio'},{'TM post'});

studyData.Interference2to1=studyData.Interference2to1.renameConditions({'baseline'},{'TM base'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'tm base'},{'TM base'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'Adaptation 1'},{'adaptation'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'tied'},{'TM post'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'tied belt'},{'TM post'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'tied belts'},{'TM post'});
studyData.Interference2to1=studyData.Interference2to1.renameConditions({'tm post'},{'TM post'});



save([path,file],'studyData','-v7.3') 
 