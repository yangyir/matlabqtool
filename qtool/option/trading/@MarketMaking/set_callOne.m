function [ callOne ] = set_callOne( obj, iT, K )
%SET_CALLONE ����obj.callOne@OptionOne, ָ�������call��Ȩ��ָ��
% �⣺��Ϊͨ���д��һ����������
% -----------------------
% cg, 20160320

if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end
type = 'call';


iK          = obj.m2tkCallOne.getIdxByPropvalue_X( K );
callOne     = obj.m2tkCallOne.getByIndex(iK, iT);
obj.callOne = callOne;

fprintf('ʹ��%s��%s  [%s]\n', type, callOne.quote.optName,callOne.quote.code);


end

