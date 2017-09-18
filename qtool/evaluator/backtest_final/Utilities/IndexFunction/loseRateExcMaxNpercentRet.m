 function loseRateExcMaxNpercentRet = loseRateExcMaxNpercentRet(ret,N)
% % 扣除最大亏损后收益率,输入参数Account是总资产变动情况
         if nargin < 2
             N = 5;
         end;
         [~,I] = sort(ret,'ascend');
         I=I(1:round(size(I,1)*N/100),:);
         ret(I) = [];
         loseRateExcMaxNpercentRet = prod(ret+1)-1;
     end