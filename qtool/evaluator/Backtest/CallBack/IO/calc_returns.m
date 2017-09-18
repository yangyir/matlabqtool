%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算起始日到截止日间收益率。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function returns = calc_returns(Account,startdate,enddate)
if datenum(Account(1,1))<= datenum(startdate-1) &&datenum(Account(end,1))>=datenum(enddate)
    startdate =datenum(startdate-1);
    account_s = Account(datenum(Account(:,1))== datenum(startdate));
    account_e = Account(datenum(Account(:,1))== datenum(enddate));
    returns = account_e / account_s -1;
end
end

