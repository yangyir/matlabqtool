function [] = rmvItem(obj, seqNo)
if isempty(seqNo)
    return;
end
obj.latest = obj.latest - length(seqNo);
obj.capacity = obj.capacity - length(seqNo);
for i = 1:length(obj.headers)
    obj.(obj.headers{i})(seqNo) =[];
end

end