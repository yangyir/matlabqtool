function set(obj, optstratrade_name, optstratrade_node)
% 添加optstraddletrading元素
%输入
% optstratrade_name optstratrade的名称 | optstratrade_node是optStraddleTrading的对象
%DEMO
% set(multi, '2034' , stra2034)
% 吴云峰 20161124 

% 1,判断
assert(ischar(optstratrade_name));

% 2,填入
optstraddletrading_Multi = obj.optstraddletrading_multi;
keys_value = keys(optstraddletrading_Multi);
if ismember(optstratrade_name, keys_value)
    warning('填入OptStraddleTrading的名称内已经存在,不可填入')
    return;
end

optstraddletrading_Multi(optstratrade_name) = optstratrade_node;
obj.optstraddletrading_multi = optstraddletrading_Multi;
obj.m2tkCallQuote = optstratrade_node.m2tkCallQuote;
obj.m2tkPutQuote  = optstratrade_node.m2tkPutQuote;








end