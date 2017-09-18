function [ barNum ] = getBarbyDate( obj, year, month, day )
%getBarbyDate ����ʱ�䣨�����գ�����ȡ�ڴ�ʱ����ĵ�һ��Bar�ı��
%   year��month��day�������գ�Ĭ��Ϊ1
%   ver 1.0, by zhanghang, 2013/05/08


if ~exist('month', 'var'), month = 1; end
if ~exist('day', 'var'), day = 1; end

dateNum = datenum(year, month, day);
left = 1;
right = length(obj.time);
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

