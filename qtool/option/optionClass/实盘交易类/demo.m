
% 登陆
c = CounterHSO32.hequn2038_202006;
c.login
c.printInfo


% 查询
c.queryAccount


% 查票
[errorCode,errorMsg,packet] = c.queryCombiStock( '2', '300028');
PrintPacket2(packet);


% 查全部持仓
[errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
PrintPacket2(packet);
R = packet.getRow;  % 0..R-1
i = 2;
fd = packet.setCurrRow(0);
packet.setCurrRow(2)

c.logout

