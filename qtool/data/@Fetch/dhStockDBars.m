function [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  )
% ȡ�նȻ�����stock bars, ��Ҫ����DataHouse����ֻ��ȡstock��etf��ָ���ȣ�����ȡ�ڻ���
% [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  )
% ֻ�����նȻ���նȵ�
% ���������������DH��������matlab
% �̸գ� 20150515

%% ǰ����
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
amnt    = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Amount',fuquan);     %Ԫ
vo      = DH_Q_PR_StockSerial(secID, start_date, end_date, 'Volume',fuquan);    %��


bs.time     = op(:,1);
bs.open     = op(:,2);
bs.close    = cl(:,2);
bs.high     = hi(:,2);
bs.low      = lo(:,2);
bs.amount   = amnt(:,2);
bs.volume   = vo(:,2);


end

