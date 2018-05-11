function [p,h,alphaAdj]=checkerCountstatsV2(data1,data2,refdata,alpha,posthoc)
%function that computes stats on checkerboards
%Input:
%-data1 and 2: data matrices to compare

%-alpha level
%-posthoc test: default is 'benhoch'


inds=(find(refdata~=0));
if nargin<5
    posthoc='benhoch';
end

if ndims(data1)==4
    data1=squeeze(data1);
    data2=squeeze(data2);
end

p=nan(size(data1,2),size(data1,1));
h=zeros(size(data1,2),size(data1,1)); 


%perform actual test
for i=1:size(p,1)
    for k=1:size(p,2)
        [TABLE,CHI2,p(i,k)] = crosstab([squeeze(abs(data1(k,i,:)));squeeze(abs(data2(k,i,:)))],[zeros(size(data1,3),1);ones(size(data1,3),1)]);
        %[TABLE,CHI2,p(i,k)] = crosstab([squeeze(abs(data1(k,i,:)));squeeze(abs(data2(k,i,:)))],[zeros(size(data1,3),1);ones(size(data1,3),1)]);
    end   
end

ptemp=p(inds);


%perform posthoc corrections
if strcmp(posthoc,'none')
    h=zeros(size(p));
    h(find(p<alpha))=1;
    alphaAdj=alpha;
elseif strcmp(posthoc,'benhoch')
    %ptemp=p(:);
    [htemp,alphaAdj,i1] = BenjaminiHochberg(ptemp,alpha);
    h(inds)=htemp;
    %h=reshape(htemp,size(p));    
elseif strcmp(posthoc,'bonferroni')
    h=zeros(size(p));
    alphaAdj=alpha/(length(p(:)));
    h(find(p<alphaAdj))=1;
end
    
    
    
end