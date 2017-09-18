function [ret] = withdrawEntrust(counter, e)
% [ret] = withdrawEntrust(e)
% ³·µ¥
%-------------------------------
% Öì½­£¬ 20160621 first draft

counter_id = counter.counterId;
entrust_id = e.entrustId;

ret = xspeed_withdrawentrust(counter_id, entrust_id);
end