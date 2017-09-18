function [ret] = placeEntrust(counter, e)
% [ret] = placeEntrust(counter, e)
% �µ� ��Entrust�����Ϣ��������ͨ���µ��ӿ�
%--------------------------------
% �콭�� 20160621 first draft

counter_id = counter.counterId;
entrust_id = counter.GetAvailableEntrustId();

% �����ڲ��������
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

% entrust �㣬 direction �� 1�� �� -1
% entrust �㣬 offset �� 1�� ƽ -1
% ctp �ӿڲ㣬 direction : �� 1�� �� 2
% ctp �ӿڲ�,  offset : ����1�� ƽ��2�� ƽ��3
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

% �µ�
[ret, sysid] = jg_counter_place_entrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);

if ret
    e.entrustNo = sysid;
end
end