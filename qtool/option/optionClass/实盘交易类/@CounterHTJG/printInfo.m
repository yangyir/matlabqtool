function [ txt ] = printInfo( self )
%PRINTINFO Êä³ö
% --------------------------
% ³Ì¸Õ£¬20160201

txt = sprintf('Counter Info:\n');
txt = sprintf('%sServerAddr = %s\n',txt, self.serverAddr);
txt = sprintf('%sPort = %s\n',txt, self.port);
txt = sprintf('%sInvestor = %s:%s\n',txt, self.investor, self.investorPassword);
txt = sprintf('%sIsLoggedin = %d\n', txt, self.is_Counter_Login);
txt = sprintf('%sCounterID = %d\n', txt, self.counterId);

if nargout == 0
disp(txt);
end

end

