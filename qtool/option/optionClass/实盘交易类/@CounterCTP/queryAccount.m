function [accountinfo, ret] = queryAccount(self)
%QUERYACCOUNT 在CounterCTP中重新包装函数QueryAccount
% --------------------------
% 朱江，20160712

ctpcounterqryaccount(self.counterId);
pause(1);
[accountinfo,ret] = ctpcounter_getaccountinfo(self.counterId);

if ~ret
    disp('查资金失败');
    return;
end

end


% 
%         -------------资金信息--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006
%         [2]enable_balance_t0	[2]254044.200000
%         [3]enable_balance_t1	[3]254044.200000