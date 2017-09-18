function []= setZero(obj)
% 全部properties都设为0

obj.TradeNum = 0;
obj.WinNum = 0;
obj.LoseNum = 0;
obj.LongNum = 0;
obj.ShortNum=0;
obj.LongWinNum=0;
obj.LongLoseNum=0;
obj.ShortWinNum=0;
obj.ShortLoseNum=0;

obj.TradeVol = 0;
obj.WinVol = 0;
obj.LoseVol = 0;
obj.LongVol = 0;
obj.ShortVol=0;
obj.LongWinVol=0;
obj.LongLoseVol=0;
obj.ShortWinVol=0;
obj.ShortLoseVol=0;

obj.PNL = 0;
obj.Profit = 0;
obj.maxSingleProfit = 0;
obj.Loss = 0;
obj.maxSingleLoss = 0;
obj.PPT = 0;
obj.LPT =0;
obj.WinRatio = 0;
obj.PLRatio = 0;
obj.Commission = 0;

obj.AvgHoldingPeriod=0;
obj.AvgWinHoldingPeriod=0;
obj.AvgLoseHoldingPeriod=0;
obj.AvgLongHoldingPeriod=0;
obj.AvgShortHoldingPeriod=0;


obj.maxConWinNum=0;
obj.maxConLoseNum=0;
obj.annYield=0;
obj.annSharpe=0;

obj.avgSlippage = 0;
end