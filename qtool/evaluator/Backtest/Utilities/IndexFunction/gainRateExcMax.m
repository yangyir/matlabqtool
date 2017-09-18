
 function gainRateExcMaxRet = gainRateExcMax(tradeReturns)
% % 扣除最大盈利后收益率,输入参数Account是总资产变动情况
[~,I] = max(tradeReturns);
tradeReturns(I) = [];
gainRateExcMaxRet = prod(tradeReturns+1)-1;
end