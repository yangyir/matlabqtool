function entrust_amounts = equal_allocation_amount(obj, volume)
% 数量平均分配的函数
%输入：委托的数量 volume
%输出：平均分摊的数量 entrust_amounts
% 吴云峰 20161124 


% 1,判断数量
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    entrust_amounts = nan;
    return;
end


% 2,进行数量的分配
entrust_amounts = zeros(1, nCount);
avg_amount      = volume/nCount;
for straddle_t = 1:nCount
    res_amount = volume - sum(entrust_amounts);
    if res_amount < 1e-6
        break;
    end
    if mod(straddle_t, 2)
        this_entrust_amount = ceil(avg_amount);
    else
        this_entrust_amount = floor(avg_amount);
    end
    if this_entrust_amount <= res_amount
        entrust_amounts(straddle_t) = this_entrust_amount;
    else
        entrust_amounts(straddle_t) = res_amount;
    end
end









end