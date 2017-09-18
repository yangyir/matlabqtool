function [  ] = test_verify_position(  )
%DEMO ʹ�����ӣ�Entrust��EntrustArray
% ����e1��e2�� �������ea�����򣬺ϲ�
% �������PositionArray p1, ��ea�Ƚ�
% ���ɲ���PositionArray p2, ��ea�Ƚ�
%
% ------------------------------------
% �콭�� 20160224


clear all; rehash

%% ����һ��entrustArray
ea = EntrustArray;

%% ����һ��entrust
e1 = Entrust;
e2 = Entrust;

% ׼���µ���Ϣ
marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;
offsetFlag = 1;
e1.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount,offsetFlag);
e1.date = today;     e1.date2 = datestr(e1.date);
e1.time = now;       e1.time2 = datestr(e1.time);

% �µ��ɹ�������entrustNo
e1.entrustNo = 112233;

% ׼���µ���Ϣ
marketNo = '1';
stockCode = 510051;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 300;
offsetFlag = -1;

e2.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount,offsetFlag);
e2.date = today;     e2.date2 = datestr(e2.date);
e2.time = now;       e2.time2 = datestr(e2.time);

% �µ��ɹ�������entrustNo
e2.entrustNo = 112234;


% �ѳɽ���������entrust
% e.fill_entrust_query_packet_HSO32(packet)

%% ��entrustArray��ţ���������
ea.push(e1);
ea.push(e2);
ea.push(e1.getCopy());
ea.push(e2.getCopy());
ea.push(e1.getCopy());
ea.push(e2.getCopy());
ea.push(e1.getCopy());
ea.push(e2.getCopy());

ea.print;

eb = ea.copy();
eb.sort_by_code();
eb.print;

eb.merge_entrusts();
eb.print;


%% ������ȵ�PositionArray p1
position_array_1 = PositionArray;
count = eb.count();
for i = 1:count
    p = eb.node(i).entrust_to_position();
    position_array_1.try_merge_ifnot_push(p);
end

equal = eb.is_equal_to_positions(position_array_1)

%% ���ɲ��ȵ�PositionArray p2
position_array_2 = PositionArray;
ec = ea.copy();
ec.removeByIndex(1);
count_c = ec.count();
for i = 1:count_c
    p = ec.node(i).entrust_to_position();
    position_array_2.try_merge_ifnot_push(p);
end
equal2 = eb.is_equal_to_positions(position_array_2)
end

