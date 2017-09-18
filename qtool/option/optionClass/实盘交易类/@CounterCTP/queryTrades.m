function [tradeArray, ret] = queryTrades(self)
% [tradeArray, ret] = queryTrades(self);

[tradeArray, ret] = ctp_counter_loadtrades(self.counterId);
end