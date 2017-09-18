function [ obj ] = push( obj, newL2DataRecord )
%PUSH 把一个截面newL2DataRecord压入历史数组obj
%   Detailed explanation goes here


%%
% newL2DataRecord = newL2DataRecord;
t = newL2DataRecord.latest;
if t<1, t=1; end;


%% main

l = obj.latest;
l = l+1;
obj.latest = l;


obj.quoteTime(l)    = newL2DataRecord.quoteTime(t);%     行情时间(s)
obj.dataStatus(l)   = newL2DataRecord.dataStatus(t);%    DataStatus
% obj.secCode(l)      = newL2DataRecord.secCode(t);%证券代码
obj.accDeltaFlag(l) = newL2DataRecord.accDeltaFlag(t);%全量(1)/增量(2)
obj.preSettle(l)    = newL2DataRecord.preSettle(t);%昨日结算价
obj.settle(l)   = newL2DataRecord.settle(t);%今日结算价
obj.open(l)     = newL2DataRecord.open(t);%开盘价
obj.high(l)     = newL2DataRecord.high(t);%最高价
obj.low(l)      = newL2DataRecord.high(t);%最低价
obj.last(l)     = newL2DataRecord.last(t);%最新价
obj.close(l)    = newL2DataRecord.close(t);%收盘价
obj.refP(l)     = newL2DataRecord.refP(t);%动态参考价格
obj.virQ(l)     = newL2DataRecord.virQ(t);%虚拟匹配数量
obj.openInt(l)  = newL2DataRecord.openInt(t);%当前合约未平仓数
obj.bidQ1(l) = newL2DataRecord.bidQ1(t);%申买量1
obj.bidP1(l) = newL2DataRecord.bidP1(t);%申买价1
obj.bidQ2(l) = newL2DataRecord.bidQ2(t);%申买量2
obj.bidP2(l) = newL2DataRecord.bidP2(t);%申买价2
obj.bidQ3(l) = newL2DataRecord.bidQ3(t);%申买量3
obj.bidP3(l) = newL2DataRecord.bidP3(t);%申买价3
obj.bidQ4(l) = newL2DataRecord.bidQ4(t);%申买量4
obj.bidP4(l) = newL2DataRecord.bidP4(t);%申买价4
obj.bidQ5(l) = newL2DataRecord.bidQ5(t);%申买量5
obj.bidP5(l) = newL2DataRecord.bidP5(t);%申买价5
obj.askQ1(l) = newL2DataRecord.askQ1(t);%申卖量1
obj.askP1(l) = newL2DataRecord.askP1(t);%申卖价1
obj.askQ2(l) = newL2DataRecord.askQ2(t);%申卖量2
obj.askP2(l) = newL2DataRecord.askP2(t);%申卖价2
obj.askQ3(l) = newL2DataRecord.askQ3(l) ;%申卖量3
obj.askP3(l) = newL2DataRecord.askP3(t);%申卖价3
obj.askQ4(l) = newL2DataRecord.askQ4(t);%申卖量4
obj.askP4(l) = newL2DataRecord.askP4(t);%申卖价4
obj.askQ5(l) = newL2DataRecord.askQ5(t);%申卖量5
obj.askP5(l) = newL2DataRecord.askP5(t);%申卖价5
obj.volume(l) = newL2DataRecord.volume(t);%成交数量
obj.amount(l) = newL2DataRecord.amount(t);%成交金额
obj.rtflag(l) = newL2DataRecord.rtflag(t);%产品实时阶段标志
obj.mktTime(l) = newL2DataRecord.mktTime(t);%市场时间(0.01s)



%% 
% flds = fields( obj ); 
% 
% 
% 
% 
% for i  =  1: length(flds)
%     fd = flds{i};
% %     if strcmp(fd, 
%     try
%         obj.(fd)(l) = newL2DataRecord.(fd);
%     catch
%         disp(fd);
%     end
%     
% end




end

