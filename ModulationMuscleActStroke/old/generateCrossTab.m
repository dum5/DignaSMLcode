function [dataBinary,dataCount,ATS]=generateCrossTab(this,epoch,refepoch,Prefix,mindif,signmatrix,fdr)
%keyboard

%get data from each individual subject and test if the effect is >0.05 and
%in the same direction as the average control subjects

%get labels from prefix
Prefix=reshape(Prefix,1,numel(Prefix)); %Putting in row form
aux=this.adaptData{1}.data.getLabelsThatMatch(['^' Prefix{1} '[ ]?\d+$']); %Assuming same suffix for all
if isempty(aux)
    error('Fail: did not find any parameters with the given prefixes')
    return
end
Np=length(aux);
suffixes=cellfun(@(x) x(length(Prefix{1})+1:end),aux,'UniformOutput',false); %Extracting suffixes, I am lazy
labels=strcat(repmat(Prefix,Np,1),repmat(suffixes,1,length(Prefix))); %To do
labels2=labels(:);
labels3=reshape(labels2,size(labels,1),size(labels,2));

refstrideNo=refepoch.Stride_No;
epstrideNo=epoch.Stride_No;
if  refepoch.EarlyOrLate==0
    refstrideNo=-1*refstrideNo;
end
if  epoch.EarlyOrLate==0
    epstrideNo=-1*epstrideNo;
end

%get grouped data based on labels
refData=getGroupedData(this,labels2,refepoch.Condition,0,refstrideNo,refepoch.ExemptFirst,refepoch.ExemptLast,true);
epData=getGroupedData(this,labels2,epoch.Condition,0,epstrideNo,epoch.ExemptFirst,epoch.ExemptLast,true);
dt=nanmedian(epData{1},2)-nanmedian(refData{1},2); 

 % generate matrix for each subject that indicates significance
 signrow=signmatrix(:);
 allh=nan(360,15);
 for sj=1:size(refData{1},4)
     pt=NaN(360,1);
     ht=NaN(360,1);
     
     for l=1:size(refData{1},3)
         %ranksum test with manually adding or subtracting mindif to test
         %agains minimum difference
         if signrow(l)==1%was ranksum
            [pt(l),ht(l)]=ranksum(epData{1}(1,:,l,sj)-mindif,refData{1}(1,:,l,sj),'tail','right'); 
         elseif signrow(l)==-1
              [pt(l),ht(l)]=ranksum(refData{1}(1,:,l,sj)-mindif,epData{1}(1,:,l,sj),'tail','right');     
            
         end
       
         
         
         
     end
    %keyboard
    [h,alphaAdj,i1] = BenjaminiHochberg(pt,fdr);
    h=h.*signrow;
    allh(:,sj)=h;
    h=reshape(h,size(labels,1),size(labels,2));
    dtsj=dt(1,1,:,sj);
    dataBinary(:,:,1,sj)=h;
    dataE(:,:,1,sj)=reshape(dtsj,size(labels,1),size(labels,2));
 end
eval(['fun=@(x) ' 'nansum' '(x,4);']);
dataCount=fun(dataBinary);


%old code before we did the stats
% [dataEc,labels]=this.getPrefixedEpochData(Prefix,epoch,true); %Padding with NaNs
% Np=size(labels,1);
% dataEc=reshape(dataEc,Np,length(Prefix),size(dataEc,2),size(dataEc,3));
% [dataRefc]=this.getPrefixedEpochData(Prefix,refepoch, true); %Padding with NaNs
% dataRefc=reshape(dataRefc,Np,length(Prefix),1,size(dataRefc,3));
% dataEc=dataEc-dataRefc;
% 
% signmatrix=reshape(signmatrix,Np,length(Prefix),1,1);
% dataEc=dataEc.*signmatrix;
% 
% 
% 
% dataBinary=zeros(size(dataEc));
% dataBinary(find(dataEc>mindif))=1;
% %dataBinary(find(dataEc<-mindif))=1;
% 
% eval(['fun=@(x) ' 'nansum' '(x,4);']);
% dataCount=fun(dataBinary);
% 
% 
% dataCount=dataCount.*signmatrix
% 

evLabel={'sHS','','fTO','','','','fHS','','sTO','','',''};

ATS=alignedTimeSeries(0,1/numel(evLabel),dataCount(:,:,1),Prefix,ones(1,Np),evLabel);
[ATS,iC]=ATS.flipLR;
dataCount(:,iC,:,:)=fftshift(dataCount(:,iC,:,:),1);
dataBinary(:,iC,:,:)=fftshift(dataBinary(:,iC,:,:),1);