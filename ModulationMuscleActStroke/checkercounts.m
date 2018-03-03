%This script counts the number of subjects that demonstrate a sign change
%in muscle activity from baseline to late adaptation
clear all
close all

% muslabels={'sHIP_s','sADM_s','sTFL_s','sGLU_s','sRF_s','sVL_s','sVM_s','sSEMT_s','sSEMB_s','sBF_s','sLG_s','sMG_s','sSOL_s','sPER_s','sTA_s',...
%     'fHIP_s','fADM_s','fTFL_s','fGLU_s','fRF_s','fVL_s','fVM_s','fSEMT_s','fSEMB_s','fBF_s','fLG_s','fMG_s','fSOL_s','fPER_s','fTA_s'};
slowlabels={'sADM_s','sGLU_s','sRF_s','sVL_s','sVM_s','sSEMT_s','sSEMB_s','sBF_s','sLG_s','sMG_s','sSOL_s','sPER_s','sTA_s'};
[file,path]=uigetfile('.mat','Select Group adaptation file');
load([path,file]);
groups=fieldnames(studyData);

%define epochs of interest
[eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[0],[5],'nanmean');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[0],[5],'nanmean');


%generate figures with nonparametricComparisons
fh1=figure;
ph1=subplot(2,2,1);%for slow leg controls
ph2=subplot(2,2,2);%for slow leg patients
ph3=subplot(2,2,3);%for fast leg controls
ph4=subplot(2,2,4);%for fast leg patients


[fh1,ph1,labels1,dataE_sc,dataRef_sc]=plotCheckerboards(studyData.Controls,slowlabels,eps,fh1,ph1,reps,true);
[p_sc,h_sc,alphaAdj_sc]=checkerstats(dataE_sc+dataRef_sc,dataRef_sc,1,0,0.05,'benhoch');
get(ph1);hold on
for i=1:size(p_sc,1)
    for k=1:size(p_sc,2)
        if h_sc(i,k)==1
            plot(k,i,'.','MarkerSize',10,'Color','k')
        end
    end
end

[fh1,ph3,labels2,dataE_ss,dataRef_ss]=plotCheckerboards(studyData.Stroke,slowlabels,eps,fh1,ph3,reps);
[p_ss,h_ss,alphaAdj_ss]=checkerstats(dataE_ss+dataRef_ss,dataRef_ss,1,0,0.05,'benhoch');
get(ph3);hold on
for i=1:size(p_ss,1)
    for k=1:size(p_ss,2)
        if h_ss(i,k)==1
            plot(k,i,'.','MarkerSize',10,'Color','k')
        end
    end
end