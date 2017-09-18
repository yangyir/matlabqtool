function [ bs, sFlag ] = dmBars(code, start_date, end_date, slice_seconds, slice_start, driver)
% 从db取Bars，具体方法是先取Ticks再切Bars，
% 每次只能取一种合约，但切分方式可以有多种
% Code 合约代码如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03')
% start_date为起始时间
% end_date为终止时间
% slice_seconds 表示切片长度，可以是数组如[60,90,120]
% slice_start 表示开始时间，默认是0， 否则要与slice_seconds一一对应
% driver 数据存放的盘符， 此处应该是开发盘盘符， 默认是'Y'

% HeQun 2013.1.22; 初步测试通过，基于IF

%% 预处理
if nargin < 4
    error('取Bar的参数不足！')
elseif nargin < 5
    slice_start = zeros(size(slice_seconds));
    driver = 'Y:\qdata\DayTicks\'; 
elseif nargin < 6
    driver = 'Y:\qdata\DayTicks\'; 
else
    if isempty(slice_start)
        slice_start = zeros(size(slice_seconds));
    end
end

sFlag = 0;


bs =Bars;
startDayNum = datenum(start_date, 'yyyymmdd');
endDayNum   = datenum(end_date, 'yyyymmdd');

%% 第一天，专门处理
firstDay = startDayNum;
for k = startDayNum:endDayNum
    [ bs, successBars ] = dmDayBars(code, datestr(k,'yyyymmdd'), slice_seconds, slice_start, driver);
    firstDay = k;
    
    % 如果成功，还原sec code
    if successBars
        disp(['已经取到',  code, '在' , datestr(k,'yyyymmdd'), '的Bar数据！']);
        sFlag = 1;
        break;
    end
end

%% 第2到n天，取出，加入bs
for k = firstDay+1:endDayNum
    [ bs1, successBars ] = dmDayBars(code, datestr(k,'yyyymmdd'), slice_seconds, slice_start, driver);
    
    if successBars
%         对取数据时改动的证券代码进行还原
        disp(['已经取到',  code, '在' , datestr(k,'yyyymmdd'), '的Bar数据！']);
        
%         对于两个bar进行简单的连接
        for kk = 1:length(bs)
            bs(kk).merge( bs1(kk) );
        end
    end
end


end