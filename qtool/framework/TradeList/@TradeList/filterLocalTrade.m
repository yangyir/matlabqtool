function filterLocalTrade(obj)
% 去除内部虚拟交易，标识为tradeID == 0
idx = obj.tradeID(1:obj.latest) == 0;
if isempty(idx)
    return;
end

obj.rmvItem(find(idx));%#ok<FNDSB>
end