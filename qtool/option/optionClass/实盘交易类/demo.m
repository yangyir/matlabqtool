
% ��½
c = CounterHSO32.hequn2038_202006;
c.login
c.printInfo


% ��ѯ
c.queryAccount


% ��Ʊ
[errorCode,errorMsg,packet] = c.queryCombiStock( '2', '300028');
PrintPacket2(packet);


% ��ȫ���ֲ�
[errorCode,errorMsg,packet] = c.queryCombiStock( '', '');
PrintPacket2(packet);
R = packet.getRow;  % 0..R-1
i = 2;
fd = packet.setCurrRow(0);
packet.setCurrRow(2)

c.logout

