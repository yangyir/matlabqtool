function [newObj] = slctByItem(obj,seqNo)
%�����䳬,20140725,V1.0
%  ���䳬,20140807,V2.0
%    1. ��TradeListǨ�Ƶ�TEBase�������޸ģ������඼����ʹ�á�

numRcd = length(seqNo);
if numRcd ==0
    newObj = eval([class(obj) '(0)']);
    return;
end

newObj = eval([class(obj) '(numRcd)']);
newObj.latest = numRcd;



for i = 1:length(obj.headers)
    newObj.(newObj.headers{i})= obj.(obj.headers{i})(seqNo);
end
end