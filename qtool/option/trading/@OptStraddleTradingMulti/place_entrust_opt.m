function place_entrust_opt(obj, direc, volume, offset, px)
% place_entrust_opt(obj, direc, volume, offset, px)
% ��OptStraddleTrading�����µ�����
% Ĭ�ϰ���proportion���ж�������µ�, volume�ǵ�λ�µ�����


%% 
% 1��Ԥ�ж�
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('��OptStraddleTrading���,�޷�����')
    return;
end


% 2�����ʵ��ж�
proportion = obj.proportion;
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
proportion = round(proportion);
assert(all(proportion >= 0))



% 3,��ȡ���ֵļ۸�
if ~exist('px', 'var')
    opt = obj.opt;
    opt.fillQuote;
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
    if abs(px) < 1e-6
        fprintf('--------------------��ǰ��Ȩ�۸�Ϊ0,�޷��µ�--------------------\n');
        return;
    else
        fprintf('��Ȩ:%s ί�м۸� %.4f\n', opt.code, px);
    end
else
    assert(px > 0);
end


%% �����µ�
assert(volume >= 1);
assert(px > 0);



% 2,����ί���µ�����
keys_value      = obj.keys;
entrust_volumes = volume*proportion;
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