function [ret, id] = mdlogin(addr, broker, investor, pwd, log_path)
%[res] = mdlogin(addr, broker, investor, pwd)
%-------------------------------------------
% mdlogin ����ctp����Ⲣ��½���顣
% ����addr�� Э�飬�����������ַ
% broker ȯ��id
% investor �˻�
% pwd  ��½����
if ~exist('log_path', 'var')
    log_path = '.';
end

if not(libisloaded('CTP_MarketData'))
    [notfound, warnings] = loadlibrary('CTP_MarketData', 'ctp_quote_listener_wrapper.h');
end

[ret, id] = ctpmdlogin(addr, broker, investor, pwd, log_path);
end