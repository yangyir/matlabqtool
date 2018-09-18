function [txt] = printInfo(obj)
%cCounterRH

txt = sprintf('Client Info:\n');
txt = sprintf('%s Type = %s\n',txt, obj.counterType);
txt = sprintf('%sServerAddr = %s\n',txt, obj.serverAddr);
txt = sprintf('%sInvestor = %s:%s\n',txt, obj.investor, obj.investorPassword);
txt = sprintf('%sIsLoggedin = %d\n', txt, obj.is_Counter_Login);
txt = sprintf('%s ID = %d\n', txt, obj.counterId);

if nargout == 0
    disp(txt);
end

end