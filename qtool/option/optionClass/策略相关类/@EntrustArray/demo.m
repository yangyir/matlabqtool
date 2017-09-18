function [  ] = demo(  )
%DEMO ʹ�����ӣ�Entrust��EntrustArray
% ����e�� ����ea�����excel
% ------------------------------------
% �̸գ� 20160204


clear all; rehash

%% ����һ��entrustArray
ea = EntrustArray;

%% ����һ��entrust
e = Entrust;

% ׼���µ���Ϣ
marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;
e.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount)
e.date = today;     e.date2 = datestr(e.date);
e.time = now;       e.time2 = datestr(e.time);

% �µ��ɹ�������entrustNo
e.entrustNo = 112233;

% �ѳɽ���������entrust
% e.fill_entrust_query_packet_HSO32(packet)

%% ��entrustArray��ţ���������
ea.push(e);
ea.push(e);
ea.push(e);

%% �������
eb = ea.copy();
eb.removeByIndex(1);
ea.print;
eb.print;

%% ����EntrustArrayֱ�Ӵ�ȡ
ea.node(1).println;
eb.node(1).println;

%% ���
ea.print;
ea.toTable;
ea.toExcel;

%% ��ȡ
ea2 = EntrustArray;
ea2.print;
filename = 'my_EntrustArray.xlsx';
ea2.loadExcel(filename);
ea2.print;


end

