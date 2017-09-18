function [ret] = xs_mdlogin(addr, investor, pwd, logfile)
%[res] = mdlogin(addr, investor, pwd, logfile)
%-------------------------------------------
% mdlogin 载入ctp行情库并登陆行情。
% 其中addr： 协议，行情服务器地址
% investor 账户
% pwd  登陆密码
% logfile 行情模块log

if not(libisloaded('XSpeedSECQuoteLib'))
    [notfound, warnings] = loadlibrary('XSpeedSECQuoteLib', 'xspeed_quote_listener_wrapper.h');
end

ret = xspeed_mdlogin(addr, investor, pwd, logfile);
end