function [obj] = calcByRound( PTL, mode )

% 潘其超，20140705，V1.0
% 潘其超，20140730，V2.0
%   1. 加入了对空TradeList的处理。
% 潘其超，20140814，V3.0
%   1. 加入了计算模式的选择。R by Round，P by Pair.

if nargin == 1
    mode = 'R';
end

if mode == 'R'
    rStats = PTL.sumRound();
elseif mode == 'P'
    rStats = PTL.sumPair();
end
obj = TradeSum();

if PTL.rcdNum==0
    return;
end
% 盈利 亏损交易索引
winIdx  = rStats.pnl>0;
losIdx  = rStats.pnl<0;
longIdx = rStats.direction==1;
shortIdx =rStats.direction==-1;

% 交易次数
obj.TradeNum = rStats.roundNum;
obj.WinNum  = sum(winIdx);
obj.LoseNum = sum(losIdx);
obj.LongNum = sum(longIdx);
obj.ShortNum = sum(shortIdx);
obj.LongWinNum  = sum(winIdx&longIdx);
obj.LongLoseNum = sum(losIdx&longIdx);
obj.ShortWinNum = sum(winIdx&shortIdx);
obj.ShortLoseNum = sum(losIdx&shortIdx);

% 交易量
obj.TradeVol     = sum(rStats.volume);
obj.WinVol       = sum(rStats.volume(winIdx));
obj.LoseVol      = sum(rStats.volume(losIdx));
obj.LongVol      = sum(rStats.volume(longIdx));
obj.ShortVol     = sum(rStats.volume(shortIdx));
obj.LongWinVol   = sum(rStats.volume(winIdx&longIdx));
obj.LongLoseVol  = sum(rStats.volume(losIdx&longIdx));
obj.ShortWinVol  = sum(rStats.volume(winIdx&shortIdx));
obj.ShortLoseVol = sum(rStats.volume(losIdx&shortIdx));


% Commission 是奇偶行都有的
obj.Commission  = sum(rStats.commission);
obj.PNL         = sum(rStats.pnl)-obj.Commission;
obj.Profit      = sum(rStats.pnl(winIdx));
obj.Loss        = sum(rStats.pnl(losIdx));
% 单笔最大盈利亏损
obj.maxSingleProfit = max(rStats.pnl);
obj.maxSingleLoss   = min(rStats.pnl);

% 平均每次盈利，亏损
obj.PPT = obj.Profit/obj.WinNum;
obj.LPT = obj.Loss/obj.LoseNum;

% 胜率，盈亏比
obj.WinRatio    = obj.WinNum/obj.TradeNum;
obj.PLRatio     = -obj.PPT/obj.LPT;

%时间
obj.AvgHoldingPeriod        = sum(rStats.span)/obj.TradeNum;
obj.AvgWinHoldingPeriod     = sum(rStats.span(winIdx))/obj.WinNum;
obj.AvgLoseHoldingPeriod    = sum(rStats.span(losIdx))/obj.LoseNum;
obj.AvgLongHoldingPeriod    = sum(rStats.span(longIdx))/obj.LongNum;
obj.AvgShortHoldingPeriod   = sum(rStats.span(shortIdx))/obj.ShortNum;

% 连亏连赢次数, 此处针对单个合约，函数外是对汇总的计算
obj.calcConWLN(rStats.pnl);

end