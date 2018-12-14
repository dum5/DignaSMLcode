clear all
close all

cd('Z:\SubjectData\E04 Generalization Young\ExpData\KinEvents');
list=dir('*.mat');
 %h = waitbar(0,'Please wait...');
nsubs=length(list);
T=table(cell(nsubs,1),cell(nsubs,1),cell(nsubs,1),NaN(nsubs,1),'VariableNames',{'subject','LSLOW','LSTART','StartSlow'});
for i=1:nsubs
    name=list(i).name;
    %close(h)
    %h = waitbar(i/nsubs,['loading ',name]);
    load(name)
    T.subject{i}=name;
    T.LSLOW{i}=expData.getRefLeg;
    cOGP=expData.getConditionIdxsFromName('OG post');
    tOGP=cell2mat(expData.metaData.trialsInCondition(cOGP));
    tLHS=expData.data{tOGP(1)}.getArrayedEvents('LHS');
    tRHS=expData.data{tOGP(1)}.getArrayedEvents('RHS');
    if tRHS(1)<tLHS(1)
        T.LSTART{i}='R';
    else
        T.LSTART{i}='L';
    end
    
    if strcmp(expData.getRefLeg,T.LSTART{i});
        T.StartSlow(i)=1;
    else
        T.StartSlow(i)=0;
    end

    %keyboard
    clear expData adaptData
end