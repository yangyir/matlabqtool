function [bs] = dhBars( secID, startDate, endDate, sliceSeconds, config )
% 从DH中取 continuous intraday Bars，运用DataHouse，标的普适
% [bs] = dhBars( secID, start_date, end_date, slice_seconds, config )
% 自动识别证券类型，但是速度慢，不推荐使用
% 如是股票，config.fuquan 写明复权方式：1不复权，2后复权，3前复权
% 程刚，20131210
% 程刚, 140711；修正了bug
% 程刚，20151219，加入期权部分


%% 初始化

try 
    checklogin;
catch e
    DH;
end


if ~exist('slice_seconds','var'), sliceSeconds = 60; end


% 1 A股,2 B股，3 H股，4 指数，5港股；
% 11 普通债券，12 可转换债券；
% 21 封闭式基金，22 ETF基金，23 开放式基金（除ETF）；
% 31 股指期货， 32 商品期货。
% 0 其它证券  ( option )
% 输入参数，证券代码，为string或者cell型数据;
sectype     = GilSecuType(secID);

bs          = Bars;
% % Replay用
% slicetype   = int32(sliceSeconds*100000);


%% 
switch sectype
  
    case {31, 32}
    %% 股指期货和商品期货
        bs = Fetch.dhFutureBars(secID, startDate, endDate, sliceSeconds);

    case {1,2,3,4,5,21,22,23,12}
    %%　股票、ＥＴＦ、可转债（12）
       try 
           fuquan = config.fuquan;
       catch e
           fuquan = 1;
       end
         
        bs = Fetch.dhStockBars(secID, startDate, endDate, sliceSeconds, fuquan);
        
    case {0}
        %% 510050.SH是0， option 也是 0， 只好
        L = length(secID);
        
        if L == 9  % 形同 510050.SH,  6+3=9        
            bs = Fetch.dhStockBars(secID, startDate, endDate, sliceSeconds, 1);
        elseif L==11   % 形同10000392.SH， 11位
            bs = Fetch.dhOptionBars(secID, startDate, endDate, sliceSeconds);
        end

    otherwise
        
        disp('不认识的证券名！ 提示：股票要带 .SH .SZ');
        
end

end





