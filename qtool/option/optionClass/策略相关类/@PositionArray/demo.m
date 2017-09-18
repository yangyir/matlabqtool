function [  ] = demo(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clear all; rehash


%% ����һ��PositionArray
pa = PositionArray;




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
% �����Ӿͻᱨ��
e.entrustStatus = -1;

%% ����ɵ�entrustת��position
newp = e.deal_to_position;
newp.print; 

%% ��positionArray�����position
pa.try_merge_ifnot_push(newp);
pa.print;

pa.try_merge_ifnot_push(newp);
pa.print;

%% ����positionArray��M2M
newp = pa.node(1);
% ���¹ɼ�
newp.lastpx = 1.3;
newp.bidpx  = 1.29;
newp.askpx  = 1.32;
% ����M2M
newp.calc_m2mFace_m2mPNL;
newp.print;

% ������positionArray��m2mface
pa.calc_m2mFace_m2mPNL;
pa.calc_faceCost;

pa.print;


%% ���excel
pa.toExcel


%% ����excel
pa2 = PositionArray;
pa2.print;
filename = 'my_PositionArray.xlsx';
pa2.loadExcel(filename);
pa2.print





end

