function [ hFig ] = plot_Impvol_smile(obj)
% smile比较作图函数

smiles_ = obj.smiles_;
len_smiles_ = length(smiles_);
des     = obj.des;


% 获取x_value_的最大值和最小值
m_max_ = -999999;
m_min_ = 999999;
for t = 1:len_smiles_
    m_max_ = max([m_max_, smiles_(t).x_value_]);
    m_min_ = min([m_min_, smiles_(t).x_value_]);
end
x_ = m_min_:(m_max_ - m_min_)/60:m_max_;

% 插入0值
x_(abs(x_) < 1e-6) = [];
idx = find(x_ >= 0);
if isempty(idx)
    x_ = [0, x_];
else
    less_ = x_(1:idx - 1);
    more_ = x_(idx:end);
    x_ = [less_, 0, more_];
end

% 记录0处的位置和0处的值
zero_idx_ = x_ == 0;
zero_value_ = nan(len_smiles_, 1);

value_ = nan(len_smiles_, length(x_));
for t = 1:len_smiles_
    value_(t, :) = smiles_(t).calculate(x_);
    zero_value_(t) = value_(t, zero_idx_);
    value_(t, :) = value_(t, :) - zero_value_(t);
end


% 作图
hFig = figure;
ax = axes;
x_ = repmat(x_', 1, len_smiles_);
plot(x_, value_', '*-', 'MarkerSize', 3, 'LineWidth', 2)
xlabel('M-shift', 'FontWeight', 'bold')
ylabel('iv', 'FontWeight', 'bold')
title(des, 'FontWeight', 'bold')
legend_ = num2cell(1:len_smiles_);
legend_ = cellfun(@(x)sprintf('%dT', x), legend_, 'UniformOutput', false);
legend(legend_, 'Location', 'best')
grid on

% 描零线
hold on
ylim_ = get(ax, 'YLim');
zero_line_ = min(ylim_):(max(ylim_) - min(ylim_))/50:max(ylim_);
plot(zeros(1, length(zero_line_)), zero_line_, '--')
set(ax, 'FontWeight', 'bold')






end