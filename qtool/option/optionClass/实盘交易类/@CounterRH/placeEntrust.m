function [ret] = placeEntrust(counter, e)
% [ret] = placeEntrust(counter, e)
% �µ� ��Entrust�����Ϣ������rh_���µ��ӿ�
%--------------------------------
% �콭�� 20160621 first draft

counter_id = counter.counterId;
entrust_id = counter.GetAvailableEntrustId();

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
% rh_ �ӿڲ㣬 direction : �� 1�� �� 2
% rh_ �ӿڲ�,  offset : ����1�� ƽ��2�� ƽ��3
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
multi = e.multiplier;

% �µ�
[ret, sysid] = rh_counter_place_entrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount, multi);

if ret
    e.entrustNo = sysid;
end
end