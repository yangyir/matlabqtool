function [accountinfo, ret] = queryAccount(self)
%QUERYACCOUNT ��CounterXSpeed�����°�װ����QueryAccount
% --------------------------
% �콭��20160712
xspeed_query_fund_and_position(self.counterId);
pause(1);
switch self.counterType
    case 'ETF'
        [accountinfo,ret] = xspeed_getstkaccount(self.counterId);
    case 'Option'
        [accountinfo,ret] = xspeed_getoptaccount(self.counterId);
end

if ~ret
    disp('���ʽ�ʧ��');
    return;
end

end