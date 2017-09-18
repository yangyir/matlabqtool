function  obvVal  = obv( ClosePrice, Volume )
% on-balance volume 
% 输入 close, vol 分别为当日的收盘价以及交易量；
% daniel 2013/4/16

% 预处理
[nPeriod, nAsset]  =  size(ClosePrice);
obvVal  =  zeros(nPeriod, nAsset);

% 计算步
for i = 1:nAsset
    obvVal(:,i)  =  onbalvol( ClosePrice(:,i), Volume(:,i) );
end

end

