function [ barNum ] = getBarbyNum(obj, dateNum )
%getBarbyNum 根据dateNum获得该日期后的第一根bar的编号
%   dateNum 日期数字
%   ver 1.0， by 张航， 2013/05/08
left = 1;
right = length(obj.time);
if dateNum > obj.time(right)
    error('date out of range');
end
% 二分查找
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

