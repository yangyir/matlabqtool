function [ ] = demo(  )
%DEMO CounterHSO32
% 


clear all; rehash;



% c = CounterHSO32.hequn2038_202006;
% c = CounterHSO32.hequntest_2038;
c = CounterHSO32.hequntest_2038_etf;
c.printInfo;


c.login
c.printInfo;

% [errorCode,errorMsg,packet] = c.queryCombiStock('1', '510050');
% if errorCode < 0
%     disp(['查持仓失败。错误信息为:',errorMsg]);
%     return;
% else
%     disp('-------------获得持仓信息--------------');
%     PrintPacket2(packet); %打印持仓信息
% end


% [errorCode,errorMsg,packet] = c.queryAccount()
% PrintPacket2(packet)

[errorCode,errorMsg,packet] = c.queryCombiStock( '2', '300028');
PrintPacket2(packet);

% 查全部持仓
[errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
PrintPacket2(packet);
R = packet.getRow;  % 0..R-1
i = 2;
fd = packet.setCurrRow(0);
packet.setCurrRow(2)


% 查成交
% [errorCode,errorMsg,packet] = c.queryDeals(0);
% PrintPacket2(packet);

%% 期权相关的
% 查期权持仓
[errorCode,errorMsg,packet] = c.queryCombiOpt('','');
PrintPacket2(packet);

% 查期权成交
[errorCode,errorMsg,packet] = c.queryOptDeals(0);
PrintPacket2(packet);

%% 期货相关
[errorCode,errorMsg,packet] = c.queryCombiFuture('','');
PrintPacket2(packet);

% 查现金
cash = c.queryCash;


pause(5);


c.logout
c.printInfo;




end

