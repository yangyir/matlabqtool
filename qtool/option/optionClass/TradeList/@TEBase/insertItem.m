function [] = insertItem(obj,obj2,seqNo,seqNo2)
% ��obj2��seqNo2��ȡ�ļ�¼����Ϊһ�����壬���뵽obj��seqNo��
% ������������
if length(seqNo)~=1
    error('Target seqNo must be a scalar!');
end
obj.isSorted =0;
obj.vec2item(obj2.item2vec(seqNo2),seqNo);
end