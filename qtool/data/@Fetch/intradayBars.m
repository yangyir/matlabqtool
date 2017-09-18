function [ bs ] = intradayBars( secID, dt, slice_seconds, config )
% 取得单一日的日内Bars，日期参数只有一个
% 如是股票，config.fuquan 写明复权方式：1不复权，2后复权，3前复权

% 程刚，20131210

if nargin < 4
    config.fuquan = 1;
end

bs = Fetch.conIntradayBars( secID, dt, dt, slice_seconds, config );


end

