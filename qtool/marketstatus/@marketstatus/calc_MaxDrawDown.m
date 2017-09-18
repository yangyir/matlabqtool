function MaxDrawDown = calc_MaxDrawDown(Account)
% 根据Account时间序列计算maxdrawdown
% version 1.0 wuzehui 2013/7/4
highlevel = Account;
for i=2:length(Account)
    if Account(i)>highlevel(i-1)
        highlevel(i)=Account(i);
    else
        highlevel(i)=highlevel(i-1);
    end
end
DrawDown = (highlevel-Account)./highlevel;
MaxDrawDown = max(DrawDown);
end
        
