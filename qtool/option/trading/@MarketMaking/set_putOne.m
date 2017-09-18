function [ putOne ] = set_putOne( obj, iT, K )
%SET_PUTONE 设置obj.putOne@OptionOne, 指向待交易put期权的指针
% 拟：作为通用项，写在一个基本类里
% -----------------------
% cg, 20160320

type = 'put';
if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end


iK          = obj.m2tkPutOne.getIdxByPropvalue_X( K );
putOne      = obj.m2tkPutOne.getByIndex(iK, iT);
obj.putOne  = putOne;


fprintf('使用%s：%s  [%s]\n', type, putOne.quote.optName, putOne.quote.code);


end

