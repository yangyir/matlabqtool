function [self] = fillHistoricalQuote(self, day)
%function [self] = fillHistoricalQuote(self, day)
% ȡday�յĸ߿�������, 
% TODO: replace dummy code to DH implementation.
       self.preClose = 1;
       self.preSettle = 2;
       self.open = 3; %���̼�	
       self.high = 4; %��߼�	
       self.low = 2;  %��ͼ�	
       self.close = 4;%���̼�	
       self.volume = 0;
end