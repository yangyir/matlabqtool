function [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan )
% 取stock bars, 需要利用DataHouse，且只能取stock，etf，指数等（不能取期货）
% [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan )
% 如果出错，尝试重启DH，再重启matlab
% 程刚， 20131210


%% 前处理
if ~exist('slice_seconds', 'var') 
    slice_seconds = 60;
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
% Replay用
slicetype   = int32(slice_seconds*100000);


% SecuCode:char/cell,不支持向量输入。股票代码带相应后缀，股票为.SH/ .SZ
% StartDate:numeric/char/cell,不支持向量输入。日期为MATLAB可识别日期
% EndDate:numeric/char/cell,不支持向量输入。日期为MATLAB可识别日期
% IR:numeric。复权方式，1为不复权，2为向后复权，3为向前复权
% Slice:numeric。单位为秒，缺省值为1。
% 描述：返回不规则切片数据。返回列:
% 1,交易时间(BargainTime);2,前收盘价(PrevClosePrice);3,开盘价(OpenPrice)
% 4,最高价(HighPrice);5,最低价(LowPrice);6,收盘价(ClosePrice);
% 7,成交量(BargainAmount);8,成交金额(BargainSum);9,成交笔数(TurnoverDeals);
% 10,均价(AvgPrice);11,累计最高价(AccuHighPrice);12,累计最低价(AccuLowPrice)。
mat = DH_Q_HF_StockIrregSlice(secID, start_date, end_date, fuquan, slice_seconds);

% if isnan(mat)
%     disp('错误：no data');
%     return;
% end

if isempty(mat) 
    disp('错误：no data');
    return;
end

if sum(sum(isnan(mat))) == size(mat,1)*size(mat,2)
    disp('错误：no data');
    return;
end


bs.code     = secID;
bs.type     = 'stock';
bs.slicetype = slicetype;
bs.time     = mat(:,1);
bs.open     = mat(:,3);
bs.close    = mat(:,6);
bs.high     = mat(:,4);
bs.low      = mat(:,5);
bs.amount   = mat(:,8);     %元
bs.volume   = mat(:,7);     %股
        

end

