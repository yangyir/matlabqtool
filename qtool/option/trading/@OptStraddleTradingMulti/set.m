function set(obj, optstratrade_name, optstratrade_node)
% ���optstraddletradingԪ��
%����
% optstratrade_name optstratrade������ | optstratrade_node��optStraddleTrading�Ķ���
%DEMO
% set(multi, '2034' , stra2034)
% ���Ʒ� 20161124 

% 1,�ж�
assert(ischar(optstratrade_name));

% 2,����
optstraddletrading_Multi = obj.optstraddletrading_multi;
keys_value = keys(optstraddletrading_Multi);
if ismember(optstratrade_name, keys_value)
    warning('����OptStraddleTrading���������Ѿ�����,��������')
    return;
end

optstraddletrading_Multi(optstratrade_name) = optstratrade_node;
obj.optstraddletrading_multi = optstraddletrading_Multi;
obj.m2tkCallQuote = optstratrade_node.m2tkCallQuote;
obj.m2tkPutQuote  = optstratrade_node.m2tkPutQuote;








end