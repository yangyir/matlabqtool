function [ret] = xs_mdlogin(addr, investor, pwd, logfile)
%[res] = mdlogin(addr, investor, pwd, logfile)
%-------------------------------------------
% mdlogin ����ctp����Ⲣ��½���顣
% ����addr�� Э�飬�����������ַ
% investor �˻�
% pwd  ��½����
% logfile ����ģ��log

if not(libisloaded('XSpeedSECQuoteLib'))
    [notfound, warnings] = loadlibrary('XSpeedSECQuoteLib', 'xspeed_quote_listener_wrapper.h');
end

ret = xspeed_mdlogin(addr, investor, pwd, logfile);
end