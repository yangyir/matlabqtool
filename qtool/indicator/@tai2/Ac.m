function [sig_long, sig_short] = Ac(bars, nDay, mDay, type)
%accelerator oscillator  返回交易信号(-1,0,1)和ac值
%输入
% 【数据】HighPrice, LowPrice （时间 X 股票矩阵）
% 【参数】nDay, mDay 快速和慢速移动平均回溯天数 （自然数）
%   Yan Zhang   version 1.0 2013/3/12
highPrice = bars.high;
lowPrice = bars.low;

%% 预处理
if ~exist('nDay', 'var') || isempty(nDay), nDay = 2; end
if ~exist('mDay', 'var') || isempty(mDay), mDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 调用tai
[sig_long, sig_short] = tai.Ac(highPrice,lowPrice,nDay,mDay, type);

%% 画图
if nargout == 0
    ac.aco = ind.aco(highPrice, lowPrice, nDay, mDay);
    bars.plotind2( sig_long + sig_short, ac, true);
    title('AC long and short');
end
end %EOF
 