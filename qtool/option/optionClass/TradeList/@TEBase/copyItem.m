function [] = copyItem(obj,obj2,seqNo,seqNo2)
% ��obj2ѡ���ļ�¼copy��obj1��Ӧλ�ã�����ʽ��
%

if length(seqNo)~=length(seqNo2)
    error('Target and source item number not equal');
end
maxSeqNo = max(seqNo);

if obj.capacity<maxSeqNo
    obj.extend(maxSeqNo-obj.capacity);
end

if obj.latest<maxSeqNo
    obj.latest = maxSeqNo;
end

obj.isSorted = 0;

for i = 1:length(obj.headers)
    obj.(obj.headers{i})(seqNo) = obj2.(obj.headers{i})(seqNo2);
end

end