function sell_once_proportion(obj, volume, offset, rangbu, proportion)
% 比率期权的sell_once
% sell_once_proportion(obj, volume, offset, rangbu, proportion)
% 吴云峰 20161124

if ~exist('volume','var'),  volume = 1;   end
if ~exist('offset', 'var'), offset = '1'; end
if ~exist('rangbu', 'var'), rangbu = 1;   end
call = obj.call;
put  = obj.put;
if isempty(call) || isempty(put)
    error('call或者put合约为空')
end
direc = '2';


% 1,判断
assert(volume >= 1);
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('无OptStraddleTrading类别,无法开仓')
    return;
end


% 2,配置的比率
if ~exist('proportion', 'var')
    proportion = obj.proportion;
end
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