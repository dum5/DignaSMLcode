clear all
close all
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0007','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
controlPath=('Z:\SubjectData\E01 Synergies\mat\HPF30\');

Revents={'RHS','LTO','LHS','RTO'};
Levents={'LHS','RTO','RHS','LTO'};
alignmentLengths=[16,64,16,64];

LGdata=NaN(302,32);
MGdata=NaN(302,32);
TAdata=NaN(302,32);
AnkData=NaN(302,32);
KneeData=NaN(302,32);
HipData=NaN(302,32);

col=1;
for c=1%:length(controlsNames)
    disp(['loading', controlsNames{c}]);
    load([controlPath,controlsNames{c},'.mat']);
    
    tempRLG=expData.getAlignedField('procEMGData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'RLG'});
    tempLLG=expData.getAlignedField('procEMGData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'LLG'});
    
    tempRMG=expData.getAlignedField('procEMGData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'RMG'});
    tempLMG=expData.getAlignedField('procEMGData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'LMG'});

    tempRTA=expData.getAlignedField('procEMGData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'RTA'});
    tempLTA=expData.getAlignedField('procEMGData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'LTA'});
    
    tempRank=expData.getAlignedField('angleData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'Rank'});
    tempLank=expData.getAlignedField('angleData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'Lank'});
    
    tempRknee=expData.getAlignedField('angleData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'Rank'});
    tempLknee=expData.getAlignedField('angleData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'Lank'});
    
    tempRhip=expData.getAlignedField('angleData','TM base',Revents,alignmentLengths).getPartialDataAsATS({'Rank'});
    tempLhip=expData.getAlignedField('angleData','TM base',Levents,alignmentLengths).getPartialDataAsATS({'Lank'});
    
    LGdata(:,col)=nanmean(squeeze(tempRLG.Data),2);
    MGdata(:,col)=nanmean(squeeze(tempRMG.Data),2);
    TAdata(:,col)=nanmean(squeeze(tempRTA.Data),2);
    
    AnkData(:,col)=nanmean(squeeze(tempRank.Data),2);
    KneeData(:,col)=nanmean(squeeze(tempRknee.Data),2);
    HipData(:,col)=nanmean(squeeze(tempRhip.Data),2);
    
    col=col+1;
    LGdata(:,col)=nanmean(squeeze(tempLLG.Data),2);
    MGdata(:,col)=nanmean(squeeze(tempLMG.Data),2);
    TAdata(:,col)=nanmean(squeeze(tempLTA.Data),2);
    
    AnkData(:,col)=nanmean(squeeze(tempLank.Data),2);
    KneeData(:,col)=nanmean(squeeze(tempLknee.Data),2);
    HipData(:,col)=nanmean(squeeze(tempLhip.Data),2);
    
    
    
    clear tempRLG tempLLG tempRMG tempLMG tempRTA tempLTA tempRank tempLank tempRknee tempLknee tempRhip tempRhip
    
end

