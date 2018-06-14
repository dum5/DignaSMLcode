%Array to run simulation on Digna's data
clear all
clc
load('GeneralizationYoung.mat')

GroupsToRemove={'AbruptFeedback'};
studyData = rmfield(studyData,GroupsToRemove) ;
names=fieldnames(studyData);

params={'velocityContributionNorm2','netContributionNorm2'};


wSize = 5;
values=struct([]);
numPts=struct([]);
M=2000;

for group=1:length(names)
    
    for sub=1:10
        
        adaptData=studyData.(names{group}).adaptData{sub};
        cond=adaptData.metaData.conditionName;
        adaptData=adaptData.removeBadStrides;
        adaptData = adaptData.removeBias;
        adaptData=adaptData.medianFilter(5);
        
        for p=1:length(params)
            
            conditions=cond;
            
            for c=1:length(cond)
                if isa(conditions{c},'cell')
                    conds{c}=conditions{c}{1}(ismember(conditions{c}{1},['A':'Z' 'a':'z' '0':'9']));
                elseif isa(conditions{c},'char')
                    conds{c}=conditions{c}(ismember(conditions{c},['A':'Z' 'a':'z' '0':'9'])); %remove non alphanumeric characters
                else
                    %Modified by AS 07/24/2017
                    conds{c}=nan;
                    warning('Conditions argument is neither a string, a cell array of strings or a cell array of cell array of strings.')
                end
            end
            for c=1:length(cond)
                if group < 4
                    
                    dataPts= adaptData.getParamInCond(params{p},cond(c));
                    %Running Avg
                    firstSamples = dataPts(1:wSize-1);
                    dataPts = tsmovavg(dataPts,'s',wSize,1);
                    dataPts(1:wSize-1) = firstSamples;
                    
                    if strcmp(names(group),'Gradual') && strcmp(conds(c),'gradualadaptation')||  strcmp(names(group),'AbruptNoFeedback') && strcmp(conds(c),'gradualadaptation') || strcmp(names(group),'catch') && strcmp(conds(c),'gradualadaptation')
                        
                        nPoints=size(dataPts(150:end),1);
                        values(group).(params{p}).(conds{c})(sub,:)=NaN(1,M);
                        values(group).(params{p}).(conds{c})(sub,1:nPoints)=dataPts(150:end)';
                        numPts(group).(conds{c})(sub)=nPoints;
                        
                    else
                        
                        
                        nPoints=size(dataPts,1);
                        values(group).(params{p}).(conds{c})(sub,:)=NaN(1,M);
                        values(group).(params{p}).(conds{c})(sub,1:nPoints)=dataPts;
                        numPts(group).(conds{c})(sub)=nPoints;
                    end
                    %       avg(group).(params{p}).(cond{c})=nanmean();
                    
                else
                    
                    if strcmp(conds(c),'gradualadaptation')
                        trial=adaptData.getTrialsInCond(cond(c));
                        ca=adaptData.getTrialsInCond('catch');
                        for t=1:length(trial);
                            if trial(t)<ca
                                dataPts=adaptData.getParamInTrial(params{p},trial(t));
                                
                                %Running Avg
                                firstSamples = dataPts(1:wSize-1);
                                dataPts = tsmovavg(dataPts,'s',wSize,1);
                                dataPts(1:wSize-1) = firstSamples;
                                
                                nPoints=size(dataPts(150:end),1);
                                values(group).(params{p}).(conds{c})(sub,:)=NaN(1,M);
                                values(group).(params{p}).(conds{c})(sub,1:nPoints)=dataPts(150:end);
                                numPts(group).(conds{c})(sub)=nPoints;
                            else
                                
                                afterCatch=adaptData.getParamInTrial(params{p},trial(t));   
                            end
                        end
                    else
                        dataPts= adaptData.getParamInCond(params{p},cond(c));
                        
                        %Running Avg
                        firstSamples = dataPts(1:wSize-1);
                        dataPts = tsmovavg(dataPts,'s',wSize,1);
                        dataPts(1:wSize-1) = firstSamples;
                        
                        nPoints=size(dataPts,1);
                        values(group).(params{p}).(conds{c})(sub,:)=NaN(1,M);
                        values(group).(params{p}).(conds{c})(sub,1:nPoints)=dataPts;
                        numPts(group).(conds{c})(sub)=nPoints;
                        if strcmp(conds(c),'catch')
                            values(group).(params{p}).Adaptation12(sub,:)=NaN(1,M);
                            nPoints=size(afterCatch,1);
                            values(group).(params{p}).Adaptation12(sub,1:nPoints)=afterCatch;
                            numPts(group).Adaptation12(sub)=nPoints;
                            
                        end
                        
                    end
                    
                end
                
                
            end
            
        end
    end
end

for group=1:length(names)
    for p=1:length(params)
        conds=fieldnames(values(group).(params{p}));
        for c=1:length(conds)
            avg(group).(params{p}).(conds{c})=nanmean(values(group).(params{p}).(conds{c}),1);
        end
        GroupsData.(params{p})=nan(4,4000);
    end
end

for group=1:length(names)
    for p=1:length(params)
        Group=[];
        
        conds=fieldnames(avg(group).(params{p}));
        
        
        for c=1:size(fieldnames(avg(group).(params{p})),1)
            numStrides=[numPts(1).(conds{c}) numPts(2).(conds{c}) numPts(3).(conds{c}) numPts(4).(conds{c})];
            [maxPts,loc]=nanmax(numStrides);maxPts=maxPts+11;
            
            avg(group).(params{p}).(conds{c})=avg(group).(params{p}).(conds{c})(1:maxPts);
            zz=avg(group).(params{p}).(conds{c})(1:maxPts);
            Group=[Group zz];
        end
        
        GroupsData.(params{p})(group,1:length(Group))=Group;
        
    end
end

GroupsData.AdaptExt=GroupsData.netContributionNorm2-GroupsData.velocityContributionNorm2;




