 function gainRateExcMaxNpercentRet = gainRateExcMaxNpercentRet(ret,N)
% % �۳����ӯ����������,�������Account�����ʲ��䶯���
         if nargin < 2
             N = 5;
         end;
         [~,I] = sort(ret,'descend');
         I=I(1:round(length(I)*N/100));
         ret(I) = [];
         gainRateExcMaxNpercentRet = prod(ret+1)-1;
     end