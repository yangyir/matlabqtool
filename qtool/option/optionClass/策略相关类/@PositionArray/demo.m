function [  ] = demo(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clear all; rehash


%% 生成一个PositionArray
pa = PositionArray;




%% 生成一个entrust

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

% 把成交反馈填入entrust
% e.fill_entrust_query_packet_HSO32(packet)
e.dealVolume = 200;
e.dealPrice = 1.19;
e.dealAmount = 238;
% 不增加就会报错
e.entrustStatus = -1;

%% 把完成的entrust转成position
newp = e.deal_to_position;
newp.print; 

%% 在positionArray里加入position
pa.try_merge_ifnot_push(newp);
pa.print;

pa.try_merge_ifnot_push(newp);
pa.print;

%% 计算positionArray的M2M
newp = pa.node(1);
% 更新股价
newp.lastpx = 1.3;
newp.bidpx  = 1.29;
newp.askpx  = 1.32;
% 计算M2M
newp.calc_m2mFace_m2mPNL;
newp.print;

% 算整个positionArray的m2mface
pa.calc_m2mFace_m2mPNL;
pa.calc_faceCost;

pa.print;


%% 输出excel
pa.toExcel


%% 读入excel
pa2 = PositionArray;
pa2.print;
filename = 'my_PositionArray.xlsx';
pa2.loadExcel(filename);
pa2.print





end

