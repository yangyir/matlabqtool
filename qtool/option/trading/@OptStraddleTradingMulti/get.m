function optstraddletrading_unit = get(obj, optstratrade_name)
% ȡ����Ӧ���Ƶ�OptStraddleTrading
%����
% optstratrade_name��Straddle Trading���������
%���
% optstraddletrading_unit����
% ���Ʒ� 20161124


optstraddletrading_Multi = obj.optstraddletrading_multi;
keys_value = keys(optstraddletrading_Multi);
if ismember(optstratrade_name, keys_value)
    optstraddletrading_unit = optstraddletrading_Multi(optstratrade_name);
else
    warning('OptStraddleTrading���޶�Ӧ������');
    optstraddletrading_unit = [];
end




end