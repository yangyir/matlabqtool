function place_entrust_opt(obj, direc, volume, offset, px)
% place_entrust_opt(obj, direc, volume, offset, px)
% 多OptStraddleTrading对象下单操作
% 默认按照proportion进行多个对象下单, volume是单位下单数量


%% 
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



% 3,获取对手的价格
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


%% 开火下单
assert(volume >= 1);
assert(px > 0);



% 2,进行委托下单操作
keys_value      = obj.keys;
entrust_volumes = volume*proportion;
for straddle_t = 1:nCount
    optstratrade_object     = get(obj, keys_value{straddle_t});
    % 2.1,重要:进行赋值
    optstratrade_object.opt = obj.opt;
    % 2.2,进行拆单处理
    one_entrust_amount      = entrust_volumes(straddle_t);
    if one_entrust_amount <= 0
        continue;
    end
    % 2.3,进行多次委托下单
    optstratrade_object.place_entrust_opt_apart(direc, one_entrust_amount, offset, px);
end









end