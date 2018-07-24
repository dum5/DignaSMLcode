clear all
close all
clc

path='Z:\SubjectData\E01 Synergies\mat\HPF30\';
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%SJ 11 omitted, because error
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 

mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
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
     
    base=expData.metaData.getTrialsInCondition('TM base');
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
       
        
        %plot(axT,tempdata,'Color',[0.6 0.6 0.6]);
        dt2=nanmean(abs(tempdata),2);
        dt2=smoothData(dt2,200);
        lowVals.(mOrder{m})(i)=min(abs(dt2));
        highVals.(mOrder{m})(i)=max(abs(dt2));
        ratios.(mOrder{m})(i)=max(abs(dt2))/min(abs(dt2));
        
       
        clear dt tempdata dt2
    end
    
    clear base baseData baseDataRAligned baseDataLAligned
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
    boxplot(ha(p),[T1.RGLU, T1.LGLU,T1.RTFL,T1.LTFL,T1.RADM,T1.LADM,T1.RHIP,T1.LHIP,T1.RRF,T1.LRF,T1.RVL,T1.LVL,T1.RVM,T1.LVM,T1.RSEMT,T1.LSEMT,...
        T1.RSEMB,T1.LSEMB,T1.RBF,T1.LBF,T1.RMG,T1.LMG,T1.RLG,T1.LLG,T1.RSOL,T1.LSOL,T1.RPER,T1.RPER,T1.RTA,T1.LTA],'position',x1,'widths',0.7,'Color','r')
    boxplot(ha(p),[T2.RGLU, T2.LGLU,T2.RTFL,T2.LTFL,T2.RADM,T2.LADM,T2.RHIP,T2.LHIP,T2.RRF,T2.LRF,T2.RVL,T2.LVL,T2.RVM,T2.LVM,T2.RSEMT,T2.LSEMT,...
        T2.RSEMB,T2.LSEMB,T2.RBF,T2.LBF,T2.RMG,T2.LMG,T2.RLG,T2.LLG,T2.RSOL,T2.LSOL,T2.RPER,T2.RPER,T2.RTA,T2.LTA],'position',x2,'widths',0.7,'Color','g')
    title(ha(p),names{p})
    plot(ha(p),x1,[T1.RGLU(3), T1.LGLU(3),T1.RTFL(3),T1.LTFL(3),T1.RADM(3),T1.LADM(3),T1.RHIP(3),T1.LHIP(3),T1.RRF(3),T1.LRF(3),T1.RVL(3),T1.LVL(3),T1.RVM(3),T1.LVM(3),...
        T1.RSEMT(3),T1.LSEMT(3),T1.RSEMB(3),T1.LSEMB(3),T1.RBF(3),T1.LBF(3),T1.RMG(3),T1.LMG(3),T1.RLG(3),T1.LLG(3),T1.RSOL(3),T1.LSOL(3),T1.RPER(3),T1.RPER(3),T1.RTA(3),T1.LTA(3)],...
        '.k','MarkerSize',10);
    grid(ha(p),'on')
    ha(p).GridAlpha=0.8;
    
end
yticklabels(ha,'auto')
xticklabels(ha,{'RGLU', 'LGLU','RTFL','LTFL','RADM','LADM','RHIP','LHIP','RRF','LRF','RVL','LVL','RVM','LVM','RSEMT','LSEMT',...
        'RSEMB','LSEMB','RBF','LBF','RMG','LMG','RLG','LLG','RSOL','LSOL','RPER','RPER','RTA','LTA'})

