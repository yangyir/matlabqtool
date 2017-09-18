function [ callOne ] = set_callOne( obj, iT, K )
%SET_CALLONE 设置obj.callOne@OptionOne, 指向待交易call期权的指针
% 拟：作为通用项，写在一个基本类里
% -----------------------
% cg, 20160320

if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end
type = 'call';


iK          = obj.m2tkCallOne.getIdxByPropvalue_X( K );
callOne     = obj.m2tkCallOne.getByIndex(iK, iT);
obj.callOne = callOne;

fprintf('使用%s：%s  [%s]\n', type, callOne.quote.optName,callOne.quote.code);


end

