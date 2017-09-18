% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这个函数的作用在于将日期按频率切片。fre可供选项有1日；2周；3月；4季度；5半年；6年。sty
% 可供选项1自然日；2交易日。返回日期是否属于切片后区间起始日期的逻辑数组。
% 输入参数： Day（vector||date），日期序列
%           fre（int），步长，可供选项：1-日；2-周；3-月；4-季；5-半年；6-年。
%           sty (int), 日期类型，可供选项：，1-自然日；2-交易日。
% 输出参数： output，起始日和截止日始终包含的返回日期是否属于切片后区间起始日期的逻辑数组
% 例： output = convtoend((datenum（today-100）:datenum(today))',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  output = convtobegin(Day,fre,sty)

if ~isa(Day,'numeric')
    Day =datenum(Day);
end
switch fre
    case 1
        output = true(length(Day),1);
    case 2
        if sty ==1
            %   自然日，一周为周六到周五，即每周第一天为周六，最后一天是周五。
            output = logical([diff(week_num(Day,1));1]);
        else
            %   交易日，一周为周一到周五，即每周第一天为周一，最后一天是周五。
            output = logical([1;diff(week_num(Day,1))]);
        end
    case 3
        output = logical([1;diff(month(Day))]);
    case 4
        output = logical([1;filter1(Day)]);
    case 5
        output = logical([1;filter2(Day)]);
    case 6
        output = logical([1;diff(year(Day))]);
    otherwise
        output = true(length(Day),1);
end
%  起始日和截止日包含在切片日期中，提高函数复用性。
output(1,1) = true;
output(end,1) = true;
% 用于查找每个季度最后一天
    function  output1 = filter1(data)
        output1 = (month(data(1:end-1,:)) == 3 & month(data(2:end,:)) == 4) | (month(data(1:end-1,:)) == 6 &month(data(2:end,:)) == 7) ...
            | (month(data(1:end-1,:)) == 9 &month(data(2:end,:)) == 10) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1) ;
    end
% 用于查找每半年的最后一天
    function  output2 = filter2(data)
        output2 = (month(data(1:end-1,:)) == 6 & month(data(2:end,:)) == 7) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1);
    end

end