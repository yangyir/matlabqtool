function set_opt(obj, iT, K , type)
% ����obj.opt@QuoteOpt, ָ���������Ȩ������ָ��
% �⣺��Ϊͨ���д��һ����������
% -----------------------
% cg, 20160320

if ~exist('type', 'var'), type = 'call'; end
if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end

switch type
    case {'call'}
        iK          = obj.m2tkCallQuote.getIdxByPropvalue_X( K );
        obj.opt     = obj.m2tkCallQuote.getByIndex(iK, iT);
    case {'put'}
        iK          = obj.m2tkPutQuote.getIdxByPropvalue_X( K );
        obj.opt     = obj.m2tkPutQuote.getByIndex(iK, iT);
end

fprintf('ʹ��%s��%s\n', type, obj.put.optName);
end