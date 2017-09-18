% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这个函数的作用在于将日期按频率切片。fre可供选项有1日；2周；3月；4季度；5半年；6年。sty
% 可供选项1自然日；2交易日。返回日期是否属于切片后区间截止日期的逻辑数组。
% 输入参数： Day（vector||date），日期序列
%           fre（int），步长，可供选项：1-日；2-周；3-月；4-季；5-半年；6-年。
% 输出参数： output，起始日和截止日始终包含的返回日期是否属于切片后区间截止日期的逻辑数组
%           output2，起始日和截止日未必始终包含的返回日期是否属于切片后区间截止日期的逻辑数组
% 例： [output,output2] = convtoend((datenum（today-100）:datenum(today))',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


function  [output,output2] = convtoend(Day,fre)

if ~isa(Day,'numeric')
    Day =datenum(Day);
end

if size(Day,1) ==1
    error('Not enough data');
else
    switch fre
        case 1
            output = true(length(Day),1);
        case 2
             %  无论交易日还是自然日，每周最后一天是周五。
            output = logical([diff(week_num(Day,7));1]);
        case 3
            output = logical([diff(month(Day));1]);
        case 4
            output = logical([filter1(Day);1]);
        case 5
            output = logical([filter2(Day);1]);
        case 6
            output = logical([diff(year(Day));1]);
        otherwise
            output = true(length(Day),1);
    end
    %  起始日和截止日包含在切片日期中，提高函数复用性。
    output2 =  output;
    output(1,1) = true;
    output(end,1) = true;
end
% 用于查找每个季度最后一天
    function  output1 = filter1(data)
    output1 = (month(data(1:end-1,:)) == 3 & month(data(2:end,:)) == 4) | (month(data(1:end-1,:)) == 6 &month(data(2:end,:)) == 7) ...
        | (month(data(1:end-1,:)) == 9 &month(data(2:end,:)) == 10) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1) ;
    end
 % 用于查找每个半年最后一天   
    function  output2 = filter2(data)
    output2 = (month(data(1:end-1,:)) == 6 & month(data(2:end,:)) == 7) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1);
    end
    
end