clear all
close all

cd('Z:\SubjectData\E04 Generalization Young');
list=dir('*.mat');

for i=24:length(list)
    name=list(i).name;
    load(name)
    expData=expData.flushAndRecomputeParameters('kin');
    adaptData=expData.makeDataObj;
    save([name, ' kin'],'expData','-v7.3')
    save([name, 'KinParams.mat'],'adaptData','-v7.3');
    clear expData adaptData
end

