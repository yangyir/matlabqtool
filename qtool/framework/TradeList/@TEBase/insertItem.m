function [] = insertItem(obj,obj2,seqNo,seqNo2)
% 将obj2从seqNo2提取的记录，作为一个整体，插入到obj的seqNo处
% 父类属性在先
if length(seqNo)~=1
    error('Target seqNo must be a scalar!');
end
obj.isSorted =0;
obj.vec2item(obj2.item2vec(seqNo2),seqNo);
end