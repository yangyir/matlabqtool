function [ret] = placeEntrust(counter, e)
% [ret] = placeEntrust(counter, e)
% 下单 将Entrust层的信息适配至ctp的下单接口
%--------------------------------
% 朱江， 20160621 first draft

counter_id = counter.counterId;
entrust_id = counter.GetAvailableEntrustId();

% 填入内部订单编号
e.entrustId = entrust_id;

switch (e.assetType)
    case 'ETF'
        asset_type = 3;
    case 'Option'
        asset_type = 2;
    case 'Future'
        asset_type = 1;
end

code = e.instrumentCode;

% entrust 层， direction 买 1， 卖 -1
% entrust 层， offset 开 1， 平 -1
% ctp 接口层， direction : 买 1， 卖 2
% ctp 接口层,  offset : 开：1， 平昨：2， 平今：3
switch (e.direction)
    case 1
        direction = 1;
    case -1
        direction = 2;
end

switch (e.offsetFlag)
    case 1
        offset = 1;
    case -1
        offset = 2;
end

price = e.price;
amount = e.volume;
multi = e.multiplier;

% 下单
[ret, sysid] = placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount, multi);

if ret
    e.entrustNo = sysid;
end
end