function filterLocalTrade(obj)
% ȥ���ڲ����⽻�ף���ʶΪtradeID == 0
idx = obj.tradeID(1:obj.latest) == 0;
if isempty(idx)
    return;
end

obj.rmvItem(find(idx));%#ok<FNDSB>
end