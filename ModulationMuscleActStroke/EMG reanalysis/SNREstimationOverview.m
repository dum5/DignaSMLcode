clear all
close all
clc

path='Z:\SubjectData\E01 Synergies\mat\HPF30\';
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%SJ 11 omitted, because error
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
mFields=[strcat('S',mOrder) strcat('F',mOrder)];
rSlowIdx=[1:30];
lSlowIdx=[16:30,1:15];
mOrder=[strcat('R',mOrder) strcat('L',mOrder)];
lowVals=table;
lowVals.sub=cell(30,1);
for m=1:length(mOrder)
   lowVals.(mOrder{m})=NaN(30,1);
end
highVals=lowVals;
ratios=lowVals;

allnames=[strokesNames controlsNames];

RgdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
LgdEvents={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[320,1280,320,1280];
for i=1:length(allnames)%for all subjects in the list
    
    load([path,allnames{i},'.mat'])
    lowVals.sub{i}=allnames{i};
    highVals.sub{i}=allnames{i};
    ratios.sub{i}=allnames{i};
     
    %base=expData.metaData.getTrialsInCondition('TM base');
    base=expData.metaData.getTrialsInCondition('Washout');
    muscles=expData.data{base(1)}.EMGData.labels;
    
    for k=1:length(base)
        baseData{k}=expData.data{base(k)}.EMGData.getDataAsTS(muscles);
        baseData{k}=baseData{k}.renameLabels({'RILP','LILP'},{'RHIP','LHIP'});
        baseData{k}=baseData{k}.renameLabels({'RSAR','LSAR'},{'RHIP','LHIP'});
        baseDataRAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,RgdEvents,tEvents);
        baseDataLAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,LgdEvents,tEvents);
    end
    
    for m=1:length(mOrder)
        [boolFlag,Idx]=isaLabel(baseData{k},mOrder{m});
        
        tempdata=[];
        if muscles{m}(1)=='R';
            dt=baseDataRAligned;
        else                
            dt=baseDataLAligned;        
        end
        for k=1:length(base)            
            tempdata=[tempdata,squeeze(dt{k}.Data(:,Idx,:))];          
        end
       
        tempdata=tempdata(:,end-40:end);%for TM post use last 40 strides
        
        %plot(axT,tempdata,'Color',[0.6 0.6 0.6]);
        dt2=nanmean(abs(tempdata),2);
        dt2=smoothData(dt2,200,'nanmean');
        if expData.getRefLeg=='R'
            mIdx=rSlowIdx(m);
        else
            mIdx=lSlowIdx(m);
        end
        lowVals.(mFields{mIdx})(i)=min(abs(dt2));
        highVals.(mFields{mIdx})(i)=max(abs(dt2));
        ratios.(mFields{mIdx})(i)=max(abs(dt2))/min(abs(dt2));
        
       
        clear dt tempdata dt2
    end
    
    clear base baseData baseDataRAligned baseDataLAligned expData
end

%plot Data
figure
ha=tight_subplot(3,1,0.05,0.05,0.05);
names={'low','high','ratio'};
x1=(3.*(1:30))-2;
x2=(3.*(1:30))-1;

for p=1:3
    if p==1;T=lowVals;        
    elseif p==2;T=highVals;
    elseif p==3;T=ratios;
    end
    T1=T(1:15,:);
    T2=T(16:30,:);
    hold(ha(p))
    boxplot(ha(p),[T1.SGLU, T1.FGLU,T1.STFL,T1.FTFL,T1.SADM,T1.FADM,T1.SHIP,T1.FHIP,T1.SRF,T1.FRF,T1.SVL,T1.FVL,T1.SVM,T1.FVM,T1.SSEMT,T1.FSEMT,...
        T1.SSEMB,T1.FSEMB,T1.SBF,T1.FBF,T1.SMG,T1.FMG,T1.SLG,T1.FLG,T1.SSOL,T1.FSOL,T1.SPER,T1.SPER,T1.STA,T1.FTA],'position',x1,'widths',0.7,'Color','r')
    boxplot(ha(p),[T2.SGLU, T2.FGLU,T2.STFL,T2.FTFL,T2.SADM,T2.FADM,T2.SHIP,T2.FHIP,T2.SRF,T2.FRF,T2.SVL,T2.FVL,T2.SVM,T2.FVM,T2.SSEMT,T2.FSEMT,...
        T2.SSEMB,T2.FSEMB,T2.SBF,T2.FBF,T2.SMG,T2.FMG,T2.SLG,T2.FLG,T2.SSOL,T2.FSOL,T2.SPER,T2.SPER,T2.STA,T2.FTA],'position',x2,'widths',0.7,'Color','g')
    title(ha(p),names{p})
    plot(ha(p),x1,[T1.SGLU(3), T1.FGLU(3),T1.STFL(3),T1.FTFL(3),T1.SADM(3),T1.FADM(3),T1.SHIP(3),T1.FHIP(3),T1.SRF(3),T1.FRF(3),T1.SVL(3),T1.FVL(3),T1.SVM(3),T1.FVM(3),...
        T1.SSEMT(3),T1.FSEMT(3),T1.SSEMB(3),T1.FSEMB(3),T1.SBF(3),T1.FBF(3),T1.SMG(3),T1.FMG(3),T1.SLG(3),T1.FLG(3),T1.SSOL(3),T1.FSOL(3),T1.SPER(3),T1.SPER(3),T1.STA(3),T1.FTA(3)],...
        '.k','MarkerSize',10);
    grid(ha(p),'on')
    ha(p).GridAlpha=0.8;
    
end
plot(ha(1),[1 90],[0.000005,0.000005],'--k')
plot(ha(2),[1 90],[0.000005,0.000005],'--k')
yticklabels(ha,'auto')
xticklabels(ha,{'S_GLU', 'F_GLU','S_TFL','F_TFL','S_ADM','F_ADM','S_HIP','F_HIP','S_RF','F_RF','S_VL','F_VL','S_VM','F_VM','S_SEMT','F_SEMT',...
        'S_SEMB','F_SEMB','S_BF','F_BF','S_MG','F_MG','S_LG','F_LG','S_SOL','F_SOL','S_PER','S_PER','S_TA','F_TA'})

