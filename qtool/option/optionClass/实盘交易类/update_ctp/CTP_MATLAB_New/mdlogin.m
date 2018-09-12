function [ret] = mdlogin(addr, broker, investor, pwd)
%[res] = mdlogin(addr, broker, investor, pwd)
%-------------------------------------------
% mdlogin 载入ctp行情库并登陆行情。
% 其中addr： 协议，行情服务器地址
% broker 券商id
% investor 账户
% pwd  登陆密码

if not(libisloaded('CTP_MarketData'))
    [notfound, warnings] = loadlibrary('CTP_MarketData', 'ctp_quote_listener_wrapper.h');
end

ret = ctpmdlogin(addr, broker, investor, pwd);
end