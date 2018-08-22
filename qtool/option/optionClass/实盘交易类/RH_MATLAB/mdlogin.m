function [ret] = mdlogin(addr, broker, investor, pwd)
%[res] = mdlogin(addr, broker, investor, pwd)
%-------------------------------------------
% mdlogin ����ctp����Ⲣ��½���顣
% ����addr�� Э�飬�����������ַ
% broker ȯ��id
% investor �˻�
% pwd  ��½����

if not(libisloaded('CTP_MarketData'))
    [notfound, warnings] = loadlibrary('CTP_MarketData', 'ctp_quote_listener_wrapper.h');
end

ret = ctpmdlogin(addr, broker, investor, pwd);
end