function [] = mdlogout()
%[res] = mdlogout()
%-------------------------------------------
% mdlogout 登出行情。
% 此处有隐含假设，行情端有且仅有一个实例。

if not(libisloaded('CTP_MarketData'))
    return;
end

ctpmdlogout;
pause(10);
unloadlibrary('CTP_MarketData');
end