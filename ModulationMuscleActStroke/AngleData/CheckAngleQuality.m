clear all
close all
clc

path='Z:\SubjectData\E01 Synergies\mat\HPF30\';
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0012','P0013','P0014','P0015','P0016'};%SJ 11 omitted, because error
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 

allnames=[strokesNames controlsNames];

RgdEvents={'RHS' 'LTO' 'LHS' 'RTO'};
LgdEvents={'LHS' 'RTO' 'RHS' 'LTO'};
tEvents=[15 30 15 40];

for i=1:length(allnames)
    
    
    load([path,allnames{i},'.mat'])
    adap=expData.metaData.getTrialsInCondition('Adaptation');
    base=expData.metaData.getTrialsInCondition('TM base');
    wash=expData.metaData.getTrialsInCondition('Washout');
    
    figure
    subplot(3,2,1);title('Lhip')
    subplot(3,2,2);title('Rhip')
    subplot(3,2,3);title('LKnee')
    subplot(3,2,4);title('RKnee')
    subplot(3,2,5);title('LAnk')
    subplot(3,2,6);title('RAnk')
    for k=1:length(base)
        baseData{k}=expData.data{base(k)}.angleData.getDataAsTS({'Rhip','LHip','Rknee','Lknee','Rank','Lank'});
        baseDataRAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,RgdEvents,tEvents);
        baseDataLAligned{k}=baseData{k}.align(expData.data{base(k)}.gaitEvents,LgdEvents,tEvents);
        
        get(subplot(3,2,1))
        hold on
        plot(1:100,squeeze(baseDataLAligned{k}.Data(:,2,6:end-5)),'k')
        get(subplot(3,2,2))
        hold on
        plot(1:100,squeeze(baseDataRAligned{k}.Data(:,1,6:end-5)),'k')
        get(subplot(3,2,3))
        hold on
        plot(1:100,squeeze(baseDataLAligned{k}.Data(:,4,6:end-5)),'k')
        get(subplot(3,2,4))
        hold on
        plot(1:100,squeeze(baseDataRAligned{k}.Data(:,3,6:end-5)),'k')
        get(subplot(3,2,5))
        hold on
        plot(1:100,squeeze(baseDataLAligned{k}.Data(:,6,6:end-5)),'k')
        get(subplot(3,2,6))
        hold on
        plot(1:100,squeeze(baseDataRAligned{k}.Data(:,5,6:end-5)),'k')
    end
         print(['sub ' allnames{i},'AngleData Base'],'-dpng')
        close all
       
         figure
    subplot(3,2,1);title('Lhip')
    subplot(3,2,2);title('Rhip')
    subplot(3,2,3);title('LKnee')
    subplot(3,2,4);title('RKnee')
    subplot(3,2,5);title('LAnk')
    subplot(3,2,6);title('RAnk')
    for k=1:length(adap)
        adapData{k}=expData.data{adap(k)}.angleData.getDataAsTS({'Rhip','LHip','Rknee','Lknee','Rank','Lank'});
        adapDataRAligned{k}=adapData{k}.align(expData.data{adap(k)}.gaitEvents,RgdEvents,tEvents);
        adapDataLAligned{k}=adapData{k}.align(expData.data{adap(k)}.gaitEvents,LgdEvents,tEvents);
        
        get(subplot(3,2,1))
        hold on
        plot(1:100,squeeze(adapDataLAligned{k}.Data(:,2,6:end-5)),'k')
        get(subplot(3,2,2))
        hold on
        plot(1:100,squeeze(adapDataRAligned{k}.Data(:,1,6:end-5)),'k')
        get(subplot(3,2,3))
        hold on
        plot(1:100,squeeze(adapDataLAligned{k}.Data(:,4,6:end-5)),'k')
        get(subplot(3,2,4))
        hold on
        plot(1:100,squeeze(adapDataRAligned{k}.Data(:,3,6:end-5)),'k')
        get(subplot(3,2,5))
        hold on
        plot(1:100,squeeze(adapDataLAligned{k}.Data(:,6,6:end-5)),'k')
        get(subplot(3,2,6))
        hold on
        plot(1:100,squeeze(adapDataRAligned{k}.Data(:,5,6:end-5)),'k')
    end
         print(['sub ' allnames{i},'AngleData Adap'],'-dpng')
        close all
        
          figure
    subplot(3,2,1);title('Lhip')
    subplot(3,2,2);title('Rhip')
    subplot(3,2,3);title('LKnee')
    subplot(3,2,4);title('RKnee')
    subplot(3,2,5);title('LAnk')
    subplot(3,2,6);title('RAnk')
    for k=1:length(wash)
        washData{k}=expData.data{wash(k)}.angleData.getDataAsTS({'Rhip','LHip','Rknee','Lknee','Rank','Lank'});
        washDataRAligned{k}=washData{k}.align(expData.data{wash(k)}.gaitEvents,RgdEvents,tEvents);
        washDataLAligned{k}=washData{k}.align(expData.data{wash(k)}.gaitEvents,LgdEvents,tEvents);
        
        get(subplot(3,2,1))
        hold on
        plot(1:100,squeeze(washDataLAligned{k}.Data(:,2,6:end-5)),'k')
        get(subplot(3,2,2))
        hold on
        plot(1:100,squeeze(washDataRAligned{k}.Data(:,1,6:end-5)),'k')
        get(subplot(3,2,3))
        hold on
        plot(1:100,squeeze(washDataLAligned{k}.Data(:,4,6:end-5)),'k')
        get(subplot(3,2,4))
        hold on
        plot(1:100,squeeze(washDataRAligned{k}.Data(:,3,6:end-5)),'k')
        get(subplot(3,2,5))
        hold on
        plot(1:100,squeeze(washDataLAligned{k}.Data(:,6,6:end-5)),'k')
        get(subplot(3,2,6))
        hold on
        plot(1:100,squeeze(washDataRAligned{k}.Data(:,5,6:end-5)),'k')
    end
      print(['sub ' allnames{i},'AngleData Washout'],'-dpng')
        close all
        
        clear washData washDataRAligned washDataLAligned adapData adapDataRAligned adapDataLAligned baseData baseDataRAligned baseDataLAligned

end
    