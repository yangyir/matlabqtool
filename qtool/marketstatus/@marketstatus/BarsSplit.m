function newbars = BarsSplit(bars, idx)
% v1.0 by Yang Xi
% ��������ԭ����bars�������idxת�����µ�bars
% bars Ϊԭ����bars
% newbars ���ص���bars
newbars = Bars;
if ~isempty(bars.code)
newbars.code = bars.code;
end;
if ~isempty(bars.type)
newbars.type = bars.type;
end;
if ~isempty(bars.time)
newbars.time = bars.time(idx);
end;
if ~isempty(bars.open)
newbars.open = bars.open(idx);
end;
if ~isempty(bars.high)
newbars.high = bars.high(idx);
end;
if ~isempty(bars.low)
newbars.low = bars.low(idx);
end;
if ~isempty(bars.close)
newbars.close = bars.close(idx);
end;
if ~isempty(bars.vwap)
newbars.vwap = bars.vwap(idx);
end;
if ~isempty(bars.volume)
newbars.volume = bars.volume(idx);
end;
if ~isempty(bars.amount)
newbars.amount = bars.amount(idx);
end;
if ~isempty(bars.openInterest)
newbars.openInterest = bars.openInterest(idx);
end;
if ~isempty(bars.settlement)
newbars.settlement = bars.settlement(idx);
end;
if ~isempty(bars.preSettlement)
newbars.preSettlement = bars.preSettlement(idx);
end;
end
