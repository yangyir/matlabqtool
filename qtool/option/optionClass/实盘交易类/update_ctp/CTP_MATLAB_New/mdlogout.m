function [] = mdlogout(id)
%[res] = mdlogout()
%-------------------------------------------
% mdlogout �ǳ����顣
% �˴����������裬��������ҽ���һ��ʵ����

if not(libisloaded('CTP_MarketData'))
    return;
end

ctpmdlogout(id);
pause(10);
unloadlibrary('CTP_MarketData');
end