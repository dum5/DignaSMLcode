%clear all
N1_mainFuncMedCountsCombined;

figure
alldata=squeeze(nanmedian(dataEc2,4));
subplot(1,3,1);
hold on
title('slow VL eA-Base')
row=25;
bar(alldata(:,row));
for sj=1:15
    for bin=1:12;
        if dataBinaryc2(bin,row,1,sj)==0
            plot(bin,dataEc2(bin,row,1,sj),'ok')
        else
            plot(bin,dataEc2(bin,row,1,sj),'ok','Color','r')
        end
    end
end

subplot(1,3,2);
hold on
title('slow TA')
row=16;
bar(alldata(:,row));
for sj=1:15
    for bin=1:12;
        if dataBinaryc2(bin,row,1,sj)==0
            plot(bin,dataEc2(bin,row,1,sj),'ok')
        else
            plot(bin,dataEc2(bin,row,1,sj),'ok','Color','r')
        end
    end
end


subplot(1,3,3);
hold on
title('slow SEMT')
row=23;
bar(alldata(:,row));
for sj=1:15
    for bin=1:12;
        if dataBinaryc2(bin,row,1,sj)==0
            plot(bin,dataEc2(bin,row,1,sj),'ok')
        else
            plot(bin,dataEc2(bin,row,1,sj),'ok','Color','r')
        end
    end
end