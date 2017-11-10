function place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion)
% ����ί�з�ʽ��������Ȩ��ί��
% volume��ÿ��OptStraddleTrading�ĵ�λ�µ�����,proportion�Ǳ����µ�
% proportionĬ����ÿ����������,����������˻�����[1 1 1]
% place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion)
% ���Ʒ� 20161125
% TODO: place_entrust_opt_equal �� place_entrust_opt_proportion ͳһ
% TODO: ����Ϊplace_entrust_opt
% TODO: buy_once, sell_once �� Ҳ��proportion��Ĭ��proportion
% ע��дlog
% ��ʱ�Ȳ�ɾ���ɵ� place_entrust_opt_equal �� place_entrust_opt_proportion
%% Ĭ��proportion��objȡ
% ��� obj.proportion ����nan, size���ȣ���Ĭ�� [1,1,1] (equal)


% 1��Ԥ�ж�
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('��OptStraddleTrading���,�޷�����')
    return;
end

if ~exist('proportion', 'var')
    proportion = obj.proportion;
end
if length(proportion) == nCount
    if any(isnan(proportion)) % ���ֵ�ڴ���Nan
        warning('�µ����ʴ���nan,���õȱ����µ�')
        proportion = ones(1, nCount);
        obj.proportion = proportion;
    end
else
    warning('���յȱ����µ�size����,���õȱ����µ�')
    proportion = ones(1, nCount);
    obj.proportion = proportion;
end
assert(all(proportion >= 0))




%% main
assert(volume >= 1);
assert(px > 0);


% 2,����ί���µ�����
keys_value      = obj.keys;
entrust_volumes = round(volume * proportion);
for straddle_t = 1:nCount
    optstratrade_object     = get(obj, keys_value{straddle_t});
    % 2.1,��Ҫ:���и�ֵ
    optstratrade_object.opt = obj.opt;
    % 2.2,���в𵥴���
    one_entrust_amount      = entrust_volumes(straddle_t);
    if one_entrust_amount <= 0
        continue;
    end
    % 2.3,���ж��ί���µ�
    optstratrade_object.place_entrust_opt_apart(direc, one_entrust_amount, offset, px);
end








end