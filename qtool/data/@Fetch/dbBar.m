function [ bs, Sflag ] = dbBar(Code, start_date, end_date, slice_seconds, slice_start)
% 每次只能取一种合约
% Code 为证券代码，股票的如 '600000.SH'， 股指的如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', 主力合约 'IFHot')
% start_date为起始时间
% end_date为终止时间
% slice_seconds 表示切片长度，可以是数组如[60,90,120]
% slice_start 表示开始时间，默认是0， 否则要与slice_seconds一一对应

%HeQun 2013.12.23
if nargin < 4
    error('取Bar的参数不足！')
elseif nargin < 5
    slice_start = 0;
end

bs =Bars;
[DayCode, DayTime] = genContractImfor(Code, start_date, end_date);
if isempty(DayCode)
    Sflag = 0;
    disp('没有当前代码的行情');
    return;
end

startDay = 0;
for k = 1:length(DayCode)
    [ bs, SflagD ] = dbFetchDayBar(DayCode{k}, num2str(DayTime{k}), slice_seconds, slice_start);
    startDay = k;
    if SflagD
        if strcmp(Code, 'IFHot') || strcmp(Code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs(kk).code = Code;
            end
        end
        break;
    end
end

for k = startDay+1:length(DayCode)
    [ bs1, SflagD ] = dbFetchDayBar(DayCode{k}, num2str(DayTime{k}), slice_seconds, slice_start);
    if SflagD
        if strcmp(Code, 'IFHot') || strcmp(Code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs1(kk).code = Code;
            end
        end
        for kk = 1:length(bs)
            bs(kk) = barLink(bs(kk), bs1(kk));
        end
    end
end
Sflag = 1;
end