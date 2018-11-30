function [Bdata]=VectorSimBootstrapIndSubs(Cvectors,Svectors)

nIt=size(Cvectors,2);
Bdata=nan(nIt,2);


for it=1:nIt
    %Select subjects
    %Step 1: divide group in 2
    dt=1:nIt;
    cSingle=it;
    dt(cSingle)=NaN;
    refC1=dt(~isnan(dt));
    sSingle=it;
    
    
    cvec1=median(Cvectors(:,cSingle'),2);
    cvec2=median(Cvectors(:,refC1'),2);
    cvec3=median(Cvectors,2);
    svec1=median(Svectors(:,sSingle'),2);
    
    Bdata(it,1)=cosine(cvec1,cvec2);
    Bdata(it,2)=cosine(svec1,cvec3);
end