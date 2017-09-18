function [obj] = calcByRound( PTL, mode )

% ���䳬��20140705��V1.0
% ���䳬��20140730��V2.0
%   1. �����˶Կ�TradeList�Ĵ���
% ���䳬��20140814��V3.0
%   1. �����˼���ģʽ��ѡ��R by Round��P by Pair.

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
% ӯ�� ����������
winIdx  = rStats.pnl>0;
losIdx  = rStats.pnl<0;
longIdx = rStats.direction==1;
shortIdx =rStats.direction==-1;

% ���״���
obj.TradeNum = rStats.roundNum;
obj.WinNum  = sum(winIdx);
obj.LoseNum = sum(losIdx);
obj.LongNum = sum(longIdx);
obj.ShortNum = sum(shortIdx);
obj.LongWinNum  = sum(winIdx&longIdx);
obj.LongLoseNum = sum(losIdx&longIdx);
obj.ShortWinNum = sum(winIdx&shortIdx);
obj.ShortLoseNum = sum(losIdx&shortIdx);

% ������
obj.TradeVol     = sum(rStats.volume);
obj.WinVol       = sum(rStats.volume(winIdx));
obj.LoseVol      = sum(rStats.volume(losIdx));
obj.LongVol      = sum(rStats.volume(longIdx));
obj.ShortVol     = sum(rStats.volume(shortIdx));
obj.LongWinVol   = sum(rStats.volume(winIdx&longIdx));
obj.LongLoseVol  = sum(rStats.volume(losIdx&longIdx));
obj.ShortWinVol  = sum(rStats.volume(winIdx&shortIdx));
obj.ShortLoseVol = sum(rStats.volume(losIdx&shortIdx));


% Commission ����ż�ж��е�
obj.Commission  = sum(rStats.commission);
obj.PNL         = sum(rStats.pnl)-obj.Commission;
obj.Profit      = sum(rStats.pnl(winIdx));
obj.Loss        = sum(rStats.pnl(losIdx));
% �������ӯ������
obj.maxSingleProfit = max(rStats.pnl);
obj.maxSingleLoss   = min(rStats.pnl);

% ƽ��ÿ��ӯ��������
obj.PPT = obj.Profit/obj.WinNum;
obj.LPT = obj.Loss/obj.LoseNum;

% ʤ�ʣ�ӯ����
obj.WinRatio    = obj.WinNum/obj.TradeNum;
obj.PLRatio     = -obj.PPT/obj.LPT;

%ʱ��
obj.AvgHoldingPeriod        = sum(rStats.span)/obj.TradeNum;
obj.AvgWinHoldingPeriod     = sum(rStats.span(winIdx))/obj.WinNum;
obj.AvgLoseHoldingPeriod    = sum(rStats.span(losIdx))/obj.LoseNum;
obj.AvgLongHoldingPeriod    = sum(rStats.span(longIdx))/obj.LongNum;
obj.AvgShortHoldingPeriod   = sum(rStats.span(shortIdx))/obj.ShortNum;

% ������Ӯ����, �˴���Ե�����Լ���������ǶԻ��ܵļ���
obj.calcConWLN(rStats.pnl);

end