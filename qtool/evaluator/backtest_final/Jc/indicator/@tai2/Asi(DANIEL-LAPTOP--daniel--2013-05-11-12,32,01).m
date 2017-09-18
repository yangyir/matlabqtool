
function [sig_long, sig_short] = Asi(bar, mu_up, mu_down,type)
% ASI 振动升降指标
% 输入：
%【数据】 开盘，最高，最低，收盘
%【参数】 划分前期高低点的mu_up, mu_down
% 输出：sig_long, sig_short, asi

if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('type', 'var') || isempty(type), type = 1; end

close = bar.close;
open = bar.open;
high = bar.high;
low = bar.low;

[sig_long, sig_short] = tai.Asi(open, high, low, close, mu_up, mu_down, type);

if nargout == 0
    [asi.asi, asi.si] = ind.asi(open, high, low, close);
    bar.plotind2(sig_long + sig_short, asi, true);
    title('Asi long and short');
end
end 











