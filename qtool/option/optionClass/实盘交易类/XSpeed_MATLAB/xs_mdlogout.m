function [] = xs_mdlogout()
%[res] = mdlogout()
%-------------------------------------------
% mdlogout 登出行情。
% 此处有隐含假设，行情端有且仅有一个实例。

if not(libisloaded('XSpeedSECQuoteLib'))
    return;
end

xspeed_mdlogout();
pause(10);
unloadlibrary('XSpeedSECQuoteLib');
end