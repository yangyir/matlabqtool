function [] = sortByTime(obj,mode)
if nargin ==1
    mode = 'ascend';
end

if strcmp(mode,'ascend')
    targetMode = 1;
else
    targetMode = -1;
end

if obj.isSorted == targetMode
    return;
end

obj.prune();
if isempty(obj.isSorted)||obj.isSorted == 0
    [~,idx] = sort(obj.time,1,mode);
else
    idx = fliplr(1:obj.latest);
end


for i = 1:length(obj.headers)
    obj.(obj.headers{i}) =obj.(obj.headers{i})(idx);
end
obj.isSorted = targetMode;

end