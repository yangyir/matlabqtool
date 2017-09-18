function GuppyRatio = GuppyMMA(bars, period1, period2, period3, period4, period5)
% Guppy multiple moving average���������г�״̬ 
% by Xi Yang
% ����bars�ļ۸������period1, period2 �� period3 �ľ���
% ���ù�ʽsum|MAi-MAj|/max|MAi-MAj|����г�״̬������GuppyRatio

MA1 = ind.ma(bars.close, period1,0);
MA2 = ind.ma(bars.close, period2,0);
MA3 = ind.ma(bars.close, period3,0);
MA4 = ind.ma(bars.close, period4,0);
MA5 = ind.ma(bars.close, period5,0);

x1 = abs(MA1-MA2);
x2 = abs(MA1-MA3);
x3 = abs(MA1-MA4);
x4 = abs(MA1-MA5);
x5 = abs(MA2-MA3);
x6 = abs(MA2-MA4);
x7 = abs(MA2-MA5);
x8 = abs(MA3-MA4);
x9 = abs(MA3-MA5);
x10 = abs(MA4-MA5);

GuppyRatio = (x1+x2+x3+x4+x5+x6+x7+x8+x9+x10)./max([x1 x2 x3 x4 x5 x6 x7 x8 x9 x10],[],2);
end