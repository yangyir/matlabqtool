function [ ] = demo(  )
%DEMO CounterCTP
% 
clear all; rehash;

c = CounterCTP.HuaXiOptTest;
c.printInfo;

c.login
c.printInfo;

% [errorCode,errorMsg,packet] = c.queryCombiStock( '2', '300028');
% PrintPacket2(packet);

% 查全部持仓
% [errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
% PrintPacket2(packet);
% R = packet.getRow;  % 0..R-1
% i = 2;
% fd = packet.setCurrRow(0);
% packet.setCurrRow(2)

% 查成交
% [errorCode,errorMsg,packet] = c.queryDeals(0);
% PrintPacket2(packet);

%% 期权相关的
% 查资金
[accout, ret] = c.queryAccount();

pause(1);
% 查持仓
[positions, ret] = c.queryPositions();
% 
% % 查期权成交
% [errorCode,errorMsg,packet] = c.queryOptDeals(0);
% PrintPacket2(packet);
% 
% 
% 
% % 查现金
% cash = c.queryCash;
% 
% 
% pause(5);


c.logout
c.printInfo;




end

