% % �۳��������������,�������Account�����ʲ��䶯���
     function lossRateExcMaxRet = lossRateExcMax(ret)
         [~,I] = min(ret);
         ret(I) = [];
         lossRateExcMaxRet = prod(ret+1)-1;
     end