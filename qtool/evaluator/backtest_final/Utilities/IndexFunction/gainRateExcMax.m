
 function gainRateExcMaxRet = gainRateExcMax(tradeReturns)
% % �۳����ӯ����������,�������Account�����ʲ��䶯���
[~,I] = max(tradeReturns);
tradeReturns(I) = [];
gainRateExcMaxRet = prod(tradeReturns+1)-1;
end