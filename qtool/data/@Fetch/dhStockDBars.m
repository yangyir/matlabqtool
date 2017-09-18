function [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  )
% 取日度或以上stock bars, 需要利用DataHouse，且只能取stock，etf，指数等（不能取期货）
% [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  )
% 只能切日度或多日度的
% 如果出错，尝试重启DH，再重启matlab
% 程刚， 20150515

%% 前处理
if ~exist('slice_days', 'var') 
    slice_seconds = 1;
end

if ~exist('fuquan', 'var')
    fuquan = 1;
end


try 
    checklogin;  
catch e
    DH;
end

%% main

bs          = Bars;
bs.code     = secID;
bs.type     = 'stock';
bs.slicetype = [num2str(slice_days) 'd'] ;


op      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Open',  fuquan);
cl      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Close', fuquan);
hi      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'High',  fuquan);
lo      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Low',   fuquan);
amnt    = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Amount',fuquan);     %元
vo      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Volume',fuquan);    %股


bs.time     = op(:,1);
bs.open     = op(:,2);
bs.close    = cl(:,2);
bs.high     = hi(:,2);
bs.low      = lo(:,2);
bs.amount   = amnt(:,2);
bs.volume   = vo(:,2);


end

