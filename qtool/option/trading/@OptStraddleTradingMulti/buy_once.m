function buy_once(obj, volume, offset, rangbu)
% buy_once(obj, volume, offset, rangbu)
% 多OptStraddleTrading对象下单操作
% 默认按照proportion进行多个对象下单, volume是单位的下单数量


%% 配置
if ~exist('volume','var'),  volume = 1;   end
if ~exist('offset', 'var'), offset = '1'; end
if ~exist('rangbu', 'var'), rangbu = 1;   end
assert(volume >= 1);
call = obj.call;
put  = obj.put;
if isempty(call) || isempty(put)
    error('call或者put合约为空')
end
direc = '1';


%% 比率配置

% 1，预判断
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('无OptStraddleTrading类别,无法开仓')
    return;
end


% 2，比率的判断
proportion = obj.proportion;
if length(proportion) == nCount
    if any(isnan(proportion)) % 如果值内存在Nan
        warning('下单比率存在nan,设置等比例下单')
        proportion = ones(1, nCount);
        obj.proportion = proportion;
    end
else
    warning('按照等比率下单size不等,设置等比例下单')
    proportion = ones(1, nCount);
    obj.proportion = proportion;
end
proportion = round(proportion);
assert(all(proportion >= 0))



%% 开火下单

% 2,进行委托下单操作
keys_value = obj.keys;
for straddle_t = 1:nCount
    optstratrade_object = get(obj, keys_value{straddle_t});
    if straddle_t == 1
        ctrs  = {optstratrade_object.counter};
        books = optstratrade_object.book;
    else
        ctrs{end + 1}  = optstratrade_object.counter;
        books(end + 1) = optstratrade_object.book;
    end
end
optstratrade_object.openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);









end