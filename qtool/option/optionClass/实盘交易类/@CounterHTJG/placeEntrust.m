function [ret] = placeEntrust(counter, e)
% [ret] = placeEntrust(counter, e)
% 下单 将Entrust层的信息适配至海通的下单接口
%--------------------------------
% 朱江， 20160621 first draft

counter_id = counter.counterId;
entrust_id = counter.GetAvailableEntrustId();

% 填入内部订单编号
e.entrustId = entrust_id;

switch (e.assetType)
    case 'Option'
        asset_type = 2;
    otherwise
        disp('Support Option Only');
        ret = false;
        return;
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

% 下单
[ret, sysid] = jg_counter_place_entrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);

if ret
    e.entrustNo = sysid;
end
end