function set_opt(obj, iT, K , type)
% 设置obj.opt@QuoteOpt, 指向待交易期权的行情指针
% 拟：作为通用项，写在一个基本类里
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

fprintf('使用%s：%s\n', type, obj.put.optName);
end