function [bs] = conIntradayBars( secID, start_date, end_date, slice_seconds, config )
% 从DH中取 continuous intraday Bars
% 自动识别证券类型，但是速度慢
% 如是股票，config.fuquan 写明复权方式：1不复权，2后复权，3前复权
% 程刚，20131210

%% 初始化

try 
    checklogin;
catch e
    DH;
end


% 1 A股,2 B股，3 H股，4 指数，5港股；
% 11 普通债券，12 可转换债券；
% 21 封闭式基金，22 ETF基金，23 开放式基金（除ETF）；
% 31 股指期货， 32 商品期货。0 其它证券
% 输入参数，证券代码，为string或者cell型数据;
sectype     = GilSecuType(secID);

bs          = Bars;
% Replay用
slicetype   = int32(slice_seconds*100000);


%% 
switch sectype
  
    case {31, 32}
% 
%         % 名称：商品期货任意频率分时行情
%         % 公式：DH_Q_HF_FutureIrregSlice(期货合约代码,起始日期,截止日期,切片频率)
%         % 描述：返回任意频率商品期货分时数据 
%         %  输出13列,分别为1 时间,2 前收盘,3 开盘价,4 最高价,5 最低价,6 收盘价,7 成交量,
%         % 8 成交额,9 均价,10 持仓量,11 持仓量变化,12 累计最高价,13 累计最低价 
%         % output = DH_Q_HF_FutureIrregSlice('Cu1206','2012-03-01','2012-03-10',600)
%         mat = DH_Q_HF_FutureIrregSlice(secID,start_date,end_date,slice_seconds);
% 
%         bs.code      = secID;
%         bs.type      = 'future';
%         bs.slicetype = slicetype;
%         bs.time      = mat(:,1);
%         bs.open      = mat(:,3);
%         bs.high      = mat(:,4);
%         bs.low       = mat(:,5);
%         bs.close     = mat(:,6);
%         bs.amount    = mat(:,8);
%         bs.volume    = mat(:,7);
%         bs.vwap      = mat(:,9);
%         bs.openInt   = mat(:,11);
        
        bs = Fetch.futureBars(secID, start_date, end_date, slice_seconds);

    case {1,2,3,4,5,21,22,23}
       %%
       try 
           fuquan = config.fuquan;
       catch e
           fuquan = 1;
       end
       
       
%         % SecuCode:char/cell,不支持向量输入。股票代码带相应后缀，股票为.SH/ .SZ
%         % StartDate:numeric/char/cell,不支持向量输入。日期为MATLAB可识别日期
%         % EndDate:numeric/char/cell,不支持向量输入。日期为MATLAB可识别日期
%         % IR:numeric。复权方式，1为不复权，2为向后复权，3为向前复权
%         % Slice:numeric。单位为秒，缺省值为1。
%         % 描述：返回不规则切片数据。返回列:
%         % 1,交易时间(BargainTime);2,前收盘价(PrevClosePrice);3,开盘价(OpenPrice)
%         % 4,最高价(HighPrice);5,最低价(LowPrice);6,收盘价(ClosePrice);
%         % 7,成交量(BargainAmount);8,成交金额(BargainSum);9,成交笔数(TurnoverDeals);
%         % 10,均价(AvgPrice);11,累计最高价(AccuHighPrice);12,累计最低价(AccuLowPrice)。
%         mat = DH_Q_HF_StockIrregSlice(secID, start_date, end_date, fuquan, slice_second);
%         
%         bs.code     = secID;
%         bs.type     = 'stock';
%         bs.slicetype = slicetype;
%         bs.time     = mat(:,1);
%         bs.open     = mat(:,3);
%         bs.close    = mat(:,6);
%         bs.high     = mat(:,4);
%         bs.low      = mat(:,5);
%         bs.amount   = mat(:,8);
%         bs.volume   = mat(:,7);
        
        bs = Fetch.stockBars(secID, start_date. end_date, slice_seconds, fuquan);
    otherwise
        
        disp('不认识的证券名！ 提示：股票要带 .SH .SZ');
        
end

end





