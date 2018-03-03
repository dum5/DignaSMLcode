function [p,h,alphaAdj]=checkerCountstats(data1,data2,wsflag,alpha,posthoc)
%function that computes stats on checkerboards
%Input:
%-data1 and 2: data matrices to compare
%-wsflag: 1 for within subjects comparison and 0 for between subjects
% comparison
%-parflag:0 for non-parametric, 1 for parametric
%-alpha level
%-posthoc test: default is 'benhoch'


if nargin<5
    posthoc='benhoch';
end

if ndims(data1)==4
    data1=squeeze(data1);
    data2=squeeze(data2);
end
p=nan(size(data1,2),size(data1,1));
data1=abs(data1);



%perform actual test
for i=1:size(p,1)
    for k=1:size(p,2)
        if wsflag==0%perform between subject stats   
           [TABLE,CHI2,p(i,k)] = crosstab([squeeze(abs(data1(k,i,:)));squeeze(abs(data2(k,i,:)))],[zeros(size(data1,3),1);ones(size(data1,3),1)]); 
        elseif wsflag==1%perform one sided binomial test that the proportion of subjects with increase > 50% 
            pout=myBinomTest(sum(data1(k,i,:)),size(data1,3),0.5,'one');
            if sum(data1(k,i,:))/size(data1,3)>0.5
                p(i,k)=pout;
            else p(i,k)=1-pout;
            end
        end
    end      
        
end



%perform posthoc corrections
if strcmp(posthoc,'none')
    h=zeros(size(p));
    h(find(p<alpha))=1;
    alphaAdj=alpha;
elseif strcmp(posthoc,'benhoch')
    ptemp=p(:);
    [htemp,alphaAdj,i1] = BenjaminiHochberg(ptemp,alpha);
    h=reshape(htemp,size(p));    
elseif strcmp(posthoc,'bonferroni')
    h=zeros(size(p));
    alphaAdj=alpha/(length(p(:)));
    h(find(p<alphaAdj))=1;
end
    
    
    
end