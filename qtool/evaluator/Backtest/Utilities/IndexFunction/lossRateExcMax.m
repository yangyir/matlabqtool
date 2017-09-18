% % 扣除最大亏损后收益率,输入参数Account是总资产变动情况
     function lossRateExcMaxRet = lossRateExcMax(ret)
         [~,I] = min(ret);
         ret(I) = [];
         lossRateExcMaxRet = prod(ret+1)-1;
     end