%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function generates plots for within subjects and between subject  %
%statistics                                                             %
%                                                                       %
%INPUTS:  fi          Figure handle for single group plots              %
%         fb          Figure handle for diff plots (counts)             %
%         pc          Axis handle for control checkerboard              %
%         ps          Axis handle for stroke checkerboard               %
%         pd          Axis handle for between group checkerboard        %
%         epoch       Epoch of interest                                 %
%         refepoch    Reference epoch                                   %
%         Prefix      label prefixes                                    %
%         groups      group adaptation data (1=control and 2= patient   %
%         mindif      minimal relevant difference (proportion max base) %
%         fdr         false discovery rate                              %
%         smethod     summary method for checkerboards                  %
%                                                                       %
%OUTPUTS: fi          Figure handle for single group plots              %
%         fb          Figure handle for diff plots (counts)             %
%         pc          Axis handle for control checkerboard              %
%         ps          Axis handle for stroke checkerboard               %
%         pd          Axis handle for between group checkerboard        %
%         pvalc       P-values for control checkerboard                 %
%         pvals       P-values for stroke checherboard                  %
%         hc          Statistical test results control                  %
%         hs          Statistical test result stroke                    %
%         hb          Statistical test result between group             %
%         dataEc      Control matrix (epoch-refepoch)                   %
%         dataEs      Stroke matrix (epoch-refepoch)                    %
%         dataBinaryc Binary data control (modulation y/n)              %
%         dataBianrys Binary data stroke (modulation y/n)               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fi,fb,pc,ps,pd,pvalc,pvals,pvalb,hc,hs,hb,dataEc,dataEs,dataBinaryc,dataBinarys]=plotBGcompV2(fi,fb,pc,ps,pd,epoch,refepoch,Prefix,groups,mindif,fdr,smethod)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP 1: Generate Non-parametric plots for controls (assuming that group 1 is the control group)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plotting
[fi,pc,labels,dataEc,dataRefc]=plotCheckerboards(groups{1},Prefix,epoch,fi,pc,refepoch,true,smethod);

%nonparametric stats
dataEcmed=transpose(squeeze(nanmedian(dataEc,4)));%these values are generated to assess if effect sizes are larger than threshold value
%-this matrix is in the same format as the checkerboards (rows are muscles and columns are gait phases
%-note that the first row corresponds to the bottom row of the
% checkerboards given that x-values in plot go from 1:30


[pvalc,hc,alphaAdj_c]=checkerstatsV2(dataEc,[],1,0,fdr,'benhoch',0);%mindif has to be zero, since signrank cannot reliably do a two-tail test agains another value
%-matrices hc and pvalc are in the same format as the checkerboards (see dataEcmed)

get(pc);hold on
for i=1:size(hc,1)
    for k=1:size(hc,2)
        if hc(i,k)==1  && abs(dataEcmed(i,k))>mindif %since statistical testing was done againts zero, amplitude testing happens here
            plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
           
        end
    end
end
title(['Controls ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_c)/1000)]);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP 2: Generate Non-parametric plots for stroke (assuming that group 1 is the control group)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plotting
[fi,ps,labels,dataEs,dataRefs]=plotCheckerboards(groups{2},Prefix,epoch,fi,ps,refepoch,true,smethod);

%nonparametric stats
dataEsmed=transpose(squeeze(nanmedian(dataEs,4)));%these values are generated to assess if effect sizes are larger than threshold value
[pvals,hs,alphaAdj_s]=checkerstatsV2(dataEs,[],1,0,fdr,'benhoch',0);%mindif has to be zero, since signrank cannot reliably do a two-tail test agains another value
get(ps);hold on
for i=1:size(hs,1)
    for k=1:size(hs,2)
        if hs(i,k)==1  && abs(dataEsmed(i,k))>mindif      %since statistical testing was done againts zero, amplitude testing happens here 
            plot3((k-0.5)/12,i-0.5,1,'.','MarkerSize',16,'Color','k')
           
        end
    end
end
title(['Stroke ', cell2mat(epoch.Properties.ObsNames),'-',cell2mat(refepoch.Properties.ObsNames),' p=',num2str(round(1000*alphaAdj_s)/1000)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP 3: Perform between group stats and indicate significances in individual checkerboards%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Identify cells that have singificant difference in controls and patients
dataEcmed2=dataEcmed;
dataEsmed2=dataEsmed;

dataEcmed2(find(dataEcmed2>-mindif & dataEcmed2<mindif))=0;
dataEsmed2(find(dataEsmed2>-mindif & dataEsmed2<mindif))=0;

cSigns=sign(dataEcmed2).*hc;
sSigns=sign(dataEsmed2).*hs;
allsigns=cSigns;%this matrix will have nonzero values if either one or both groups modulated significantly
for i=1:length(cSigns(:))
    if cSigns(i)==0 && sSigns(i)~=0
        allsigns(i)=sSigns(i);
    end
end

%count subjects that have a significant modulation
dataBinaryc=zeros(size(dataEc));
dataBinarys=zeros(size(dataEs));

%controls
for c=1:size(dataEc,4)%Nphases,Nmuscles,Nepochs,Nsubjects
    for p=1:size(dataEc,1)
        for m=1:size(dataEc,2)
            if dataEc(p,m,1,c)*allsigns(m,p)>mindif %now I just count everyone with modulation in same directions with no magnitude threshold
                dataBinaryc(p,m,1,c)=1;
            end
        end
    end    
end
dataBinarycSum=transpose(nansum(dataBinaryc,4));%matrix in the same form as dataEcmed
%stroke
for c=1:size(dataEs,4)%Nphases,Nmuscles,Nepochs,Nsubjects
    for p=1:size(dataEs,1)
        for m=1:size(dataEs,2)
            if dataEs(p,m,1,c)*allsigns(m,p)>mindif
                dataBinarys(p,m,1,c)=1;
            end
        end
    end    
end
dataBinarysSum=transpose(nansum(dataBinarys,4));%matrix in the same form as dataEsmed

groupMedDiff=transpose(squeeze(nanmedian(dataEc,4)-nanmedian(dataEs,4)));


%Perform stats on counts
[pvalb,hb,alphaAdj_b]=checkerCountstatsV2(dataBinaryc,dataBinarys,allsigns,fdr,'benhoch');
%plot3(pc,[0 1],[size(hb,1)/2,size(hb,1)/2],[1 1],'--k','Color',[0.5 0.5 0.5],'LineWidth',2)
%plot3(ps,[0 1],[size(hb,1)/2,size(hb,1)/2],[1 1],'--k','Color',[0.5 0.5 0.5],'LineWidth',2)
for i=1:size(hb,1)
    for k=1:size(hb,2)
        if hb(i,k)==1 %&& abs(groupMedDiff(i,k))>0.1
            plot3(pc,(k-0.7)/12,i-0.5,1,'*','MarkerSize',11,'Color','k')
            plot3(ps,(k-0.7)/12,i-0.5,1,'*','MarkerSize',11,'Color','k')           
        end
    end
end
%keyboard