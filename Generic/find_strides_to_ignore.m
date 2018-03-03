function index_first_point=find_strides_to_ignore(data,NUM_COND,INCREASING,START_FROM_MINIMUM)

% offset=0;
% if START_FROM_MINIMUM
%     [~, indMin]=min(data);
%     data=data(indMin:end);
%     offset=indMin;
% end

NUM_COND=NUM_COND-1;
% trendData = compute_trend(data,1);
d=diff(data);
if INCREASING %if we expect an increasing fucntion
    indicesOk=d>=0;
else
    indicesOk=d<=0;
end
y=find_consecutive_ones(indicesOk);

if START_FROM_MINIMUM
    indices_first_points = find(y>=NUM_COND) - NUM_COND + 1;
    [min_val] = min(data(indices_first_points));
    index_first_point = find(data==min_val,1);
else
    index_first_point = find(y>=NUM_COND,1) - NUM_COND + 1;
end
end
% consecutive_increasing=0;
% for i=1:n
%     if indices(i)==1
%         consecutive_increasing=consecutive_increasing+1;
%     else
%
%     end
%
%     %Check whether we hit the threshold
%     if consecutive_increasing==NUM_INCREASING
%         %Find first one of the current series
%         break;
%     else
%         %Keep of searching
%         consecutive_increasing=0;
%     end
%
% end
%
% end
%
