 function loseRateExcMaxNpercentRet = loseRateExcMaxNpercentRet(ret,N)
% % �۳��������������,�������Account�����ʲ��䶯���
         if nargin < 2
             N = 5;
         end;
         [~,I] = sort(ret,'ascend');
         I=I(1:round(size(I,1)*N/100),:);
         ret(I) = [];
         loseRateExcMaxNpercentRet = prod(ret+1)-1;
     end