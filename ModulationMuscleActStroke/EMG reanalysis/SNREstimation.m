clear all
close all
clc

path='Z:\SubjectData\E01 Synergies\mat\HPF30\';
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0012','P0013','P0014','P0015','P0016'};%SJ 11 omitted, because error
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 

allnames=[strokesNames controlsNames];

RgdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
LgdEvents={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[320,1280,320,1280];
for i=1:length(allnames)%for all subjects in the list
%     f1=figure('Color',[1 1 1]);
%     ha=tight_subplot(5,3,0.03,0.03, 0.03);
%     set(ha,'box','off')
%     fullscreen
%     
%     f2=figure('Color',[1 1 1]);
%     hb=tight_subplot(5,3,0.03,0.03, 0.03);
%     set(hb,'box','off')
%     fullscreen
    
    load([path,allnames{i},'.mat'])
    if ~isempty(expData.data{1})
        muscles=expData.data{1}.EMGData.labels;
    elseif ~isempty(expData.data{2})
        muscles=expData.data{2}.EMGData.labels;
    elseif ~isempty(expData.data{3})
        muscles=expData.data{3}.EMGData.labels;
    elseif ~isempty(expData.data{4})
        muscles=expData.data{4}.EMGData.labels;
    else  muscles=expData.data{5}.EMGData.labels;
    end
    base=expData.metaData.getTrialsInCondition('TM base');
    
    for k=1:length(base)
        baseData{k}=expData.data{base(k)}.EMGData.getDataAsTS(muscles);
        baseDataRAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,RgdEvents,tEvents);
        baseDataLAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,LgdEvents,tEvents);
    end
    rcounter=0;
    lcounter=0;
    for m=1:length(muscles)
        tempdata=[];
        if muscles{m}(1)=='R';
            dt=baseDataRAligned;
            rcounter=rcounter+1;
            axT=ha(rcounter);
        else
            dt=baseDataLAligned;
            lcounter=lcounter+1;
            axT=hb(lcounter);
        end
        for k=1:length(base)            
            tempdata=[tempdata,squeeze(dt{k}.Data(:,m,:))];          
        end
       
        
        %plot(axT,tempdata,'Color',[0.6 0.6 0.6]);
        dt2=nanmean(abs(tempdata),2);
        dt2=smoothData(dt2,200);
        
        plot(axT,dt2,'Color',[0 0.45 0.75],'LineWidth',2);
        grid(axT,'on')
        lims=get(axT,'YLim');ymax=lims(2);
        text(axT,1600,0.95*ymax,muscles{m},'FontSize',14,'FontWeight','bold')
        set(axT,'XTick',[0 320 1600 1920], 'XTicklabel',{'iHS','cTO','cHS','iTO'},'box','off')
        text(axT,0,0.85*ymax,['min=',num2str(min(abs(dt2))),',max=',num2str(max(abs(dt2))),',ratio=',num2str(round(max(abs(dt2))/min(abs(dt2))))],'FontSize',12);
        
        clear dt tempdata dt2
    end
    get(f1)
     print(f1,['sub ' allnames{i},'SNR_Right'],'-dpng');
     get(f2)
     print(f2,['sub ' allnames{i},'SNR_Left'],'-dpng');
     close all
    clear base baseData baseDataRAligned baseDataLAligned
end