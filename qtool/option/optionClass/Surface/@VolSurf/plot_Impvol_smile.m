function [ hFig ] = plot_Impvol_smile(obj)
% smile�Ƚ���ͼ����

smiles_ = obj.smiles_;
len_smiles_ = length(smiles_);
des     = obj.des;


% ��ȡx_value_�����ֵ����Сֵ
m_max_ = -999999;
m_min_ = 999999;
for t = 1:len_smiles_
    m_max_ = max([m_max_, smiles_(t).x_value_]);
    m_min_ = min([m_min_, smiles_(t).x_value_]);
end
x_ = m_min_:(m_max_ - m_min_)/60:m_max_;

% ����0ֵ
x_(abs(x_) < 1e-6) = [];
idx = find(x_ >= 0);
if isempty(idx)
    x_ = [0, x_];
else
    less_ = x_(1:idx - 1);
    more_ = x_(idx:end);
    x_ = [less_, 0, more_];
end

% ��¼0����λ�ú�0����ֵ
zero_idx_ = x_ == 0;
zero_value_ = nan(len_smiles_, 1);

value_ = nan(len_smiles_, length(x_));
for t = 1:len_smiles_
    value_(t, :) = smiles_(t).calculate(x_);
    zero_value_(t) = value_(t, zero_idx_);
    value_(t, :) = value_(t, :) - zero_value_(t);
end


% ��ͼ
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

% ������
hold on
ylim_ = get(ax, 'YLim');
zero_line_ = min(ylim_):(max(ylim_) - min(ylim_))/50:max(ylim_);
plot(zeros(1, length(zero_line_)), zero_line_, '--')
set(ax, 'FontWeight', 'bold')






end