function [maxvals]=findmaxAV(data,firstFrame,lastFrame,w_size)

   data=data(firstFrame:lastFrame,:);
    for i=size(data,2)     
        for k=1:size(data,1)-w_size
            dt(k)=nanmean(data(k:k+w_size-1,i));           
        end
        maxvals(1,i)=max(dt);
    end
    

end