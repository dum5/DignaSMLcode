
function [f,pc,ps,pd,pvalc,pvals,pvalb,hc,hs,hb,dataEc,dataEs,dataBinarycTemp,dataBinarysTemp]=plotBGcompCountsCombined(f,pc,ps,pd,epoch,refepoch,par,Prefix,groups,mindif,fdr,smethod,evLabel)



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



% Np=size(labels,1);
% signMatrix=nanmedian(dataEc,4);
% signMatrix(find(signMatrix>0))=1;
% signMatrix(find(signMatrix<0))=-1;
% [dataBinaryc,dataCountc,ATSc]=generateCrossTab(groups{1},epoch,refepoch,Prefix,mindif,signMatrix,fdr);
% [dataBinarys,dataCounts,ATSs]=generateCrossTab(groups{2},epoch,refepoch,Prefix,mindif,signMatrix,fdr);
[dataEcTemp,labels]=groups{1}.getPrefixedEpochData(Prefix,epoch,true); %Padding with NaNs
Np=size(labels,1);
dataEcTemp=reshape(dataEcTemp,Np,length(Prefix),size(dataEcTemp,2),size(dataEcTemp,3));
[dataRefc]=groups{1}.getPrefixedEpochData(Prefix,refepoch, true); %Padding with NaNs
dataRefc=reshape(dataRefc,Np,length(Prefix),1,size(dataRefc,3));
dataEcTemp=dataEcTemp-dataRefc;
signMatrix=nanmedian(dataEcTemp,4);
signMatrix(find(signMatrix>0))=1;
signMatrix(find(signMatrix<0))=-1;
[dataBinarycTemp,dataCountcTemp,ATSc]=generateCrossTab(groups{1},epoch,refepoch,Prefix,mindif,signMatrix,fdr);
[dataBinarysTemp,dataCountsTemp,ATSs]=generateCrossTab(groups{2},epoch,refepoch,Prefix,mindif,signMatrix,fdr);


ATSd=alignedTimeSeries(0,1/numel(evLabel),[abs(dataCountcTemp(:,:,1))-abs(dataCountsTemp(:,:,1))],Prefix,ones(1,Np),evLabel);
ATSd.plotCheckerboard(f,pd);colorbar off
[pvalb,hb,alphaAdj_b]=checkerCountstats(dataBinarycTemp,dataBinarysTemp,0,0.05,'none');
title(['Diff ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_b)/1000)]);
get(pd);hold on
for i=1:size(hc,1)
    for k=1:size(hc,2)        
       if hb(i,k)==1 %&& (hc(i,k)==1 || hs(i,k)==1)
            plot3((k-0.5)/12,i-0.5,20,'.','MarkerSize',16,'Color','k')
       end
        %text((k-0.5)/12,i-0.5,20,num2str(abs(dataCountc(k,i))-abs(dataCounts(k,i))))
    end
end

% [pvalb,hb,alphaAdj_b]=checkerstats(dataEc,dataEs,0,par,fdr,'benhoch');
% ATS=alignedTimeSeries(0,1/numel(evLabel),[nanmedian(dataEc,4)-nanmedian(dataEs,4)],Prefix,ones(1,12),evLabel);
%  %ATS=alignedTimeSeries(0,1/numel(evLabel),dataS(:,:,i),labelPrefix,ones(1,Np),evLabel);
% ATS.plotCheckerboard(f,pd);
% colorbar off
% 
% get(pd),hold on
% for i=1:size(hs,1)
%     for k=1:size(hs,2)          
%         if hb(i,k)==1
%            %plot(k,i,'.','MarkerSize',16,'Color','k')
%            plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
%         end
%         
%     end
% end
% title(['Diff ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_b)/1000)]);


end