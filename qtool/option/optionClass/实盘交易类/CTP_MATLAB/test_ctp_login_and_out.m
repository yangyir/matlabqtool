clear all; rehash;

front_addr_ = 'tcp://125.64.36.26:52213';
broker_id_ = '2001';
investor_id_ = '8880000052';
investor_password_ = '123456';

ret = mdlogin(front_addr_, broker_id_, investor_id_, investor_password_);

if ret
%     a[0] = Asset("180ETF¹º6ÔÂ2905A", "11000613");
%     a[1] = Asset("180ETF¹º6ÔÂ2954A", "11000614");

% getoptquote('11000613');    
% pause(10);
% getoptquote('11000613');
% pause(10);
loop = 100;
while(loop > 0)
[mkt, level, update_time] = getoptquote('11001172');
update_time
loop = loop - 1;
end

pause(10);

mdlogout;
else
    disp('login failed');
end