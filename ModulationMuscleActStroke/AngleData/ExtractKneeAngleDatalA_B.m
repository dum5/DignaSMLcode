clear all
close all
clc

path='Z:\SubjectData\E01 Synergies\mat\HPF30\';
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0012','P0013','P0014','P0015','P0016'};%SJ 11 omitted, because error
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 

allnames=[strokesNames controlsNames];

RgdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
LgdEvents={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[15 30 15 40];

for i=1:length(allnames)
    
    
    load([path,allnames{i},'.mat'])
    adap=expData.metaData.getTrialsInCondition('Adaptation');
    base=expData.metaData.getTrialsInCondition('TM base');
    
    %extract data from last trial of baseline walking
    baseData=expData.data{base(length(base))}.angleData.getDataAsTS({'Rhip','LHip','Rknee','Lknee','Rank','Lank'});
    baseDataRAligned=baseData.align(expData.data{base(length(base))}.gaitEvents,RgdEvents,tEvents);
    baseDataLAligned=baseData.align(expData.data{base(length(base))}.gaitEvents,LgdEvents,tEvents);
    
    adapData=expData.data{adap(length(adap))}.angleData.getDataAsTS({'Rhip','LHip','Rknee','Lknee','Rank','Lank'});
    adapDataRAligned=adapData.align(expData.data{adap(length(adap))}.gaitEvents,RgdEvents,tEvents);
    adapDataLAligned=adapData.align(expData.data{adap(length(adap))}.gaitEvents,LgdEvents,tEvents);
        
    allsubs{i}.baseL=baseDataLAligned;
    allsubs{i}.baseR=baseDataRAligned;
    
    allsubs{i}.adapL=adapDataLAligned;
    allsubs{i}.adapR=adapDataRAligned;
   
        
    clear adapData adapDataRAligned adapDataLAligned baseData baseDataRAligned baseDataLAligned

end
    