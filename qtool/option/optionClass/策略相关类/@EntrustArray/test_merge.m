function [  ] = test_merge(  )
%DEMO 使用例子：Entrust和EntrustArray
% 生成e1，e2， 交错放入ea，排序，合并
% ------------------------------------
% 朱江， 20160224


clear all; rehash

%% 生成一个entrustArray
ea = EntrustArray;

%% 生成一个entrust
e1 = Entrust;
e2 = Entrust;

% 准备下单信息
marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;
offsetFlag = 1;
e1.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount,offsetFlag);
e1.date = today;     e1.date2 = datestr(e1.date);
e1.time = now;       e1.time2 = datestr(e1.time);

% 下单成功后填入entrustNo
e1.entrustNo = 112233;

% 准备下单信息
marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 300;
offsetFlag = -1;

e2.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount,offsetFlag);
e2.date = today;     e2.date2 = datestr(e2.date);
e2.time = now;       e2.time2 = datestr(e2.time);

% 下单成功后填入entrustNo
e2.entrustNo = 112234;


% 把成交反馈填入entrust
% e.fill_entrust_query_packet_HSO32(packet)

%% 在entrustArray里放ｅｎｔｒｕｓｔ
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
end

