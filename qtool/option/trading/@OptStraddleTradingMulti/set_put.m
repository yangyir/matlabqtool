function [p] =  set_put(obj, iT, K_put)
% ������quote���ó�����Ҫ��put
if ~exist('iT', 'var'), iT = 1;             end
if ~exist('K_put','var'), K_put  = 2;       end

iK = obj.m2tkPutQuote.getIdxByPropvalue_X( K_put );
p  = obj.m2tkPutQuote.getByIndex(iK, iT);
obj.put = p;
fprintf('ʹ��put��%s\n', obj.put.optName);
end