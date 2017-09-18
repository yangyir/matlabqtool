% clear all; rehash;

%¹â´ó²âÊÔ
front_addr_ = 'tcp://101.226.253.121:20915';
investor_id_ = '200100000060';
investor_password_ = '808552';

log_path = 'md_log.log';
ret = xspeed_mdlogin(front_addr_, investor_id_, investor_password_,log_path);

if ret
    loop = 100;
    while(loop > 0)
        [mkt, level, update_time] = xspeed_getoptquote('11001139');
        update_time
        loop = loop - 1;
        pause(1);
    end
end


if ret
    xspeed_mdlogout();
end    