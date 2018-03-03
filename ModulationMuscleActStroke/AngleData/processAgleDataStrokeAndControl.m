%Compute limb angle trajectories "synergy study"
clear all
close all
 possibleNames={{'OG base','OG','OG base ','OG '},{'TM slow','TM base slow','slow'},{'mid','TM mid','TM med', 'TM base med','TM base mid','TM base mid 1', 'TM base med 1'},{'short exp','short split','Short Exposure'},{'fast','TM fast'},{'Baseline','TM base','base','TM base med 2','TM base mid 2','TM base (mid)'},{'Adap','Adapt','Adaptation','adaptation '},{'Wash','Post-','TM post','Washout','Post-Adaptation','post-adap','Washout 1','TM washout'},{'OG post','OG wash','OG Postadap'},{'uphill mid','uphill mild','mid uphill','uphill low'},{'uphill steep','big uphill','uphill high'}};
 newNames={'OG Base','TM slow','TM mid','Short exposure','TM fast','TM base','Adaptation','Washout','OG post','Uphill mid','Uphill steep'};


td='Z:\Users\Digna\Projects\Synergy study\Raw files\';

%list of controls
controls={'C0001','C0002','C0003','C0004','C0005','C0006','C0007','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'};
stroke={'P0001','P0002','P0003','P0004','P0005','P0006','P0007','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
%affected={'R','R','R','R','L','L','R','L','R','R','R','R','R','L','R','R'};
    

for c=1:length(controls)    
  load([td controls{c} '.mat'])
  disp(['processing ', controls{c}])
  [expData.metaData,change]=expData.metaData.numerateRepeatedConditionNames; %Enumerate repeated condition names
  [expData.metaData,change2]=expData.metaData.replaceConditionNames(possibleNames,newNames);
  expData=expData.process;%change back into process if needed
  adaptData=expData.makeDataObj;
  save([td controls{c} '2.mat'],'expData','-v7.3')
  save([td controls{c} '.paramsKneeAngFC.mat'],'adaptData','-v7.3')
  clear expData adaptData
end
  
for c=[8 9]%1:length(stroke)    
  load([td stroke{c} '.mat'])
  disp(['processing ', stroke{c}])
  [expData.metaData,change]=expData.metaData.numerateRepeatedConditionNames; %Enumerate repeated condition names
  [expData.metaData,change2]=expData.metaData.replaceConditionNames(possibleNames,newNames);
  expData=expData.process;
  adaptData=expData.makeDataObj;
  save([td stroke{c} '2.mat'],'expData','-v7.3')
   save([td stroke{c} '.paramsKneeAngFC.mat'],'adaptData','-v7.3')
  clear expData adaptData
end