function [c] = set_call(obj, iT, K_call)
% ������quote���ó�����Ҫ��call
if ~exist('iT', 'var'), iT = 1;             end
if ~exist('K_call','var'), K_call  = 2;     end

iK  = obj.m2tkCallQuote.getIdxByPropvalue_X( K_call );
c   = obj.m2tkCallQuote.getByIndex(iK, iT);
obj.call = c;
fprintf('ʹ��call��%s\n', obj.call.optName);
end