function place_entrust_opt_equal(obj, direc, volume, offset, px)
% ����ί�з�ʽ��������Ȩ��ί��
% volume��ÿ��OptStraddleTrading���µ�����
% place_entrust_opt_equal(obj, direc, volume, offset, px)
% ���Ʒ� 20161124


% 1��OptStraddleTrading������
nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    warning('��OptStraddleTrading���,�޷�����')
    return;
end
assert(volume >= 1);


% 1.2,��ȡ�۸�[Ĭ��ȡ���ּ۸�]
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


% 2,����ί���µ�����
keys_value = obj.keys;
for straddle_t = 1:nCount
    optstratrade_object     = get(obj, keys_value{straddle_t});
    % 2.1,��Ҫ:���и�ֵ
    optstratrade_object.opt = obj.opt;
    % 2.2,����ί���µ�
    optstratrade_object.place_entrust_opt_apart(direc, volume, offset, px)
end








end