function [ barNum ] = getBarbyNum(obj, dateNum )
%getBarbyNum ����dateNum��ø����ں�ĵ�һ��bar�ı��
%   dateNum ��������
%   ver 1.0�� by �ź��� 2013/05/08
left = 1;
right = length(obj.time);
if dateNum > obj.time(right)
    error('date out of range');
end
% ���ֲ���
while left < right - 1
    mid = floor((left + right) /2 );
    temp = obj.time(mid);
    if temp >= dateNum
        right = mid;
    else
        left = mid;
    end
end
if dateNum <= obj.time(left)
    barNum =  left;
else
    barNum = right;
end
end

