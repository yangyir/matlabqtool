function [ newobj ] = getByIndex(obj, idx)
%GETBYINDEX 从已有Bars里拿出idx对应的条目
% 标量不变，只对时间序列取idx对应条
% 类似于 b = a( a>0 )的用法
% 例子 newtks = tks.getByIndex(tks.last > tks.askP(:,1) )
% 注：bars.latest 放弃， .data, .data2, .headers放弃
% 程刚；20140726
% 程刚，140829；使用这个写法：    newobj.(fd)  = obj.(fd);

newobj = Bars;

%% 标量fields
flds ={ 'code','code2', 'type', 'slicetype', ... % 'latest', ...
    'date', ...  %'date2', ...
    'preSettlement', 'settlement'};

for i = 1:length(flds)
    fd = flds{i};
    newobj.(fd)  = obj.(fd);
end



%% 时间序列fields
tsFields = {'time', 'time2', ...
    'open', 'high', 'low', 'close', 'vwap', ...
    'volume', 'amount','openInt', ...
    };

for i = 1:length(tsFields)
    fd      = tsFields{i};
    fddata  = obj.(fd);
    if isempty(fddata), continue; end
    if isnan(fddata),   continue; end
    newobj.(fd)  = obj.(fd)(idx,:);

end


end

