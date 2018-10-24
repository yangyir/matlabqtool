function [ret] = queryEntrust(counter, e)
% [ret] = queryEntrust(counter, e)
% 查询委托状态
%---------------------------------
% 朱江 20160621  first draft
counter_id = counter.counterId;
entrust_id = e.entrustId;

[dealinfo] = rh_counter_query_entrust(counter_id, entrust_id);

%         dealVolume@double = 0;     % 成交数目
%         dealAmount;     % 成交金额
%         dealPrice;      % 成交均价
%         dealNum;        % 成交笔数

e.dealVolume = dealinfo(1);
e.dealAmount = dealinfo(2);
e.dealPrice = dealinfo(3);
e.cancelVolume = dealinfo(4);

ret = true;

end