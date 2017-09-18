function [self] = fillHistoricalQuote(self, day)
%function [self] = fillHistoricalQuote(self, day)
% 取day日的高开低收量, 取结算价，取S的收盘价格为S
% TODO: replace dummy code to DH implementation.
       self.preClose = 1;
       self.preSettle = 2;
       self.open = 3; %开盘价	
       self.high = 4; %最高价	
       self.low = 2;  %最低价	
       self.close = 4;%收盘价	
       self.volume = 0;
       self.S = 0;
end