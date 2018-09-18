function [tradeArray, ret] = queryTrades(obj)
%cCounterRH
[tradeArray, ret] = ctp_counter_loadtrades(obj.counterId);
end