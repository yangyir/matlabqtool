function place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion)
% 比率委托方式：单张期权的委托
% volume是每个OptStraddleTrading的单位下单数量,proportion是比率下单
% proportion默认是每个等量情形,如果有三个账户则是[1 1 1]
% place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion)
% 吴云峰 20161125
% TODO: place_entrust_opt_equal 和 place_entrust_opt_proportion 统一
% TODO: 命名为place_entrust_opt
% TODO: buy_once, sell_once ， 也有proportion和默认proportion
% 注意写log
% 暂时先不删除旧的 place_entrust_opt_equal 和 place_entrust_opt_proportion
%% 默认proportion从obj取
% 如果 obj.proportion 出错（nan, size不等）则默认 [1,1,1] (equal)


% 1，预判断
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('无OptStraddleTrading类别,无法开仓')
    return;
end

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
assert(all(proportion >= 0))




%% main
assert(volume >= 1);
assert(px > 0);


% 2,进行委托下单操作
keys_value      = obj.keys;
entrust_volumes = round(volume * proportion);
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