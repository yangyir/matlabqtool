function  [ sig_long, sig_short] = reframeSig( bars , ind , freq )
% 生成基于不同频率下的信号
% 返回的信号是基于原始数据的频率（如果1分钟频率则以1分钟为主）
% bars：基础数据（默认1分钟频率期货数据）
% ind：信号函数, 需要预先设置
% freq： 频率 （默认=5， 表示5分钟）, 数值限于【1~269】，日内数据
%       例如，5分钟级别出现一个做多信号，则一直到下一个五分钟线开始前该指标不变
% @ daniel 20130605 version 1.0
if ~exist('freq','var'), freq = 5; end

barsFreq = reframeBars(bars, freq);
sig_long = zeros(size(bars.time,1), 1);
sig_short = sig_long;

[sigLongFreq, sigShortFreq]  = ind(barsFreq);

for i = 1:length(barsFreq.time)-1
    idxFirst = find(bars.time == barsFreq.time(i));
    idxLast  = find(bars.time == barsFreq.time(i+1))-1;
    sig_long(idxFirst:idxLast) = sigLongFreq(i);
    sig_short(idxFirst:idxLast) = sigShortFreq(i);
end
%EOF
        
    