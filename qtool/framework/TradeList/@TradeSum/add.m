function [] = add(obj,obj2)
%用于合并两个统计
% 如果有的域是空的，则无法进行四则运算，会出错

obj.AvgHoldingPeriod    = (obj.AvgHoldingPeriod*obj.TradeNum+obj2.AvgHoldingPeriod*obj2.TradeNum)...
    /(obj.TradeNum+obj2.TradeNum);
obj.AvgLongHoldingPeriod = (obj.AvgLongHoldingPeriod*obj.LongNum+obj2.AvgLongHoldingPeriod*obj2.LongNum)...
    /(obj.LongNum+obj2.LongNum);
obj.AvgShortHoldingPeriod = (obj.AvgShortHoldingPeriod*obj.ShortNum+obj2.AvgShortHoldingPeriod*obj2.ShortNum)...
    /(obj.ShortNum+obj2.ShortNum);
obj.AvgWinHoldingPeriod = (obj.AvgWinHoldingPeriod*obj.WinNum+obj2.AvgWinHoldingPeriod*obj2.WinNum)...
    /(obj.WinNum+obj2.WinNum);
obj.AvgLoseHoldingPeriod = (obj.AvgLoseHoldingPeriod*obj.LoseNum+obj2.AvgLoseHoldingPeriod*obj2.LoseNum)...
    /(obj.LoseNum+obj2.LoseNum);

obj.TradeNum    =  obj.TradeNum+obj2.TradeNum;
obj.WinNum      = obj.WinNum+obj2.WinNum;
obj.LoseNum     = obj.LoseNum+obj2.LoseNum;
obj.LongNum     = obj.LongNum+obj2.LongNum;
obj.ShortNum    = obj.ShortNum+obj2.ShortNum;
obj.LongWinNum  = obj.LongWinNum+obj2.LongWinNum;
obj.ShortWinNum = obj.ShortWinNum+obj2.ShortWinNum;
obj.LongLoseNum = obj.LongLoseNum+obj2.LongLoseNum;
obj.ShortLoseNum = obj.ShortLoseNum+obj2.ShortLoseNum;

obj.TradeVol    =  obj.TradeVol+obj2.TradeVol;
obj.WinVol      = obj.WinVol+obj2.WinVol;
obj.LoseVol     = obj.LoseVol+obj2.LoseVol;
obj.LongVol     = obj.LongVol+obj2.LongVol;
obj.ShortVol    = obj.ShortVol+obj2.ShortVol;
obj.LongWinVol  = obj.LongWinVol+obj2.LongWinVol;
obj.ShortWinVol = obj.ShortWinVol+obj2.ShortWinVol;
obj.LongLoseVol = obj.LongLoseVol+obj2.LongLoseVol;
obj.ShortLoseVol = obj.ShortLoseVol+obj2.ShortLoseVol;


obj.Commission  = obj.Commission+obj2.Commission;
obj.PNL         = obj.PNL+obj2.PNL;
obj.Profit      = obj.Profit+obj2.Profit;
obj.Loss        = obj.Loss+obj2.Loss;
if obj.maxSingleProfit<obj2.maxSingleProfit
    obj.maxSingleProfit = obj2.maxSingleProfit;
end
if obj.maxSingleLoss>obj2.maxSingleLoss
    obj.maxSingleLoss = obj2.maxSingleLoss;
end


obj.PPT         = obj.Profit/obj.WinNum;
obj.LPT         = obj.Loss/obj.LoseNum;
obj.WinRatio    = obj.WinNum/obj.TradeNum;
obj.PLRatio     = -obj.PPT/obj.LPT;

% 连赢连亏，年化收益风险对分表分别计算，但是不加总。
end
