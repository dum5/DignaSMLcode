clear all
close all

cd('Z:\SubjectData\E04 Generalization Young\ExpData\TMandKinEvents');
list=dir('*.mat');

[indx,tf] = listdlg('ListString',{list.name}');

for i=indx
    name=list(i).name;
    load(name)
    expData=expData.flushAndRecomputeParameters('kin');
    adaptData=expData.makeDataObj;
    save([name, ' kin'],'expData','-v7.3')
    save([name, 'KinParams.mat'],'adaptData','-v7.3');
    clear expData adaptData
end

