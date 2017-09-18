function optstraddletrading_unit = get(obj, optstratrade_name)
% 取出对应名称的OptStraddleTrading
%输入
% optstratrade_name：Straddle Trading对象的名称
%输出
% optstraddletrading_unit对象
% 吴云峰 20161124


optstraddletrading_Multi = obj.optstraddletrading_multi;
keys_value = keys(optstraddletrading_Multi);
if ismember(optstratrade_name, keys_value)
    optstraddletrading_unit = optstraddletrading_Multi(optstratrade_name);
else
    warning('OptStraddleTrading内无对应的名称');
    optstraddletrading_unit = [];
end




end