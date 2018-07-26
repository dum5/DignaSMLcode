function smoothedData=smoothData(data,binWidth,summethod)
start=1:size(data,1)-(binWidth-1);
stop=start+binWidth-1;
nbins=length(start);
smoothedData=NaN(nbins,size(data,2));

for n=1:size(data,2)
    for binNum=1:length(start)
        if strcmp(summethod,'nanmean')
            smoothedData(binNum,n)=nanmean(data(start(binNum):stop(binNum),n));
        elseif strmp(summethod,'nanmedian')
            smoothedData(binNum,n)=nanmedian(data(start(binNum):stop(binNum),n));
        end
    end
        
end
end