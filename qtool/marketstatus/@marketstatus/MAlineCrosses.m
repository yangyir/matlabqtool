function CrossInd = MAlineCrosses(bars, period1, period2, period3)
% v1.0 by Yang Xi
% 本函数用来算各个点包含的三条均线交叉点数
% 将bars的价格数据按照period1, period2 和 period3 的均线进行交叉，
% 然后返回各个时间所对应的交叉点数
fastMA = ind.ma(bars.close, period1);
midMA = ind.ma(bars.close, period2);
slowMA = ind.ma(bars.close, period3);
temp1 = crossOver(fastMA, midMA) + crossUnder(fastMA, midMA);
temp2 = crossOver(fastMA, slowMA) + crossUnder(fastMA, midMA);
temp3 = crossOver(midMA, slowMA) + crossUnder(midMA, slowMA);
CrossInd = temp1 + temp2 + temp3;
end