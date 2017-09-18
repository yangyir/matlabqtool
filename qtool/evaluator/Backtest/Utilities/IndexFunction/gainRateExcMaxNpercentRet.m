 function gainRateExcMaxNpercentRet = gainRateExcMaxNpercentRet(ret,N)
% % 扣除最大盈利后收益率,输入参数Account是总资产变动情况
         if nargin < 2
             N = 5;
         end;
         [~,I] = sort(ret,'descend');
         I=I(1:round(length(I)*N/100));
         ret(I) = [];
         gainRateExcMaxNpercentRet = prod(ret+1)-1;
     end