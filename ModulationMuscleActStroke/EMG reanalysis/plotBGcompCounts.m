
function [f,pc,ps,pd,pvalc,pvals,pvalb,hc,hs,hb,dataBinaryc,dataBinarys]=plotBGcompCounts(f,pc,ps,pd,epoch,refepoch,Prefix,groups,mindif,fdr)


%%generate crosstabs


%first make matrix with sign of change in controls
[dataEc,labels]=groups{1}.getPrefixedEpochData(Prefix,epoch,true); %Padding with NaNs
Np=size(labels,1);
dataEc=reshape(dataEc,Np,length(Prefix),size(dataEc,2),size(dataEc,3));
[dataRefc]=groups{1}.getPrefixedEpochData(Prefix,refepoch, true); %Padding with NaNs
dataRefc=reshape(dataRefc,Np,length(Prefix),1,size(dataRefc,3));
dataEc=dataEc-dataRefc;
signMatrix=nanmedian(dataEc,4);
signMatrix(find(signMatrix>0))=1;
signMatrix(find(signMatrix<0))=-1;

%keyboard

[dataBinaryc,dataCountc,ATSc]=generateCrossTab(groups{1},epoch,refepoch,Prefix,mindif,signMatrix,fdr);
ATSc.plotCheckerboard(f,pc); colorbar off
[pvalc,hc,alphaAdj_c]=checkerCountstats(dataBinaryc,[],1,0.05,'none');
title(['Controls ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_c)/1000)]);
get(pc);hold on
for i=1:size(hc,1)
    for k=1:size(hc,2)
        if hc(i,k)==1
             plot3((k-0.5)/12,i-0.5,20,'.','MarkerSize',16,'Color','k')             
        end
        %text((k-0.5)/12,i-0.5,20,num2str(dataCountc(k,i)))
    end
end




[dataBinarys,dataCounts,ATSs]=generateCrossTab(groups{2},epoch,refepoch,Prefix,mindif,signMatrix,fdr);
ATSs.plotCheckerboard(f,ps); colorbar off
[pvals,hs,alphaAdj_s]=checkerCountstats(dataBinarys,[],1,0.05,'none');
title(['Stroke ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_s)/1000)]);
get(ps);hold on
for i=1:size(hs,1)
    for k=1:size(hs,2)
        if hs(i,k)==1
            plot3((k-0.5)/12,i-0.5,20,'.','MarkerSize',16,'Color','k')
        end
      %  text((k-0.5)/12,i-0.5,20,num2str(dataCounts(k,i)))
    end
end


evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};

ATSd=alignedTimeSeries(0,1/numel(evLabel),[abs(dataCountc(:,:,1))-abs(dataCounts(:,:,1))],Prefix,ones(1,Np),evLabel);
ATSd.plotCheckerboard(f,pd);colorbar off
[pvalb,hb,alphaAdj_b]=checkerCountstats(dataBinaryc,dataBinarys,0,0.05,'none');
title(['Diff ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_b)/1000)]);
get(pd);hold on
for i=1:size(hc,1)
    for k=1:size(hc,2)        
       if hb(i,k)==1 %&& (hc(i,k)==1 || hs(i,k)==1)
            plot3((k-0.5)/12,i-0.5,20,'.','MarkerSize',16,'Color','k')
       end
       % text((k-0.5)/12,i-0.5,20,num2str(abs(dataCountc(k,i))-abs(dataCounts(k,i))))
    end
end


% 
% [dataEc,labels]=this.getPrefixedEpochData(Prefix,epoch,true); %Padding with NaNs
% Np=size(labels,1);
% dataEc=reshape(dataEc,Np,length(Prefix),size(dataEc,2),size(dataEc,3));
% [dataRefc]=this.getPrefixedEpochData(Prefix,refepoch, true); %Padding with NaNs
% dataRefc=reshape(dataRefc,Np,length(labelPrefix),1,size(dataRef,3));
% dataEc=dataEc-dataRefc;
% 
%          
% 
% 
% %do ChiSquare test
% [f,pc,labels,dataEc,dataRefc]=plotCheckerboards(groups{1},Prefix,epoch,f,pc,refepoch,true,smethod);
% 
% [pvalc,hc,alphaAdj_c]=checkerstats(dataEc,[],1,par,fdr,'benhoch',mindif);
% get(pc);hold on
% for i=1:size(hc,1)
%     for k=1:size(hc,2)
%         if hc(i,k)==1
%             plot(k,i,'.','MarkerSize',16,'Color','k')
%         end
%     end
% end
% title(['Controls ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_c)/1000)]);
% 
% 
% 
% [f,ps,labels,dataEs,dataRefs]=plotCheckerboards(groups{2},Prefix,epoch,f,ps,refepoch,true,smethod);
% 
% 
% 
% [pvals,hs,alphaAdj_s]=checkerstats(dataEs,[],1,par,fdr,'benhoch',mindif);
% 
% 
% get(ps);hold on
% for i=1:size(hs,1)
%     for k=1:size(hs,2)
%         %if hs(i,k)==1
%         if hs(i,k)==1
%             plot(k,i,'.','MarkerSize',16,'Color','k')
%         end
%     end
%     
% end
% title(['Stroke ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_s)/1000)]);
% 
% [pvalb,hb,alphaAdj_b]=checkerstats(dataEc,dataEs,0,par,fdr,'benhoch');
% ATS=alignedTimeSeries(0,1,[nanmedian(dataEc,4)-nanmedian(dataEs,4)],Prefix,ones(1,12),evLabel);
% ATS.plotCheckerboard(f,pd);
% colorbar off
% 
% get(pd),hold on
% for i=1:size(hs,1)
%     for k=1:size(hs,2)          
%         if hb(i,k)==1
%             plot(k,i,'.','MarkerSize',16,'Color','k')
%         end
%         
%     end
% end
% title(['Diff ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_b)/1000)]);
% 
% 
% end