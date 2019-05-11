%compare old vs new dataset

clear all
close all

load('Old_vs_new.mat')

% CdataEMG_new=CdataEMG_new+CBB_new;
% CdataEMG_old=CdataEMG_old+CBB_old;
% SdataEMG_new=SdataEMG_new+SBB_new;
% SdataEMG_old=SdataEMG_old+SBB_old;

StrokeCor=NaN(14,6);StrokeCos=NaN(14,6);
ControlCor=NaN(14,6);ControlCos=NaN(14,6);


for sj=1:14
        
    for c=1:6
        StrokeCor(sj,c)=corr(SdataEMG_new(:,c,sj),SdataEMG_old(:,c,sj));
        ControlCor(sj,c)=corr(CdataEMG_new(:,c,sj),CdataEMG_old(:,c,sj));
    
        StrokeCos(sj,c)=cosine(SdataEMG_new(:,c,sj),SdataEMG_old(:,c,sj));
        ControlCos(sj,c)=cosine(CdataEMG_new(:,c,sj),CdataEMG_old(:,c,sj));
    end
    
end