function [ret] = placeEntrust(obj, e)
%cCounterRH
% 下单 将Entrust层的信息适配至融航的下单接口

counter_id = obj.counterId;
entrust_id = obj.GetAvailableEntrustId();

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
% rh 接口层， direction : 买 1， 卖 2
% rh 接口层,  offset : 开：1， 平昨：2， 平今：3
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

if -1 == e.offsetFlag
    if 0 ~= e.closetodayFlag
        % 有平今平昨区分
        offset = offset + e.closetodayFlag; %调整后平今为3， 平昨为4
    end
end

price = e.price;
amount = e.volume;

[ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);

if ret
    e.entrustNo = sysid;
end

end