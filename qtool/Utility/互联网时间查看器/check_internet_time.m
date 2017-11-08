%% ������Windowsƽ̨��
% ����ϵͳ������query ntp �������õ�������ʱ�䡣
function [bret, internet_date] = check_internet_time()
%function [bret, internet_date] = check_internet_time()
bret = false;
internet_date = [];
command = 'w32tm /stripchart /computer:us.pool.ntp.org /dataonly /samples:1';
[status,cmdout] = system(command,'-echo');
if status == 0
    internet_date_cell = regexp(cmdout, '\d\d\d\d[\/\\][\d]+[\/\\][\d]+', 'match');
    bret = true;
    internet_date = internet_date_cell{1};
end

end