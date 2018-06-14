clear all
close all

cd('Z:\SubjectData\E04 Generalization Young');
list=dir('*.mat');
 h = waitbar(0,'Please wait...');
nsubs=length(list);
for i=1:nsubs
    name=list(i).name;
    close(h)
    h = waitbar(i/nsubs,['loading ',name]);
    load(name)
    expData=expData.flushAndRecomputeParameters;
    adaptData=expData.makeDataObj;
    save([name(1:end-4),'PNormOG.mat'],'expData','-v7.3')
    save([name(1:end-4),'PNormOG','Params.mat'],'adaptData','-v7.3');
    clear expData adaptData
end

