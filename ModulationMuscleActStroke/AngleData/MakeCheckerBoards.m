clear all
close all

[file,path]=uigetfile('.mat','Select Group adaptation file');
load([path,file]);
groups=fieldnames(studyData);

%for now assume that there are two groups
fh=figure;
ph1=subplot(2,1,1);
ph2=subplot(2,1,2);

%efine epochs of interest
[eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[0],[5],'nanmean');
[reps] = defineEpochs({'Base'},{'TM base'}',[90],[5],[0],'nanmean');

g1=eval(['studyData.',groups{1}]);
g2=eval(['studyData.',groups{2}]);
[fh,ph1,labels,dataEc,dataRefc]=plotCheckerboards(g1,{'shipAngle_s','skneeAngle_s','sankangle_s','fhipAngle_s','fkneeAngle_s','fankAngle_s'},eps,fh,ph1,reps,true);
title('Controls LateAdapt-Base')
[p_c,h_c,alphaAdj_c]=checkerstats(dataEc,[],1,0,0.05,'benhoch');
get(ph1);hold on
for i=1:size(p_c,1)
    for k=1:size(p_c,2)
        if h_c(i,k)==1
            plot(k,i,'.','MarkerSize',10,'Color','k')
        end
    end
end


[fh,ph2,labels,dataEs,dataRefs]=plotCheckerboards(g2,{'shipAngle_s','skneeAngle_s','sankangle_s','fhipAngle_s','fkneeAngle_s','fankAngle_s'},eps,fh,ph2,reps,true);
title('Stroke LateAdapt-Base')


[p_s,h_s,alphaAdj_s]=checkerstats(dataEs,[],1,0,0.05,'benhoch');
[p_b,h_b,alphaAdj_b]=checkerstats(dataEc,dataEs,0,0,0.05,'benhoch');

get(ph2);hold on
for i=1:size(p_c,1)
    for k=1:size(p_c,2)
        if h_s(i,k)==1
            plot(k,i,'.','MarkerSize',10,'Color','k')
        end
        if h_b(i,k)==1
            plot(k,i,'o','MarkerSize',10,'Color','k')
        end
        
    end
end

% [fh,ph1,labels,dataEc,dataRefc]=plotCheckerboards(g1,{'skneeAngle_s','fkneeAngle_s'},eps,fh,ph1,reps,true);%the dataref matix is also aligned to ipsilateral hs
% title('Controls LateAdapt-Base')
% [fh,ph2,labels,dataEc2,dataRefc2]=plotCheckerboards(g1,{'skneeAngle_s','fkneeAngle_s'},eps,fh,ph2,reps);
% 
% 
% [fh,ph2,labels,dataEs,dataRefs]=plotCheckerboards(g2,{'skneeAngle_s'},eps,fh,ph2,reps,true);
% title('Stroke LateAdapt-Base')
