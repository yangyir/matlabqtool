function [ output_args ] = demo( input_args )
%DEMO 此处显示有关此函数的摘要
%   此处显示详细说明



clear all; rehash


%% 生成一个book
book = Book;

%% 生成一个PositionArray
pa = book.positions;
% pa = PositionArray;

%% 生成一个entrustArray
ea = book.finishedEntrusts;
% ea = EntrustArray;
% load e


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
e.entrustStatus = -1;


%% 把完成的entrust装入book
book.update_finished_entrust(e);


%% 在positionArray里加entrust带来的position
% newp = e.deal_to_position;
% pa.try_merge_ifnot_push(newp);


%% 计算positionArray的M2M
newp = pa.node(1);
% 更新股价
newp.lastpx = 1.3;
newp.bidpx  = 1.29;
newp.askpx  = 1.32;
% 计算M2M
newp.calc_m2mFace_m2mPNL;

% 算整个positionArray的m2mface
pa.calc_m2mFace_m2mPNL

pa.calc_faceCost

%% 计算book的M2M

%% 读入excel
% pa.toExcel
% pa2 = PositionArray;
% 
% filename = 'D:\intern\5.吴云峰\optionStraddleTrading\my_PositionArray.xlsx';
% pa2.loadExcel(filename)

%% 在entrustArray里放ｅｎｔｒｕｓｔ
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


filename = 'D:\intern\5.吴云峰\optionStraddleTrading\my_Book.xlsx';
b2 = Book;
b2.fromExcel(filename)
b2.positions.print









end

