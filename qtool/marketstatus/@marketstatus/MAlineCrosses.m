function CrossInd = MAlineCrosses(bars, period1, period2, period3)
% v1.0 by Yang Xi
% �����������������������������߽������
% ��bars�ļ۸����ݰ���period1, period2 �� period3 �ľ��߽��н��棬
% Ȼ�󷵻ظ���ʱ������Ӧ�Ľ������
fastMA = ind.ma(bars.close, period1);
midMA = ind.ma(bars.close, period2);
slowMA = ind.ma(bars.close, period3);
temp1 = crossOver(fastMA, midMA) + crossUnder(fastMA, midMA);
temp2 = crossOver(fastMA, slowMA) + crossUnder(fastMA, midMA);
temp3 = crossOver(midMA, slowMA) + crossUnder(midMA, slowMA);
CrossInd = temp1 + temp2 + temp3;
end