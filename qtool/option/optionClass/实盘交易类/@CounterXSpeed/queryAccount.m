function [accountinfo, ret] = queryAccount(self)
%QUERYACCOUNT 在CounterXSpeed中重新包装函数QueryAccount
% --------------------------
% 朱江，20160712
xspeed_query_fund_and_position(self.counterId);
pause(1);
switch self.counterType
    case 'ETF'
        [accountinfo,ret] = xspeed_getstkaccount(self.counterId);
    case 'Option'
        [accountinfo,ret] = xspeed_getoptaccount(self.counterId);
end

if ~ret
    disp('查资金失败');
    return;
end

end