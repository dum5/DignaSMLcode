%Array to run simulation on Digna's data
% clear all
% clc
% load('GeneralizationYoungRecomputedPNorm.mat')

GroupsToRemove={'AbruptFeedback'};
studyData = rmfield(studyData,GroupsToRemove) ;
names=fieldnames(studyData);
wSize=5;

params={'velocityContributionPNorm2','netContributionPNorm2','spatialContributionPNorm2','stepTimeContributionPNorm2'};

commonConditions={'OG base','TM slow','TM fast','TM base','OG post','readaptation','TM post'};
maxn=[300 105 105 155 300 305 605];
for g=1:length(names)
    studyData.(names{g})=studyData.(names{g}).removeBadStrides.removeBias.medianFilter(5);
end

%for all conditions except adaptation
for c=1:length(commonConditions)
    minsj=maxn(c);
    for g=1:length(names)
        %create ss matrix
        allData{g}{c}.net= squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm2',commonConditions{c},0,maxn(c),0,10,1)));
        allData{g}{c}.vel= squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm2',commonConditions{c},0,maxn(c),0,10,1)));
        allData{g}{c}.sp= squeeze(cell2mat(studyData.(names{g}).getGroupedData('spatialContributionPNorm2',commonConditions{c},0,maxn(c),0,10,1)));
        allData{g}{c}.st= squeeze(cell2mat(studyData.(names{g}).getGroupedData('stepTimeContributionPNorm2',commonConditions{c},0,maxn(c),0,10,1)));
       
       
        %Running Avg
        for sj=1:size(allData{g}{c}.net,2)
            if find(~isnan(allData{g}{c}.net(:,sj)),1,'last')<minsj
                minsj=find(~isnan(allData{g}{c}.net(:,sj)),1,'last');
            end

            dt=allData{g}{c}.net(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.net(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{c}.vel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.vel(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{c}.sp(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.sp(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{c}.st(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{c}.st(:,sj)=dt;clear dt firstSamples
        end
        
        %create group avg
        
        meanData{g}{c}.net=nanmean(allData{g}{c}.net,2);
        meanData{g}{c}.vel=nanmean(allData{g}{c}.vel,2);
        meanData{g}{c}.sp=nanmean(allData{g}{c}.sp,2);
        meanData{g}{c}.st=nanmean(allData{g}{c}.st,2);
       
    end
    for g=1:length(names)
        meanData{g}{c}.net= meanData{g}{c}.net(1:minsj);
        meanData{g}{c}.vel= meanData{g}{c}.vel(1:minsj);
        meanData{g}{c}.sp= meanData{g}{c}.sp(1:minsj);
        meanData{g}{c}.st= meanData{g}{c}.st(1:minsj);
        if strcmp(commonConditions{c},'readaptation')
            meanData{g}{c}.pert=ones(minsj,1);
        else
            meanData{g}{c}.pert=zeros(minsj,1);
        end
        
    end
end

%adaptation and catch
 minsj=900;
for g=1:length(names)
     allData{g}{8}.net=NaN(1200,10); 
     allData{g}{8}.vel=NaN(1200,10);
     allData{g}{8}.sp=NaN(1200,10); 
     allData{g}{8}.st=NaN(1200,10);
    if g==4;%his is the catch group
        nbeforecatch=760;naftercatch=310;
        for sj=1:10
            %get adaptation conditions
            Adapt=studyData.Catch.adaptData{sj}.getTrialsInCond('gradual adaptation');
            Catch=studyData.Catch.adaptData{sj}.getTrialsInCond('Catch');
            netBeforeCatch{sj}=[];netAfterCatch{sj}=[]; velBeforeCatch{sj}=[];velAfterCatch{sj}=[]; 
            spBeforeCatch{sj}=[];spAfterCatch{sj}=[]; stBeforeCatch{sj}=[];stAfterCatch{sj}=[];
            for tr=Adapt
                if tr<Catch
                    netBeforeCatch{sj}=[netBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('netContributionPNorm2',tr)];
                    velBeforeCatch{sj}=[velBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('velocityContributionPNorm2',tr)];
                    spBeforeCatch{sj}=[spBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('spatialContributionPNorm2',tr)];
                    stBeforeCatch{sj}=[stBeforeCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('stepTimeContributionPNorm2',tr)];
                    
                else
                    netAfterCatch{sj}=[netAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('netContributionPNorm2',tr)];
                    velAfterCatch{sj}=[velAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('velocityContributionPNorm2',tr)];
                    spAfterCatch{sj}=[spAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('spatialContributionPNorm2',tr)];
                    stAfterCatch{sj}=[stAfterCatch{sj};studyData.Catch.adaptData{sj}.getParamInTrial('stepTimeContributionPNorm2',tr)];
                    
                end
            end
                
                if length(netBeforeCatch{sj})<nbeforecatch
                    nbeforecatch=length(netBeforeCatch{sj});
                end
                if length(netAfterCatch{sj})<naftercatch
                    naftercatch=length(netAfterCatch{sj});
                end
                
%                 %remove last 10
%                 netBeforeCatch{sj}= netBeforeCatch{sj}(1:end-10);
%                 velBeforeCatch{sj}= velBeforeCatch{sj}(1:end-10);
%                 %remove last 10
%                 netAfterCatch{sj}= netAfterCatch{sj}(1:end-10);
%                 velAfterCatch{sj}= velAfterCatch{sj}(1:end-10);
         
            
%             if length(netBeforeCatch)>nbeforecatch
%                 nbeforecatch=length(netBeforeCatch);
%             end
%             if length(netAfterCatch)>naftercatch
%                 naftercatch=length(netAfterCatch);
%             end
            %moving avg
            dt=netBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; netBeforeCatch{sj}=dt;clear dt firstSamples
            dt=velBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; velBeforeCatch{sj}=dt;clear dt firstSamples
            dt=spBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; spBeforeCatch{sj}=dt;clear dt firstSamples
            dt=stBeforeCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; stBeforeCatch{sj}=dt;clear dt firstSamples
            
            dt=netAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; netAfterCatch{sj}=dt;clear dt firstSamples
            dt=velAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; velAfterCatch{sj}=dt;clear dt firstSamples
            dt=spAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; spAfterCatch{sj}=dt;clear dt firstSamples
            dt=stAfterCatch{sj}; firstSamples = dt(1:wSize-1); dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples; stAfterCatch{sj}=dt;clear dt firstSamples
            
        end
        %create matrices with before and after catch data
        nbeforecatch=nbeforecatch-150;
        BeforeCatchDataNet=NaN(nbeforecatch,10); AfterCatchDataNet=NaN(naftercatch,10);
        BeforeCatchDataVel=NaN(nbeforecatch,10); AfterCatchDataVel=NaN(naftercatch,10);
        BeforeCatchDataSp=NaN(nbeforecatch,10); AfterCatchDataSp=NaN(naftercatch,10);
        BeforeCatchDataSt=NaN(nbeforecatch,10); AfterCatchDataSt=NaN(naftercatch,10);
        
        for sj=1:10
           % n=length(netBeforeCatch{sj})-150;
            BeforeCatchDataNet(:,sj)= netBeforeCatch{sj}(151:nbeforecatch+150,:);
            BeforeCatchDataVel(:,sj)= velBeforeCatch{sj}(151:nbeforecatch+150,:);
            BeforeCatchDataSp(:,sj)= spBeforeCatch{sj}(151:nbeforecatch+150,:);
            BeforeCatchDataSt(:,sj)= stBeforeCatch{sj}(151:nbeforecatch+150,:);
            %n=length(netAfterCatch{sj});
            AfterCatchDataNet(:,sj)= netAfterCatch{sj}(1:naftercatch,:);
            AfterCatchDataVel(:,sj)= velAfterCatch{sj}(1:naftercatch,:);
            AfterCatchDataSp(:,sj)= spAfterCatch{sj}(1:naftercatch,:);
            AfterCatchDataSt(:,sj)= stAfterCatch{sj}(1:naftercatch,:);
        end
        %get catch data
        CatchDataNet=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm2','Catch',0,12,0,0,1)))];
        CatchDataVel=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm2','Catch',0,12,0,0,1)))];
        CatchDataSp=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('spatialContributionPNorm2','Catch',0,12,0,0,1)))];
        CatchDataSt=[squeeze(cell2mat(studyData.(names{g}).getGroupedData('stepTimeContributionPNorm2','Catch',0,12,0,0,1)))];
        
        mincatch=10;
        for sj=1:10
            if find(~isnan(CatchDataNet(:,sj)),1,'last')<mincatch
               mincatch=find(~isnan(CatchDataNet(:,sj)),1,'last');
            end            
        end
        %Running Avg
%         for sj=1:10
%             dt=CatchDataNet(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;CatchDataNet(:,sj)=dt;clear dt firstSamples
%             dt=CatchDataVel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;CatchDataNet(:,sj)=dt;clear dt firstSamples
%         end
        CatchDataNet=CatchDataNet(1:mincatch,:);
        CatchDataVel=CatchDataVel(1:mincatch,:);
        CatchDataSp=CatchDataSp(1:mincatch,:);
        CatchDataSt=CatchDataSt(1:mincatch,:);
       
          
        allData{g}{8}.net=[BeforeCatchDataNet;CatchDataNet;AfterCatchDataNet];
        allData{g}{8}.vel=[BeforeCatchDataVel;CatchDataVel;AfterCatchDataVel];
        allData{g}{8}.sp=[BeforeCatchDataSp;CatchDataSp;AfterCatchDataSp];
        allData{g}{8}.st=[BeforeCatchDataSt;CatchDataSt;AfterCatchDataSt];
        
        
        %group avg
        meanData{g}{8}.net=nanmean(allData{g}{8}.net,2);
        meanData{g}{8}.vel=nanmean(allData{g}{8}.vel,2);
        meanData{g}{8}.sp=nanmean(allData{g}{8}.sp,2);
        meanData{g}{8}.st=nanmean(allData{g}{8}.st,2);
        meanData{g}{8}.pert=[linspace(0,1,40)';ones(nbeforecatch-40,1);zeros(mincatch,1);ones(naftercatch,1)];
        
        
        if length(meanData{g}{8}.net)<minsj
           minsj=length(meanData{g}{8}.net);
        end
        
    else
        allData{g}{8}.net= squeeze(cell2mat(studyData.(names{g}).getGroupedData('netContributionPNorm2','gradual adaptation',0,1200,0,10,1)));
        allData{g}{8}.vel= squeeze(cell2mat(studyData.(names{g}).getGroupedData('velocityContributionPNorm2','gradual adaptation',0,1200,0,10,1)));
        allData{g}{8}.sp= squeeze(cell2mat(studyData.(names{g}).getGroupedData('spatialContributionPNorm2','gradual adaptation',0,1200,0,10,1)));
        allData{g}{8}.st= squeeze(cell2mat(studyData.(names{g}).getGroupedData('stepTimeContributionPNorm2','gradual adaptation',0,1200,0,10,1)));
        if g==2 %fullabrupt
        else
            allData{g}{8}.net=allData{g}{8}.net(151:end,:);
            allData{g}{8}.vel=allData{g}{8}.vel(151:end,:);
            allData{g}{8}.sp=allData{g}{8}.sp(151:end,:);
            allData{g}{8}.st=allData{g}{8}.st(151:end,:);
        end
        %Running Avg
        for sj=1:size(allData{g}{8}.net,2)
            
             if find(~isnan(allData{g}{8}.net(:,sj)),1,'last')<minsj
                minsj=find(~isnan(allData{g}{8}.net(:,sj)),1,'last');
            end
            
            dt=allData{g}{8}.net(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.net(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{8}.vel(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.vel(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{8}.sp(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.sp(:,sj)=dt;clear dt firstSamples
            dt=allData{g}{8}.st(:,sj);firstSamples = dt(1:wSize-1);dt = tsmovavg(dt,'s',wSize,1);dt(1:wSize-1) = firstSamples;allData{g}{8}.st(:,sj)=dt;clear dt firstSamples
        end
        meanData{g}{8}.net=nanmean(allData{g}{8}.net,2);
        meanData{g}{8}.vel=nanmean(allData{g}{8}.vel,2);
        meanData{g}{8}.sp=nanmean(allData{g}{8}.sp,2);
        meanData{g}{8}.st=nanmean(allData{g}{8}.st,2);
        if strcmp(names{g},'Gradual')
            meanData{g}{8}.pert=[linspace(0,1,600)';ones(length(meanData{g}{8}.net)-600,1)];
        elseif strcmp(names{g},'FullAbrupt')
            meanData{g}{8}.pert=ones(length(meanData{g}{8}.net),1);
        elseif strcmp(names{g},'AbruptNoFeedback')
            meanData{g}{8}.pert=[linspace(0,1,40)';ones(length(meanData{g}{8}.net)-40,1)];
        end
%         dt=find(~isnan(meanData{g}{8}.net),1,'last');
%         if dt>max2
%             max2=dt;
%         end
        
    end
    
    
    
end
for g=1:length(names)
    meanData{g}{8}.net= meanData{g}{8}.net(1:minsj);
    meanData{g}{8}.vel= meanData{g}{8}.vel(1:minsj);
    meanData{g}{8}.sp= meanData{g}{8}.sp(1:minsj);
    meanData{g}{8}.st= meanData{g}{8}.st(1:minsj);
    meanData{g}{8}.pert= meanData{g}{8}.pert(1:minsj);
end

%concatinate
condorder=[1 2 3 4 8 5 6 7];
for g=1:length(names)
    allVectors.net(:,g)=-1*[meanData{g}{1}.net;meanData{g}{2}.net;meanData{g}{3}.net;meanData{g}{4}.net;meanData{g}{8}.net;meanData{g}{5}.net;meanData{g}{6}.net;meanData{g}{7}.net];
    allVectors.vel(:,g)=-1*[meanData{g}{1}.vel;meanData{g}{2}.vel;meanData{g}{3}.vel;meanData{g}{4}.vel;meanData{g}{8}.vel;meanData{g}{5}.vel;meanData{g}{6}.vel;meanData{g}{7}.vel];
    allVectors.sp(:,g)=-1*[meanData{g}{1}.sp;meanData{g}{2}.sp;meanData{g}{3}.sp;meanData{g}{4}.sp;meanData{g}{8}.sp;meanData{g}{5}.sp;meanData{g}{6}.sp;meanData{g}{7}.sp];
    allVectors.st(:,g)=-1*[meanData{g}{1}.st;meanData{g}{2}.st;meanData{g}{3}.st;meanData{g}{4}.st;meanData{g}{8}.st;meanData{g}{5}.st;meanData{g}{6}.st;meanData{g}{7}.st];
    allVectors.pert(:,g)=[meanData{g}{1}.pert;meanData{g}{2}.pert;meanData{g}{3}.pert;meanData{g}{4}.pert;meanData{g}{8}.pert;meanData{g}{5}.pert;meanData{g}{6}.pert;meanData{g}{7}.pert];
    allVectors.out(:,g)=allVectors.sp(:,g)+allVectors.st(:,g);
end


endAdapt=length(meanData{g}{1}.net)+length(meanData{g}{2}.net)+length(meanData{g}{3}.net)+length(meanData{g}{4}.net)+length(meanData{g}{8}.net);


MinVal=min(min(allVectors.out));
allVectors.outShifted=allVectors.out-MinVal;


tempmax=nanmedian(allVectors.outShifted(endAdapt-9:endAdapt,:));
MaxVal=max(tempmax);

allVectors.ExtAdapt=allVectors.outShifted./MaxVal;



