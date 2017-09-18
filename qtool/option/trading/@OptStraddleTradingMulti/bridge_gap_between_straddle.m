function bridge_gap_between_straddle(obj, std_name, prct, proportion, opposite)
% ������Book���ձ��ʺͱ�ֱȽ��е�ƽ
% bridge_gap_between_straddle(obj, std_name, prct, proportion)
%Import
% std_name ��׼Book������
% prct �����İٷֱ��� 0 ~ 100
% proportion ����Book�ĵ������� Ĭ�� obj.proportion
% ���ּ۸��µ����� 1:5ѡ��


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


%% ����һ���Եĺϲ��µ�

std_straddle = get(obj, std_name);
for t = 1:length(comp_name)
    comp_straddle = get(obj, comp_name{t});
    % ���ֱ���
    ratio = comp_rate(t);
    % һ����ί���µ�
    OptStraddleTradingFusion.bridge_gap_entrust(std_straddle, comp_straddle, prct, ratio, opposite); 
end










end