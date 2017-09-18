function place_entrust_opt_equal(obj, direc, volume, offset, px)
% 等量委托方式：单张期权的委托
% volume是每个OptStraddleTrading的下单数量
% place_entrust_opt_equal(obj, direc, volume, offset, px)
% 吴云峰 20161124


% 1，OptStraddleTrading的数量
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('无OptStraddleTrading类别,无法开仓')
    return;
end
assert(volume >= 1);


% 1.2,获取价格[默认取对手价格]
if ~exist('px', 'var')
    opt = obj.opt;
    opt.fillQuote;
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
    if abs(px) < 1e-6
        fprintf('--------------------当前期权价格为0,无法下单--------------------\n');
        return;
    else
        fprintf('期权:%s 委托价格 %.4f\n', opt.code, px);
    end
else
    assert(px > 0);
end


% 2,进行委托下单操作
keys_value = obj.keys;
for straddle_t = 1:nCount
    optstratrade_object     = get(obj, keys_value{straddle_t});
    % 2.1,重要:进行赋值
    optstratrade_object.opt = obj.opt;
    % 2.2,进行委托下单
    optstratrade_object.place_entrust_opt_apart(direc, volume, offset, px)
end








end