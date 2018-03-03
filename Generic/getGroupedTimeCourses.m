function [timeCourse]=getGroupedTimeCourses(this,conds,params);

%TO do: - options for alignment, now everything is aligned to the start
%       - removeBias option


%%Allow for input of both struct and cell
if isstruct(this)
    groupsnames=fieldnames(this);
    dt=this;clear this
    for i=1:length(groupsnames)
         this{i}=eval(['dt.',groupsnames{i}]);
    end
end


for group=1:length(this)
    M=2000;%assume that 2000 is max number of datapoints
    for par=1:length(params)
        for cond=1:length(conds)
            timeCourse{group}.param{par}.cond{cond}=NaN(M,length(this{group}.adaptData));
            %nPoints=1;
            for sj=1:length(this{group}.adaptData)
                dt=this{group}.adaptData{sj}.getParamInCond(params(par),conds(cond));
%                 pt=length(dt);
%                 if pt>nPoints
%                     nPoints=pt;
%                 end
                timeCourse{group}.param{par}.cond{cond}(1:length(dt),sj)=dt;
                clear dt                
            end
            
        end
        
    end
end
