%this script reprocesses the data for controls to get propulsion and
%braking forces

subjects={'CM003_fast','CM004_fast','CM005_fast','CM006_fast','CM007_fast','CM008_fast','CM009_fast','CM010_fast','CM011_fast','CM012_fast'};
path='Z:\Users\Digna\Projects\Effort study\ReprocessedDataForces\';

updateParams(subjects,[],0)


% for i=1:length(subjects)
%     load([path,subjects{i},'_fastRAW.mat'])
%     pr=rawExpData.process;
%     par=pr.makeDataObj;
%     save([path,subjects{i},'.mat'],'pr');%save processed data
%     save([path,subjects{i},'.params.mat'],'par');%save parms data
%     clear rawExpData pr par
% end
    
    