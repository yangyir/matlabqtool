function [] = xs_mdlogout()
%[res] = mdlogout()
%-------------------------------------------
% mdlogout �ǳ����顣
% �˴����������裬��������ҽ���һ��ʵ����

if not(libisloaded('XSpeedSECQuoteLib'))
    return;
end

xspeed_mdlogout();
pause(10);
unloadlibrary('XSpeedSECQuoteLib');
end