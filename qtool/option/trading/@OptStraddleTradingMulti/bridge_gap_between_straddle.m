function bridge_gap_between_straddle(obj, std_name, prct, proportion, opposite)
% 将几本Book按照比率和变分比进行调平
% bridge_gap_between_straddle(obj, std_name, prct, proportion)
%Import
% std_name 基准Book的名称
% prct 调整的百分比率 0 ~ 100
% proportion 几本Book的调整比率 默认 obj.proportion
% 对手价格下单档数 1:5选择


%% Config

if obj.optstraddletrading_multi.Count <= 1
    return;
end
if ~exist('prct', 'var')
    prct = 10;
end
if ~exist('proportion', 'var')
    proportion = obj.proportion;
end
if ~exist('opposite', 'var')
    opposite = 1;
end
assert(prct > 0 && prct < 100)
assert(ismember(opposite , 1:5))

keys_value = keys(obj);
assert(length(keys_value) == length(proportion))

if ismember(std_name, keys_value)
    std_position = strcmp(std_name, keys_value);
    std_rate  = proportion(std_position);
    proportion(std_position) = [];
    comp_rate = proportion;
    comp_rate = comp_rate/std_rate;
    comp_name = keys_value(~std_position);
else
    return;
end


%% 进行一次性的合并下单

std_straddle = get(obj, std_name);
for t = 1:length(comp_name)
    comp_straddle = get(obj, comp_name{t});
    % 调仓比率
    ratio = comp_rate(t);
    % 一次性委托下单
    OptStraddleTradingFusion.bridge_gap_entrust(std_straddle, comp_straddle, prct, ratio, opposite); 
end










end