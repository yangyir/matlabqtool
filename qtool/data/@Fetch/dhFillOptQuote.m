function [ opt_quote] = dhFillOptQuote( opt_quote, query_date, query_time)
% dhOptQuotes 从datahouse取期权时点行情，并且填充QuoteOpt对象
%[ quotes] = dhOptQuotes( optID, query_date, query_time)
%------------------------------------------------------------
% 朱江 20160308

if (~exist('query_time', 'var') || isempty(query_time))
    query_time = '15:00:00.000';
end

try 
    checklogin;  
catch e
    DH;
end


% 时间参数：
time = [query_date, ' ',query_time];

CmdArgs = {'OpenPrice', 'ClosePrice', 'Buy1Price', 'Buy1Amount', 'Sell1Price', 'Sell1Amount'};


% 调用DataHouse期权时点行情函数
% 例子：DH_Q_HF_OptionTime('10000404.SH','2016-03-08 10:00:00.000','Buy1Price');



code = [opt_quote.code, '.SH'];
underCode = [opt_quote.underCode, '.SH'];
% under Asset price
% ETF 买一价
% ETF 卖一价
% ETF 均价
underAssetPrice = DH_Q_HF_StockTime(underCode, time,{'Buy1Price','Sell1Price'});
opt_quote.S = mean(underAssetPrice);
% 开盘价
opt_quote.open = DH_Q_HF_OptionTime(code, time, CmdArgs(1));
% 收盘价
opt_quote.close = DH_Q_HF_OptionTime(code, time, CmdArgs(2));
% 买一价
opt_quote.bidP1 = DH_Q_HF_OptionTime(code, time, CmdArgs(3));
% 买一量
opt_quote.bidQ1 = DH_Q_HF_OptionTime(code, time, CmdArgs(4));
% 卖一价
opt_quote.askP1 = DH_Q_HF_OptionTime(code, time, CmdArgs(5));
% 卖一量
opt_quote.askQ1 = DH_Q_HF_OptionTime(code, time, CmdArgs(6));
% DataHouse 没有最新价指标，于是取买一卖一价平均作为最新价
opt_quote.last = (opt_quote.askP1 + opt_quote.bidP1) / 2;


end