function [accountinfo, ret] = queryAccount(self)
%QUERYACCOUNT ��Counterrh_�����°�װ����QueryAccount
% --------------------------
% �콭��20160712

rh_counter_qryaccount(self.counterId);
pause(1);
[accountinfo,ret] = rh_counter_getaccountinfo(self.counterId);

if ~ret
    disp('���ʽ�ʧ��');
    return;
end

end


% 
%         -------------�ʽ���Ϣ--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006
%         [2]enable_balance_t0	[2]254044.200000
%         [3]enable_balance_t1	[3]254044.200000