function [  ] = demo(  )
%DEMO 使用例子：Entrust和EntrustArray
% 生成e， 放入ea，输出excel
% ------------------------------------
% 程刚， 20160204


clear all; rehash

%% 生成一个entrustArray
ea = EntrustArray;

%% 生成一个entrust
e = Entrust;

% 准备下单信息
marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;
e.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount)
e.date = today;     e.date2 = datestr(e.date);
e.time = now;       e.time2 = datestr(e.time);

% 下单成功后填入entrustNo
e.entrustNo = 112233;

% 把成交反馈填入entrust
% e.fill_entrust_query_packet_HSO32(packet)

%% 在entrustArray里放ｅｎｔｒｕｓｔ
ea.push(e);
ea.push(e);
ea.push(e);

%% 测试深拷贝
eb = ea.copy();
eb.removeByIndex(1);
ea.print;
eb.print;

%% 测试EntrustArray直接存取
ea.node(1).println;
eb.node(1).println;

%% 输出
ea.print;
ea.toTable;
ea.toExcel;

%% 读取
ea2 = EntrustArray;
ea2.print;
filename = 'my_EntrustArray.xlsx';
ea2.loadExcel(filename);
ea2.print;


end

