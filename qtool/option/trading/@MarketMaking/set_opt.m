function set_optOne(obj, iT, K , type)
% 设置obj.optOne@OptionOne, 指向待交易期权的指针
% 拟：作为通用项，写在一个基本类里
% -----------------------
% cg, 20160320

if ~exist('type', 'var'), type = 'call'; end
if ~exist('iT', 'var'), iT = 1;     end
if ~exist('K','var'), K  = 2;       end

switch type
    case {'call'}
        iK          = obj.m2tkCallOne.getIdxByPropvalue_X( K );
        obj.optOne  = obj.m2tkCallOne.getByIndex(iK, iT);
    case {'put'}
        iK          = obj.m2tkPutOne.getIdxByPropvalue_X( K );
        obj.optOne  = obj.m2tkPutOne.getByIndex(iK, iT);
end

fprintf('使用%s：%s\n', type, obj.optOne.quote.optName);
end