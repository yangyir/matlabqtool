function [] = prune(obj)
% prune 截去obj.latest之后的部分
% 潘其超，140801

if obj.latest==length(obj.time)
    return;
elseif obj.latest>length(obj.time)
    error('Bad Ticks!');
end

obj.high(obj.latest+1:end)    = [];
obj.low(obj.latest+1:end)     = [];
obj.time(obj.latest+1:end)    = [];
obj.time2(obj.latest+1:end)   = [];
obj.last(obj.latest+1:end)    = [];
obj.volume(obj.latest+1:end)  = [];
obj.amount(obj.latest+1:end)  = [];
obj.openInt(obj.latest+1:end) = [];

obj.bidP(obj.latest+1:end,:) = [];
obj.bidV(obj.latest+1:end,:) = [];
obj.askP(obj.latest+1:end,:) = [];
obj.askV(obj.latest+1:end,:) = [];
end

