function [Bdata]=VectorSimBootstrapIndSubs(Cvectors,Svectors)

nIt=size(Cvectors,2);
Bdata=nan(nIt,2);


for it=1:nIt
    
    %select subjects
    dt=1:nIt; %all subjects
    cSingle=it; %ind of control subject that is compared against others
    dt(cSingle)=NaN;
    refC1=dt(~isnan(dt));%all controls except for selected ones
    sSingle=it;%ind of stroke subject that is compared against ALL controls
    
    
    cvec1=median(Cvectors(:,cSingle'),2);%Only selected control
    cvec2=median(Cvectors(:,refC1'),2);%median of all except for selected control
    cvec3=median(Cvectors,2);%median of all controls, included selected (i.e. this is ref for ind stroke)
    svec1=median(Svectors(:,sSingle'),2);%Only selected stroke subject
    
    Bdata(it,1)=cosine(cvec1,cvec2);
    Bdata(it,2)=cosine(svec1,cvec3);
end

