function [ putOne ] = set_putOne( obj, iT, K )
%SET_PUTONE ����obj.putOne@OptionOne, ָ�������put��Ȩ��ָ��
% �⣺��Ϊͨ���д��һ����������
% -----------------------
% cg, 20160320

type = 'put';
if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end


iK          = obj.m2tkPutOne.getIdxByPropvalue_X( K );
putOne      = obj.m2tkPutOne.getByIndex(iK, iT);
obj.putOne  = putOne;


fprintf('ʹ��%s��%s  [%s]\n', type, putOne.quote.optName, putOne.quote.code);


end

