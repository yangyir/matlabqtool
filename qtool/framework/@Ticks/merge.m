function [obj] = merge(obj,ts2)
% 简单的连接两个Tick数据， 不检查时间顺序
% HeQun, 20131224

% 判断是同一类型的数据后直接连接
if strcmp(obj.code, ts2.code) && strcmp(obj.type, ts2.type) && obj.levels == ts2.levels
%     obj.dt          = [obj.dt;ts2.dt];
    obj.open        = [obj.open;ts2.open];
    obj.high        = [obj.high;ts2.high];
    obj.low         = [obj.low;ts2.low];
    obj.close       = [obj.close;ts2.close];
    obj.dayVolume   = [obj.dayVolume;ts2.dayVolume];
    obj.dayAmount   = [obj.dayAmount;ts2.dayAmount];
    obj.preSettlement = [obj.preSettlement;ts2.preSettlement];
    obj.time        = [obj.time;ts2.time];
    obj.time2       = [obj.time2;ts2.time2];
    obj.last        = [obj.last;ts2.last];
    obj.volume      = [obj.volume;ts2.volume];
    obj.amount      = [obj.amount;ts2.amount];
    obj.openInt     = [obj.openInt;ts2.openInt];
    obj.bidP        = [obj.bidP;ts2.bidP];
    obj.bidV        = [obj.bidV;ts2.bidV];
    obj.askP        = [obj.askP;ts2.askP];
    obj.askV        = [obj.askV;ts2.askV];
else
    error('证券类型不一样！');
end
end