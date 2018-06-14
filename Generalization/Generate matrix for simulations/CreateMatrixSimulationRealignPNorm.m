%Array to run simulation on Digna's data
clear all
clc
load('GeneralizationYoungRecomputedPNorm.mat')

GroupsToRemove={'AbruptFeedback'};
studyData = rmfield(studyData,GroupsToRemove) ;
names=fieldnames(studyData);
wSize=5;

params={'velocityContributionPNorm','netContributionPNorm'};

commonConditions={'OG base','TM slow','TM fast','TM base','OG post','readaptation','TM post'};
maxn=[300 105 105 155 300 305 605];
for g=1:length(names)
    studyData.(names{g})=studyData.(names{g}).removeBadStrides.removeBias.medianFilter(5);
end

%for all conditions except adaptation
for c=1:length(commonConditions)
    max2=1;
    for g=1:length(names)
        %create ss matrix
        allData{g}{c}.net= squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm',commonConditions{c},0,maxn(c),0,10,1)));
        allData{g}{c}.vel= squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm',commonConditions{c},0,maxn(c),0,10,1)));
        
        %Running Avg
        for sj=1:size(allData{g}{c}.net,2)
            dt=allData{g}{c}.net(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.net(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{c}.vel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.vel(:,sj)=dt;clear dt firstSamples
        end
        
        %create group avg
        
        meanData{g}{c}.net=nanmean(allData{g}{c}.net,2);
        meanData{g}{c}.vel=nanmean(allData{g}{c}.vel,2);
        dt=find(~isnan(meanData{g}{c}.net),1,'last');
        if dt>max2
            max2=dt;
        end
    end
    for g=1:length(names)
        meanData{g}{c}.net= [meanData{g}{c}.net(1:max2);NaN];
        meanData{g}{c}.vel= [meanData{g}{c}.vel(1:max2);NaN];
    end
end

%adaptation and catch
max2=1;
for g=1:length(names)
     allData{g}{8}.net=NaN(1200,10); allData{g}{8}.vel=NaN(1200,10);
    if g==4;%his is the catch group
        nbeforecatch=1;naftercatch=1;
        for sj=1:10
            %get adaptation conditions
            Adapt=studyData.Catch.adaptData{sj}.getTrialsInCond('gradual adaptation');
            Catch=studyData.Catch.adaptData{sj}.getTrialsInCond('Catch');
            netBeforeCatch{sj}=[];netAfterCatch{sj}=[]; velBeforeCatch{sj}=[];velAfterCatch{sj}=[];
            for tr=Adapt
                if tr<Catch
                    netBeforeCatch{sj}=[netBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('netContributionPNorm',tr)];
                    velBeforeCatch{sj}=[velBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('velocityContributionPNorm',tr)];
                    
                    
                else
                    netAfterCatch{sj}=[netAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('netContributionPNorm',tr)];
                    velAfterCatch{sj}=[velAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('velocityContributionPNorm',tr)];
                    
                    
                end
                %remove last 10
                netBeforeCatch{sj}= netBeforeCatch{sj}(1:end-10);
                velBeforeCatch{sj}= velBeforeCatch{sj}(1:end-10);
                %remove last 10
                netAfterCatch{sj}= netAfterCatch{sj}(1:end-10);
                velAfterCatch{sj}= velAfterCatch{sj}(1:end-10);
            end
            
            if length(netBeforeCatch)>nbeforecatch
                nbeforecatch=length(netBeforeCatch);
            end
            if length(netAfterCatch)>naftercatch
                naftercatch=length(netAfterCatch);
            end
            %moving avg
            dt=netBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; netBeforeCatch{sj}=dt;clear dt firstSamples
            dt=velBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; velBeforeCatch{sj}=dt;clear dt firstSamples
            dt=netAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; netAfterCatch{sj}=dt;clear dt firstSamples
            dt=velAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; velAfterCatch{sj}=dt;clear dt firstSamples
            
        end
        %create matrices with before and after catch data
        nbeforecatch=nbeforecatch-150;
        BeforeCatchDataNet=NaN(nbeforecatch,10); AfterCatchDataNet=NaN(naftercatch,10);BeforeCatchDataVel=NaN(nbeforecatch,10); AfterCatchDataVel=NaN(naftercatch,10);
        for sj=1:10
            n=length(netBeforeCatch{sj})-150;
            BeforeCatchDataNet(1:n,sj)= netBeforeCatch{sj}(151:end,:);
            BeforeCatchDataVel(1:n,sj)= velBeforeCatch{sj}(151:end,:);
            n=length(netAfterCatch{sj});
            AfterCatchDataNet(1:n,sj)= netAfterCatch{sj}(1:end,:);
            AfterCatchDataVel(1:n,sj)= velAfterCatch{sj}(1:end,:);
        end
        %get catch data
        CatchDataNet=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm','Catch',0,10,0,0,1)))];
        CatchDataVel=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm','Catch',0,10,0,0,1)))];
        %Running Avg
%         for sj=1:10
%             dt=CatchDataNet(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;CatchDataNet(:,sj)=dt;clear dt firstSamples
%             dt=CatchDataVel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;CatchDataNet(:,sj)=dt;clear dt firstSamples
%         end
        CatchDataNet=[NaN(1,10);CatchDataNet;NaN(1,10)];
        CatchDataVel=[NaN(1,10);CatchDataVel;NaN(1,10)];
        
        
        allData{g}{8}.net=[BeforeCatchDataNet;CatchDataNet;AfterCatchDataNet;NaN(100,10)];
        allData{g}{8}.vel=[BeforeCatchDataVel;CatchDataVel;AfterCatchDataVel;NaN(100,10)];
        
        %group avg
        meanData{g}{8}.net=nanmean(allData{g}{8}.net,2);
        meanData{g}{8}.vel=nanmean(allData{g}{8}.vel,2);
        dt=find(~isnan(meanData{g}{8}.net),1,'last');
        if dt>max2
            max2=dt;
        end
        
    else
        allData{g}{8}.net= squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm','gradual adaptation',0,1200,0,10,1)));
        allData{g}{8}.vel= squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm','gradual adaptation',0,1200,0,10,1)));
        if g==2
        else
            allData{g}{8}.net=allData{g}{8}.net(151:end,:);
            allData{g}{8}.vel=allData{g}{8}.vel(151:end,:);
        end
        %Running Avg
        for sj=1:size(allData{g}{8}.net,2)
            dt=allData{g}{8}.net(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.net(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{8}.vel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.vel(:,sj)=dt;clear dt firstSamples
        end
        meanData{g}{8}.net=nanmean(allData{g}{8}.net,2);
        meanData{g}{8}.vel=nanmean(allData{g}{8}.vel,2);
        dt=find(~isnan(meanData{g}{8}.net),1,'last');
        if dt>max2
            max2=dt;
        end
        
    end
    
    
    
end
for g=1:length(names)
    meanData{g}{8}.net= [meanData{g}{8}.net(1:max2);NaN];
    meanData{g}{8}.vel= [meanData{g}{8}.vel(1:max2);NaN];
end

%concatinate
condorder=[1 2 3 4 8 5 6 7];
for g=1:length(names)
    allVectors.net(:,g)=[meanData{g}{1}.net;meanData{g}{2}.net;meanData{g}{3}.net;meanData{g}{4}.net;meanData{g}{8}.net;meanData{g}{5}.net;meanData{g}{6}.net;meanData{g}{7}.net];
    allVectors.vel(:,g)=[meanData{g}{1}.vel;meanData{g}{2}.vel;meanData{g}{3}.vel;meanData{g}{4}.vel;meanData{g}{8}.vel;meanData{g}{5}.vel;meanData{g}{6}.vel;meanData{g}{7}.vel];
end

startramp=length(meanData{g}{1}.net)+length(meanData{g}{2}.net)+length(meanData{g}{3}.net)+length(meanData{g}{4}.net)+1;
finalSteadyState=length(meanData{g}{1}.net)+length(meanData{g}{2}.net)+length(meanData{g}{3}.net)+length(meanData{g}{4}.net)+length(meanData{g}{8}.net);
vectorGradual=linspace(0,1,600);
vectorShortRamp=linspace(0,1,40);
%computeAdaptIndex 
%first shift data
%create vector with conditions that need to be shifted
cond=[zeros(length(meanData{1}{1}.net),1);zeros(length(meanData{1}{2}.net),1);zeros(length(meanData{1}{3}.net),1);zeros(length(meanData{1}{4}.net),1);ones(length(meanData{1}{8}.net),1);zeros(length(meanData{1}{5}.net),1);ones(length(meanData{1}{6}.net),1);zeros(length(meanData{1}{7}.net),1)];
cond=repmat(cond,1,4);
%indices for catch need to be identified manually
CatchInd=1148:1157;
cond(CatchInd,4)=0;
cond(startramp:startramp+599,1)=vectorGradual;
cond(startramp:startramp+39,3)=vectorShortRamp;
cond(startramp:startramp+39,4)=vectorShortRamp;

allVectors.net=-1*allVectors.net;
allVectors.vel=-1*allVectors.vel;


MinVal=min(min(allVectors.net));
MinVals=cond.*MinVal;
allVectors.netShifted=allVectors.net-MinVals;
tempmax=nanmedian(allVectors.netShifted(finalSteadyState-9:finalSteadyState,:));
MaxVal=max(tempmax);

%MaxVal=max(max(allVectors.netShifted));
allVectors.AdaptIndex=allVectors.netShifted./MaxVal;

allVectors.AdaptExtent=allVectors.net-allVectors.vel;

allVectors.cond=cond;



