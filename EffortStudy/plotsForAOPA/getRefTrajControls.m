clear all
close all
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
controlPath=('Z:\SubjectData\E01 Synergies\mat\HPF30\');

events={'RHS','LTO','LHS','RTO'};
alignmentLengths=[16,64,16,64];

for c=1%:length(controlsNames)
    load([controlPath,controlsNames{c},'.mat']);
    tempRLG=expData.getAlignedField('procEMGData',TMbase,events,alignmentLengths).getPartialDataAsATS({'RLG'});
    
end




muscle='LG';
RBase=
LBase=expData.getAlignedField('procEMGData',conds(1),events([3,4,1,2]),alignmentLengths).getPartialDataAsATS({['L' muscle]});
RAdap=expData.getAlignedField('procEMGData',conds(2),events,alignmentLengths).getPartialDataAsATS({['R' muscle]});
LAdap=expData.getAlignedField('procEMGData',conds(2),events([3,4,1,2]),alignmentLengths).getPartialDataAsATS({['L' muscle]});