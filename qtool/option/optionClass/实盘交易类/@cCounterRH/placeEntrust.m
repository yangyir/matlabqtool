function [ret] = placeEntrust(obj, e)
%cCounterRH
% �µ� ��Entrust�����Ϣ�������ں����µ��ӿ�

counter_id = obj.counterId;
entrust_id = obj.GetAvailableEntrustId();

% �����ڲ��������
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

% entrust �㣬 direction �� 1�� �� -1
% entrust �㣬 offset �� 1�� ƽ -1
% rh �ӿڲ㣬 direction : �� 1�� �� 2
% rh �ӿڲ�,  offset : ����1�� ƽ��2�� ƽ��3
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
        % ��ƽ��ƽ������
        offset = offset + e.closetodayFlag; %������ƽ��Ϊ3�� ƽ��Ϊ4
    end
end

price = e.price;
amount = e.volume;

[ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);

if ret
    e.entrustNo = sysid;
end

end