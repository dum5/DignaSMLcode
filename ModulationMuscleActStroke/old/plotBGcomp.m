
function [f,pc,ps,pd,pvalc,pvals,pvalb,hc,hs,hb,dataEc,dataEs]=plotBGcomp(f,pc,ps,pd,epoch,refepoch,par,Prefix,groups,mindif,fdr,smethod,evLabel)



[f,pc,labels,dataEc,dataRefc]=plotCheckerboards(groups{1},Prefix,epoch,f,pc,refepoch,true,smethod);

[pvalc,hc,alphaAdj_c]=checkerstats(dataEc,[],1,par,fdr,'benhoch',mindif);
get(pc);hold on
for i=1:size(hc,1)
    for k=1:size(hc,2)
        if hc(i,k)==1              
            plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
            %plot(k,i,'.','MarkerSize',16,'Color','k')
        end
    end
end
title(['Controls ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_c)/1000)]);



[f,ps,labels,dataEs,dataRefs]=plotCheckerboards(groups{2},Prefix,epoch,f,ps,refepoch,true,smethod);
title('Stroke LateAdapt-Base')


[pvals,hs,alphaAdj_s]=checkerstats(dataEs,[],1,par,fdr,'benhoch',mindif);


get(ps);hold on
for i=1:size(hs,1)
    for k=1:size(hs,2)
        %if hs(i,k)==1
        if hs(i,k)==1
            plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
           % plot(k,i,'.','MarkerSize',16,'Color','k')
        end
    end
    
end
title(['Stroke ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_s)/1000)]);

[pvalb,hb,alphaAdj_b]=checkerstats(dataEc,dataEs,0,par,fdr,'benhoch');
ATS=alignedTimeSeries(0,1/numel(evLabel),[nanmedian(dataEc,4)-nanmedian(dataEs,4)],Prefix,ones(1,12),evLabel);
 %ATS=alignedTimeSeries(0,1/numel(evLabel),dataS(:,:,i),labelPrefix,ones(1,Np),evLabel);
ATS.plotCheckerboard(f,pd);
colorbar off

get(pd),hold on
for i=1:size(hs,1)
    for k=1:size(hs,2)          
        if hb(i,k)==1
           %plot(k,i,'.','MarkerSize',16,'Color','k')
           plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
        end
        
    end
end
title(['Diff ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_b)/1000)]);


end