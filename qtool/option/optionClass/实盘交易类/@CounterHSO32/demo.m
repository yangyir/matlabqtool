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
%     disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%     return;
% else
%     disp('-------------��óֲ���Ϣ--------------');
%     PrintPacket2(packet); %��ӡ�ֲ���Ϣ
% end


% [errorCode,errorMsg,packet] = c.queryAccount()
% PrintPacket2(packet)

[errorCode,errorMsg,packet] = c.queryCombiStock( '2', '300028');
PrintPacket2(packet);

% ��ȫ���ֲ�
[errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
PrintPacket2(packet);
R = packet.getRow;  % 0..R-1
i = 2;
fd = packet.setCurrRow(0);
packet.setCurrRow(2)


% ��ɽ�
% [errorCode,errorMsg,packet] = c.queryDeals(0);
% PrintPacket2(packet);

%% ��Ȩ��ص�
% ����Ȩ�ֲ�
[errorCode,errorMsg,packet] = c.queryCombiOpt('','');
PrintPacket2(packet);

% ����Ȩ�ɽ�
[errorCode,errorMsg,packet] = c.queryOptDeals(0);
PrintPacket2(packet);

%% �ڻ����
[errorCode,errorMsg,packet] = c.queryCombiFuture('','');
PrintPacket2(packet);

% ���ֽ�
cash = c.queryCash;


pause(5);


c.logout
c.printInfo;




end

