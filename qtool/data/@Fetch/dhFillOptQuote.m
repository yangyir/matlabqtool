function [ opt_quote] = dhFillOptQuote( opt_quote, query_date, query_time)
% dhOptQuotes ��datahouseȡ��Ȩʱ�����飬�������QuoteOpt����
%[ quotes] = dhOptQuotes( optID, query_date, query_time)
%------------------------------------------------------------
% �콭 20160308

if (~exist('query_time', 'var') || isempty(query_time))
    query_time = '15:00:00.000';
end

try 
    checklogin;  
catch e
    DH;
end


% ʱ�������
time = [query_date, ' ',query_time];

CmdArgs = {'OpenPrice', 'ClosePrice', 'Buy1Price', 'Buy1Amount', 'Sell1Price', 'Sell1Amount'};


% ����DataHouse��Ȩʱ�����麯��
% ���ӣ�DH_Q_HF_OptionTime('10000404.SH','2016-03-08 10:00:00.000','Buy1Price');



code = [opt_quote.code, '.SH'];
underCode = [opt_quote.underCode, '.SH'];
% under Asset price
% ETF ��һ��
% ETF ��һ��
% ETF ����
underAssetPrice = DH_Q_HF_StockTime(underCode, time,{'Buy1Price','Sell1Price'});
opt_quote.S = mean(underAssetPrice);
% ���̼�
opt_quote.open = DH_Q_HF_OptionTime(code, time, CmdArgs(1));
% ���̼�
opt_quote.close = DH_Q_HF_OptionTime(code, time, CmdArgs(2));
% ��һ��
opt_quote.bidP1 = DH_Q_HF_OptionTime(code, time, CmdArgs(3));
% ��һ��
opt_quote.bidQ1 = DH_Q_HF_OptionTime(code, time, CmdArgs(4));
% ��һ��
opt_quote.askP1 = DH_Q_HF_OptionTime(code, time, CmdArgs(5));
% ��һ��
opt_quote.askQ1 = DH_Q_HF_OptionTime(code, time, CmdArgs(6));
% DataHouse û�����¼�ָ�꣬����ȡ��һ��һ��ƽ����Ϊ���¼�
opt_quote.last = (opt_quote.askP1 + opt_quote.bidP1) / 2;


end