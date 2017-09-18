function  [sig_long, sig_short, sig_rs] = Leadlag(bar, lead, lag, flag, type)
% 领先落后指标，用2条移动平均线预测价格趋势，给出交易信号
% varin：（多个）资产价格序列
% lead：快速移动均线
% lag： 慢速移动均线
% flag：移动均线算法

% 检查数据及预留输出空间

price = bar.close;

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(flag), flag = 'e'; end

% 计算
[sig_long, sig_short, sig_rs] = tai.Leadlag(price, lead, lag, flag, type);

if nargout == 0
    [leadlag.lead, leadlag.lag] = ind.leadlag(price, lead, lag, flag);
    bar.plotind2(sig_long + sig_short, leadlag);
    title('leadlag long and short');
    bar.plotind2(sig_rs, leadlag);
    title('leadlag rs');
end

end 

