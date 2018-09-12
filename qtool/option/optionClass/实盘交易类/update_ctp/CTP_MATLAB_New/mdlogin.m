function [ret, id] = mdlogin(addr, broker, investor, pwd, log_path)
%[res] = mdlogin(addr, broker, investor, pwd)
%-------------------------------------------
% mdlogin 载入ctp行情库并登陆行情。
% 其中addr： 协议，行情服务器地址
% broker 券商id
% investor 账户
% pwd  登陆密码
if ~exist('log_path', 'var')
    log_path = '.';
end

if not(libisloaded('CTP_MarketData'))
    [notfound, warnings] = loadlibrary('CTP_MarketData', 'ctp_quote_listener_wrapper.h');
end

[ret, id] = ctpmdlogin(addr, broker, investor, pwd, log_path);
end