function [tradeArray, ret] = queryTrades(self)
% [tradeArray, ret] = queryTrades(self);

[tradeArray, ret] = rh_counter_loadtrades(self.counterId);
end