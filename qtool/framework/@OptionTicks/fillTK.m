function [ obj ] = fillTK( obj )
%FILLTK 根据optCode域填写 T，K相关的域
% 时间计算是个难点，没有完全解决
%程刚;140616

%% 前处理
% 这个代码：'510050C1407A1500'
if isempty(obj.optCode)
    disp('错误：缺少optCode');
    return;
end

obj.underCode = str2double( obj.optCode(1:6) );


%% 直读
obj.optType     = obj.optCode(7);
obj.strikeCode  = obj.optCode(13:16);
obj.expCode     = obj.optCode(8:11);
obj.adjustCode  = obj.optCode(12);

% 计算
obj.strike = str2double(obj.strikeCode) / 100;


%% 这里要计算，较复杂

% 个股期权是每月第4个周3
% ETF期权是每月第3个周5
if obj.underCode == 510050 || obj.underCode == 510300
    % ETF期权是每月第3个周5
    obj.expDate = Calendar.nthWeekdayOfMonth(3,'fri',obj.expCode(3:4),obj.expCode(1:2));
else
    % 个股期权是每月第4个周3
    obj.expDate = Calendar.nthWeekdayOfMonth(4,'wed',obj.expCode(3:4),obj.expCode(1:2));
end


obj.expDate2 = datestr(obj.expDate, 'yyyymmdd'); % 到期日，yyyymmdd

obj.naturalT = obj.expDate - obj.date; % 距离到期日多少自然日



%% 这里要计算，较复杂，没有calendar没法算
% obj.tradingT =  Calendar.daysNonWeekend(obj.expDate, obj.date); % 距离到期日多少交易日
        
obj.tradingT =  Calendar.dhDaysTrading(obj.expDate, obj.date, 'sse'); % 距离到期日多少交易日
        

end

