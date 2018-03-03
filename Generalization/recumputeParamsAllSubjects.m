clear all
close all

cd('Z:\SubjectData\E04 Generalization Young');
list=dir('*.mat');

for i=1:length(list)
    name=list(i).name;
    load(name)
    expData=expData.flushAndRecomputeParameters;
    adaptData=expData.makeDataObj;
    save([name(1:end-4),'PNormOG.mat'],'expData','-v7.3')
    save([name(1:end-4),'PNormOG','Params.mat'],'adaptData','-v7.3');
    clear expData adaptData
end

