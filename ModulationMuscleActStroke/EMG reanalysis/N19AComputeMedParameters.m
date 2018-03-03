clear all
close all

%% Load if not calculated
sourceDir='Z:\SubjectData\E01 Synergies\mat\HPF30\';
destDir='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Data\';
destName='groupedParams30Hz';
recomputeAllFlag=1;%set this to zero if median params are already computed

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0007','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0007','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'};

subs={strokesNames,controlsNames};
groups=cell(length(subs),1);
removeMissing=false; %Nothing else is allowed



deltawait=1/32;
x=0;
if recomputeAllFlag==1
    h=waitbar(x,'start loading subjects');
end
for j=[1,2]% strokes and controls
    
    nameList=subs{j};
    subList={};
    if recomputeAllFlag==0%generate groupfile from ind subject files
        
        for i=1:length(nameList)
            subList{i}=[sourceDir nameList{i},'Params']; %Params is capped in my files, but not on others
        end
      
    elseif recomputeAllFlag==1
%         groups{1}.ID=strokesNames;
%         groups{2}.ID=controlsNames;
%         groups{1}.groupID='P';
%         groups{2}.groupID='C';
        for i=1:length(nameList)
            x=x+deltawait;
            waitbar(x,h,['Loading subject ',nameList{i}]);
            load([sourceDir nameList{i}])
            expData=expData.flushAndRecomputeParameters;
            adaptData=expData.makeDataObj;
            save([sourceDir,nameList{i},'ParamsB'],'adaptData','-v7.3')
            clear adaptData
            subList{i}=[sourceDir nameList{i},'ParamsB'];
        end     
    end
    groups{j}=adaptationData.createGroupAdaptData(subList);
    %substitute data for subject P0008
    if j==1    
    load([sourceDir,'P0008.mat'])
    groups{j}.adaptData{8}=fcnTransferGaitEventsP0008(expData);
    end
    
    %Renaming some EMG-associated params (different names across subs)
    l1=groups{j}.getLabelsThatMatch('ILP');
    l2=regexprep(l1,'ILP','SAR');
    l3=regexprep(l1,'ILP','HIP');
    groups{j}=groups{j}.renameParams(l1,l3);
    groups{j}=groups{j}.renameParams(l2,l3);    
  
    replacementConditionNames
    
   
    groups{j}.getCommonConditions
    
    %Generating normalized EMG parameters (so I don't have to recompute
    %everytime):
    baseEp=getBaseEpoch; %defines baseEp
    mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
    nMusc=length(mOrder);
    type='s';
    labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
    labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names
    groups{j}=groups{j}.normalizeToBaselineEpoch(labelPrefixLong,baseEp);
    
    clear labelPrefix labelPrefixLong
    labelPrefix=fliplr([strcat('medf',mOrder) strcat('meds',mOrder)]); %To display
    labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names
    groups{j}=groups{j}.normalizeToBaselineEpoch(labelPrefixLong,baseEp);
    
    
end
%%
patients=groups{1};
controls=groups{2};
clear groups*

%%
patients.adaptData{1}.metaData.conditionName{4}='TM base'; %P01 has bad condition name which confounds with TM mid when it exists.
%% Sanity check: 8 common conditions
if length(controls.getCommonConditions)<8 || length(patients.getCommonConditions)<6 || length(patients.removeSubs({'P0001','P0007','P0011'}).getCommonConditions)<8
    error('Groups do not have the 8 expected common conditions, some re-naming did NOT work')
    %For controls we expect: OG base, slow, mid, short, base, adapt, wash, OG post
    %For patients the same, except: short (not in P07,P11) , mid (not present in P01,P11)
end

disp('Saving control+patient data...')
tic
save([destDir,destName],'controls','patients','-v7.3')
disp('Done!')
toc

