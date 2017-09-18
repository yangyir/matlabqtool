function [ output_args ] = demo( input_args )
%DEMO �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��



clear all; rehash


%% ����һ��book
book = Book;

%% ����һ��PositionArray
pa = book.positions;
% pa = PositionArray;

%% ����һ��entrustArray
ea = book.finishedEntrusts;
% ea = EntrustArray;
% load e


%% ����һ��entrust

e = Entrust;

marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;

e.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount)
e.date = today;     e.date2 = datestr(e.date);
e.time = now;       e.time2 = datestr(e.time);

e.entrustNo = 112233;

% �ѳɽ���������entrust
% e.fill_entrust_query_packet_HSO32(packet)
e.dealVolume = 200;
e.dealPrice = 1.19;
e.dealAmount = 238;
e.entrustStatus = -1;


%% ����ɵ�entrustװ��book
book.update_finished_entrust(e);


%% ��positionArray���entrust������position
% newp = e.deal_to_position;
% pa.try_merge_ifnot_push(newp);


%% ����positionArray��M2M
newp = pa.node(1);
% ���¹ɼ�
newp.lastpx = 1.3;
newp.bidpx  = 1.29;
newp.askpx  = 1.32;
% ����M2M
newp.calc_m2mFace_m2mPNL;

% ������positionArray��m2mface
pa.calc_m2mFace_m2mPNL

pa.calc_faceCost

%% ����book��M2M

%% ����excel
% pa.toExcel
% pa2 = PositionArray;
% 
% filename = 'D:\intern\5.���Ʒ�\optionStraddleTrading\my_PositionArray.xlsx';
% pa2.loadExcel(filename)

%% ��entrustArray��ţ���������
% ea.push(e);
% ea.push(e);
% ea.push(e);
% ea.push(e);
% ea.push(e);
% 
% 
% ea.toTable;
% fn = ea.toExcel;
% 
% 
% ea2= EntrustArray;
% ea2.loadExcel(fn, 'data');


%% book
book.finishedEntrusts.push(e);
book.finishedEntrusts.push(e);
book.finishedEntrusts.push(e);

book.positions.try_merge_ifnot_push(newp);
book.positions.try_merge_ifnot_push(newp);
book.positions.try_merge_ifnot_push(newp);

book.toExcel()
t  = book.positions.print;
book.finishedEntrusts.print


filename = 'D:\intern\5.���Ʒ�\optionStraddleTrading\my_Book.xlsx';
b2 = Book;
b2.fromExcel(filename)
b2.positions.print









end

