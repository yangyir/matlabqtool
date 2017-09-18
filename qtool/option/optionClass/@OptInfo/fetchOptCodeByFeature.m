function [stockCode, startDate] = fetchOptCodeByFeature(CP, strike, ExpireDate, xlsPath)
%输入参数
% OptHistoryInfo期权合约列表
% CP Call Put
% strike 执行价格
% ExpireDate到期日期 写法 '2016-09'(9月份到期)
%输出参数
% stockCode合约代码
% startDate合约的起始日期
%Demo
% [stockCode, startDate] = OptInfo.fetchOptCodeByFeature( 'call', 2.3, '2016-12')
% [stockCode, startDate] = OptInfo.fetchOptCodeByFeature( 'call', 2.2, '2016-08')
% [stockCode, startDate] = OptInfo.fetchOptCodeByFeature( 'put', 2.2, '2016-08')

%% 数据进行处理

persistent OPT_HISTORY_INFO;
persistent OPT_HISTTORY_CODES;
persistent OPT_HISTTORY_CPS;
persistent OPT_HISTTORY_STRIKES;
persistent OPT_HISTTORY_STARTDATES;
persistent OPT_HISTTORY_EXPIREDATES;

if isempty(OPT_HISTORY_INFO)
    if ~exist('xlsPath', 'var')
        xlsPath = 'OptHistoryInfo.xlsx';
    end
    [~, ~, OPT_HISTORY_INFO] = xlsread(xlsPath);
    OPT_HISTTORY_CODES    = OPT_HISTORY_INFO(:, 1);
    OPT_HISTTORY_CPS      = OPT_HISTORY_INFO(:, 3);
    OPT_HISTTORY_STRIKES     = cell2mat(OPT_HISTORY_INFO(:, 4));
    OPT_HISTTORY_STARTDATES  = OPT_HISTORY_INFO(:, 6);
    OPT_HISTTORY_EXPIREDATES = OPT_HISTORY_INFO(:, 7);
    OPT_HISTTORY_EXPIREDATES = year(OPT_HISTTORY_EXPIREDATES) * 12 + month(OPT_HISTTORY_EXPIREDATES);
end

stockCode = '';
startDate = '';


%% 获取合约

% CP过滤
pred_call = ismember(CP, {'Call', 'call', 'c', 'C', '认购'});
pred_put  = ismember(CP, {'Put' , 'put' , 'p', 'P', '认沽'});
assert(pred_call || pred_put)
if pred_call
    line_cp = strcmp('认购', OPT_HISTTORY_CPS);
else
    line_cp = strcmp('认沽', OPT_HISTTORY_CPS);
end
OptHistoryCodes       = OPT_HISTTORY_CODES(line_cp);
OptHistoryStrikes     = OPT_HISTTORY_STRIKES(line_cp);
OptHistoryStartDates  = OPT_HISTTORY_STARTDATES(line_cp);
OptHistoryExpireDates = OPT_HISTTORY_EXPIREDATES(line_cp);

% Strike过滤
strike_line = abs(OptHistoryStrikes - strike) < 1e-7;
if any(strike_line)
    OptHistoryCodes    = OptHistoryCodes(strike_line);
    OptHistoryStartDates  = OptHistoryStartDates(strike_line);
    OptHistoryExpireDates = OptHistoryExpireDates(strike_line);
else
    return;
end

% Expire过滤
dateVal = year(ExpireDate) * 12 + month(ExpireDate);
expire_line = OptHistoryExpireDates == dateVal;
if any(expire_line)
    stockCode = OptHistoryCodes{expire_line};
    startDate = OptHistoryStartDates{expire_line};
else
    return;
end








end
