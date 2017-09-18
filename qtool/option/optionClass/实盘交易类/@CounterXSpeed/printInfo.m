function [ txt ] = printInfo( self )
%PRINTINFO Êä³ö
% --------------------------
% ³Ì¸Õ£¬20160201

txt = sprintf('Counter Info:\n');
txt = sprintf('%sCounter Type = %s\n',txt, self.counterType);
txt = sprintf('%sServerAddr = %s\n',txt, self.serverAddr);
txt = sprintf('%sInvestor = %s:%s\n',txt, self.investor, self.investorPassword);
txt = sprintf('%sIsLoggedin = %d\n', txt, self.is_Counter_Login);
txt = sprintf('%sCounterID = %d\n', txt, self.counterId);
txt = sprintf('%sLogFile = %s\n',txt, self.logfile);

if nargout == 0
disp(txt);
end

end

