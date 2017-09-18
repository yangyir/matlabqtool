function buy_once_equal(obj, volume, offset, rangbu)
% 等量期权的buy_once
% buy_once_equal(obj, volume, offset, rangbu)
% 吴云峰 20161124

if ~exist('volume','var'),  volume = 1;   end
if ~exist('offset', 'var'), offset = '1'; end
if ~exist('rangbu', 'var'), rangbu = 1;   end
direc = '1';
call = obj.call;
put  = obj.put;
if isempty(call) || isempty(put)
    error('call或者put合约为空')
end


% 1,配置
assert(volume >= 1);
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('无OptStraddleTrading类别,无法开仓')
    return;
end


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
proportion = ones(1, nCount);
optstratrade_object.openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);









end