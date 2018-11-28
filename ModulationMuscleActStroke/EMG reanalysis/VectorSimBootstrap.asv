function [Bdata]=VectorSimBootstrap(Cvectors,Svectors,nIt)

Bdata=nan(nIt,2);

s2=size(Cvectors,2);
s1=s2/2;

for it=1:nIt
    %Select subjects
    %Step 1: divide group in 2
    dt=1:s2;
    cSelect1=datasample(dt,s1,'Replace',false);
    dt(cSelect1)=NaN;
    cSelect2=dt(~isnan(dt));
    dt=1:s2;
    sSelect1=datasample(dt,s1,'Replace',false);
    
    %Step 2: draw distince subjects per group
    cSub1=datasample(cSelect1,s2,'Replace',true);
    cSub2=datasample(cSelect2,s2,'Replace',true);
    sSub1=datasample(sSelect1,s2,'Replace',true);
    
    cvec1=median(Cvectors(:,cSub1'),2);
    cvec2=median(Cvectors(:,cSub2'),2);
    svec1=median(Svectors(:,sSub1'),2);
    
    Bdata(it,1)=cosine(cvec1,cvec2);
    Bdata(it,2)=cosine(svec1,cvec2);
end