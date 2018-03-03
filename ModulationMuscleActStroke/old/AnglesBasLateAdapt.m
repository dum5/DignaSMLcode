%Compute limb angle trajectories "synergy study"
clear all
close all
 possibleNames={{'OG base','OG','OG base ','OG '},{'TM slow','TM base slow','slow'},{'mid','TM mid','TM med', 'TM base med','TM base mid','TM base mid 1', 'TM base med 1'},{'short exp','short split','Short Exposure'},{'fast','TM fast'},{'Baseline','TM base','base','TM base med 2','TM base mid 2','TM base (mid)'},{'Adap','Adapt','Adaptation','adaptation '},{'Wash','Post-','TM post','Washout','Post-Adaptation','post-adap','Washout 1','TM washout'},{'OG post','OG wash','OG Postadap'},{'uphill mid','uphill mild','mid uphill','uphill low'},{'uphill steep','big uphill','uphill high'}};
 newNames={'OG Base','TM slow','TM mid','Short exposure','TM fast','TM base','Adaptation','Washout','OG post','Uphill mid','Uphill steep'};


td='S:\Shared\Digna\Synergy study\Raw files\';

%list of controls
controls={'C0001','C0002','C0003','C0004','C0005','C0006','C0007','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'};
stroke={'P0001','P0002','P0003','P0004','P0005','P0006','P0007','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
affected={'R','R','R','R','L','L','R','L','R','R','R','R','R','L','R','R'};
    
%these are always the same
gdEventsRight={'RHS' 'LTO' 'LHS' 'RTO'};
gdEventsLeft={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[15 30 15 40];

for c=1:length(controls)    
  load([td controls{c} '.mat'])
  disp(['processing ', controls{c}])
  [expData.metaData,change]=expData.metaData.numerateRepeatedConditionNames; %Enumerate repeated condition names
  [expData.metaData,change2]=expData.metaData.replaceConditionNames(possibleNames,newNames);
  
  
   newExpData=expData.computeAngles;
   trBas=find(ismember(newExpData.metaData.conditionName, 'TM base'));trBas=cell2mat(expData.metaData.trialsInCondition(trBas));%this can be one or more trials
   if isempty(trBas)
       trBas=find(ismember(newExpData.metaData.conditionName, 'TM base med 2'));trBas=cell2mat(expData.metaData.trialsInCondition(trBas));%this can be one or more trials
   end
       
   
   
   dt.fastLimb=[];dt.slowLimb=[];dt.fastHip=[];dt.slowHip=[];dt.fastKnee=[];dt.slowKnee=[];dt.fastAnk=[];dt.slowAnk=[];dt.fastHipVEL=[];dt.slowHipVEL=[];dt.fastKneeVEL=[];dt.slowKneeVEL=[];dt.fastAnkVEL=[];dt.slowAnkVEL=[];
   for i=1:length(trBas)
       trial=trBas(i);
       dt.TS_baseline{i}=getDataAsTS(newExpData.data{1,trial}.angleData,{'RLimb','LLimb','RThigh','LThigh','RShank','LShank','RFoot','LFoot','Rhip','Lhip','Rknee','Lknee','Rank','Lank',...
               'RhipVel','LhipVel','RkneeVel','LkneeVel','RankVel','LankVel'});
       if strcmp(newExpData.subData.dominantLeg,'Right')
           dt.alignedTS_baselineF{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
           dt.alignedTS_baselineS{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents); 
            order=[1 2 9 10 11 12 13 14 15 16 17 18 19 20];
       elseif strcmp(newExpData.subData.dominantLeg,'Left')
           dt.alignedTS_baselineS{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
           dt.alignedTS_baselineF{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);     
           order=[2 1 10 9 12 11 14 13 16 15 18 17 20 19];
       end
       dt.fastLimb=[dt.fastLimb;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(1),:))'];
       dt.slowLimb=[dt.slowLimb;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(2),:))'];
       
       dt.fastHip=[dt.fastHip;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(3),:))'];
       dt.slowHip=[dt.slowHip;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(4),:))'];
              
       dt.fastKnee=[dt.fastKnee;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(5),:))'];
       dt.slowKnee=[dt.slowKnee;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(6),:))'];
       
       dt.fastAnk=[dt.fastAnk;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(7),:))'];
       dt.slowAnk=[dt.slowAnk;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(8),:))'];
       
       dt.fastHipVEL=[dt.fastHipVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(9),:))'];
       dt.slowHipVEL=[dt.slowHipVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(10),:))'];
       
       dt.fastKneeVEL=[dt.fastKneeVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(11),:))'];
       dt.slowKneeVEL=[dt.slowKneeVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(12),:))'];
       
       dt.fastAnkVEL=[dt.fastAnkVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(13),:))'];
       dt.slowAnkVEL=[dt.slowAnkVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(14),:))'];
       
   end
   
   controldata(c).baselineData=dt;  clear dt
   
   %do same for adaptation
   trAdapt=find(ismember(newExpData.metaData.conditionName, 'Adaptation'));trAdapt=cell2mat(expData.metaData.trialsInCondition(trAdapt));%this can be one or more trials
   if isempty(trAdapt)
       trAdapt=find(ismember(newExpData.metaData.conditionName, 'Adaptation '));trAdapt=cell2mat(expData.metaData.trialsInCondition(trAdapt));%this can be one or more trials
   end
   
   dt.fastLimb=[];dt.slowLimb=[];dt.fastHip=[];dt.slowHip=[];dt.fastKnee=[];dt.slowKnee=[];dt.fastAnk=[];dt.slowAnk=[];dt.fastHipVEL=[];dt.slowHipVEL=[];dt.fastKneeVEL=[];dt.slowKneeVEL=[];dt.fastAnkVEL=[];dt.slowAnkVEL=[];
   for i=1:length(trAdapt);
       trial=trAdapt(i);
       dt.TS_adapt{i}=getDataAsTS(newExpData.data{1,trial}.angleData,{'RLimb','LLimb','RThigh','LThigh','RShank','LShank','RFoot','LFoot','Rhip','Lhip','Rknee','Lknee','Rank','Lank',...
               'RhipVel','LhipVel','RkneeVel','LkneeVel','RankVel','LankVel'});
       if strcmp(newExpData.subData.dominantLeg,'Right')
           dt.alignedTS_adaptF{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
           dt.alignedTS_adaptS{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);  
            order=[1 2 9 10 11 12 13 14 15 16 17 18 19 20];
       elseif strcmp(newExpData.subData.dominantLeg,'Left')
           dt.alignedTS_adaptS{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
           dt.alignedTS_adaptF{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);       
           order=[2 1 10 9 12 11 14 13 16 15 18 17 20 19];
       end
       dt.fastLimb=[dt.fastLimb;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(1),:))'];
       dt.slowLimb=[dt.slowLimb;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(2),:))'];
       
       dt.fastHip=[dt.fastHip;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(3),:))'];
       dt.slowHip=[dt.slowHip;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(4),:))'];
              
       dt.fastKnee=[dt.fastKnee;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(5),:))'];
       dt.slowKnee=[dt.slowKnee;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(6),:))'];
       
       dt.fastAnk=[dt.fastAnk;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(7),:))'];
       dt.slowAnk=[dt.slowAnk;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(8),:))'];
       
       dt.fastHipVEL=[dt.fastHipVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(9),:))'];
       dt.slowHipVEL=[dt.slowHipVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(10),:))'];
       
       dt.fastKneeVEL=[dt.fastKneeVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(11),:))'];
       dt.slowKneeVEL=[dt.slowKneeVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(12),:))'];
       
       dt.fastAnkVEL=[dt.fastAnkVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(13),:))'];
       dt.slowAnkVEL=[dt.slowAnkVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(14),:))'];
   end
   
   controldata(c).AdaptData=dt;  clear dt expData newExpData
   
end

for c=7:length(stroke)
   load([td stroke{c} '.mat'])
   disp(['processing ', stroke{c}])
   [expData.metaData,change]=expData.metaData.numerateRepeatedConditionNames; %Enumerate repeated condition names
   [expData.metaData,change2]=expData.metaData.replaceConditionNames(possibleNames,newNames);
   newExpData=expData.computeAngles;
   trBas=find(ismember(newExpData.metaData.conditionName, 'TM base'));trBas=cell2mat(expData.metaData.trialsInCondition(trBas));%this can be one or more trials
   if isempty(trBas)
       trBas=find(ismember(newExpData.metaData.conditionName, 'TM base med 2'));trBas=cell2mat(expData.metaData.trialsInCondition(trBas));%this can be one or more trials
   end
   
   
   dt.fastLimb=[];dt.slowLimb=[];dt.fastHip=[];dt.slowHip=[];dt.fastKnee=[];dt.slowKnee=[];dt.fastAnk=[];dt.slowAnk=[];dt.fastHipVEL=[];dt.slowHipVEL=[];dt.fastKneeVEL=[];dt.slowKneeVEL=[];dt.fastAnkVEL=[];dt.slowAnkVEL=[];
   for i=1:length(trBas)
         f=0;
       trial=trBas(i);
       try
        dt.TS_baseline{i}=getDataAsTS(newExpData.data{1,trial}.angleData,{'RLimb','LLimb','RThigh','LThigh','RShank','LShank','RFoot','LFoot','Rhip','Lhip','Rknee','Lknee','Rank','Lank',...
               'RhipVel','LhipVel','RkneeVel','LkneeVel','RankVel','LankVel'});
       catch
           disp('trial could not be processed due to missing data')
           f=1;
       end
       
       if f==0
           if strcmp(affected{c},'L')
               dt.alignedTS_baselineF{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
               dt.alignedTS_baselineS{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);    
               order=[1 2 9 10 11 12 13 14 15 16 17 18 19 20];
           elseif strcmp(affected{c},'R')
               dt.alignedTS_baselineS{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
               dt.alignedTS_baselineF{i}=dt.TS_baseline{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);  
               order=[2 1 10 9 12 11 14 13 16 15 18 17 20 19];
           end
           dt.fastLimb=[dt.fastLimb;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(1),:))'];
           dt.slowLimb=[dt.slowLimb;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(2),:))'];

           dt.fastHip=[dt.fastHip;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(3),:))'];
           dt.slowHip=[dt.slowHip;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(4),:))'];

           dt.fastKnee=[dt.fastKnee;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(5),:))'];
           dt.slowKnee=[dt.slowKnee;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(6),:))'];

           dt.fastAnk=[dt.fastAnk;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(7),:))'];
           dt.slowAnk=[dt.slowAnk;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(8),:))'];
           
           
           dt.fastHipVEL=[dt.fastHipVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(9),:))'];
           dt.slowHipVEL=[dt.slowHipVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(10),:))'];

           dt.fastKneeVEL=[dt.fastKneeVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(11),:))'];
           dt.slowKneeVEL=[dt.slowKneeVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(12),:))'];

           dt.fastAnkVEL=[dt.fastAnkVEL;squeeze(dt.alignedTS_baselineF{i}.Data(:,order(13),:))'];
           dt.slowAnkVEL=[dt.slowAnkVEL;squeeze(dt.alignedTS_baselineS{i}.Data(:,order(14),:))'];
       else
           f=0;
       end
   end
   
   strokedata(c).baselineData=dt;  clear dt 
   
   %do same for adaptation
   trAdapt=find(ismember(newExpData.metaData.conditionName, 'Adaptation'));trAdapt=cell2mat(expData.metaData.trialsInCondition(trAdapt));%this can be one or more trials
   if isempty(trAdapt)
       trAdapt=find(ismember(newExpData.metaData.conditionName, 'Adaptation '));trAdapt=cell2mat(expData.metaData.trialsInCondition(trAdapt));%this can be one or more trials
   end
   
    dt.fastLimb=[];dt.slowLimb=[];dt.fastHip=[];dt.slowHip=[];dt.fastKnee=[];dt.slowKnee=[];dt.fastAnk=[];dt.slowAnk=[];dt.fastHipVEL=[];dt.slowHipVEL=[];dt.fastKneeVEL=[];dt.slowKneeVEL=[];dt.fastAnkVEL=[];dt.slowAnkVEL=[];
   for i=1:length(trAdapt);
       f=0;
       trial=trAdapt(i);
       try
           dt.TS_adapt{i}=getDataAsTS(newExpData.data{1,trial}.angleData,{'RLimb','LLimb','RThigh','LThigh','RShank','LShank','RFoot','LFoot','Rhip','Lhip','Rknee','Lknee','Rank','Lank',...
               'RhipVel','LhipVel','RkneeVel','LkneeVel','RankVel','LankVel'});
       catch
           disp('trial could not be processed due to missing data')
           f=1;
       end
       if f==0
           if strcmp(affected{c},'L')
               dt.alignedTS_adaptF{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
               dt.alignedTS_adaptS{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
               order=[1 2 9 10 11 12 13 14 15 16 17 18 19 20];
           elseif strcmp(affected{c},'R')
               dt.alignedTS_adaptS{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsRight,tEvents);
               dt.alignedTS_adaptF{i}=dt.TS_adapt{i}.align(newExpData.data{1,trial}.gaitEvents, gdEventsLeft,tEvents);
               order=[2 1 10 9 12 11 14 13 16 15 18 17 20 19];
           end
           dt.fastLimb=[dt.fastLimb;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(1),:))'];
           dt.slowLimb=[dt.slowLimb;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(2),:))'];

           dt.fastHip=[dt.fastHip;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(3),:))'];
           dt.slowHip=[dt.slowHip;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(4),:))'];

           dt.fastKnee=[dt.fastKnee;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(5),:))'];
           dt.slowKnee=[dt.slowKnee;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(6),:))'];

           dt.fastAnk=[dt.fastAnk;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(7),:))'];
           dt.slowAnk=[dt.slowAnk;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(8),:))'];
           

           dt.fastHipVEL=[dt.fastHipVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(9),:))'];
           dt.slowHipVEL=[dt.slowHipVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(10),:))'];

           dt.fastKneeVEL=[dt.fastKneeVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(11),:))'];
           dt.slowKneeVEL=[dt.slowKneeVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(12),:))'];

           dt.fastAnkVEL=[dt.fastAnkVEL;squeeze(dt.alignedTS_adaptF{i}.Data(:,order(13),:))'];
           dt.slowAnkVEL=[dt.slowAnkVEL;squeeze(dt.alignedTS_adaptS{i}.Data(:,order(14),:))'];
           
       else
           f=0;
       end
   end
   
   strokedata(c).AdaptData=dt;  clear dt expData newExpData
   
end






