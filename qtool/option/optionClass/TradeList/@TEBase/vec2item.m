function [] = vec2item(obj,vec,seqNo)
% seqNo �ǲ���λ�ã�ֻ�����β��롣
% ������������

numItem = size(vec,1);
if obj.capacity<obj.latest+numItem
    obj.extend(obj.latest+numItem-obj.capacity);
end

if seqNo>=obj.latest+1
    seqNo = obj.latest+1;
else
    
    for i = 1:length(obj.headers)
        obj.(obj.headers{i})(seqNo+numItem:obj.latest+numItem)=obj.(obj.headers{i})(seqNo:obj.latest);
    end
end
for i = 1:length(obj.headers)
    obj.(obj.headers{i})(seqNo:seqNo+numItem-1)=vec(:,i);
end

obj.latest = obj.latest+numItem;
obj.isSorted = 0;

end