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

% ��ȫ���ֲ�
% [errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
% PrintPacket2(packet);
% R = packet.getRow;  % 0..R-1
% i = 2;
% fd = packet.setCurrRow(0);
% packet.setCurrRow(2)

% ��ɽ�
% [errorCode,errorMsg,packet] = c.queryDeals(0);
% PrintPacket2(packet);

%% ��Ȩ��ص�
% ���ʽ�
[accout, ret] = c.queryAccount();

pause(1);
% ��ֲ�
[positions, ret] = c.queryPositions();
% 
% % ����Ȩ�ɽ�
% [errorCode,errorMsg,packet] = c.queryOptDeals(0);
% PrintPacket2(packet);
% 
% 
% 
% % ���ֽ�
% cash = c.queryCash;
% 
% 
% pause(5);


c.logout
c.printInfo;




end

