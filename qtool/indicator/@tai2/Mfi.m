function  [sig_rs] = Mfi(bar, nDay,type)
% money flow index 资金流量指标
% 可以考虑加入顶底背离作为判断条件
% 2013/3/21 daniel
%
% 计算方法
% 1.典型价格（TP）=当日最高价、最低价与收盘价的算术平均值
% 2.货币流量（MF）=典型价格（TP）×N日内成交金额
% 3.如果当日MF>昨日MF，则将当日的MF值视为正货币流量（PMF）
% 4.如果当日MF<昨日MF，则将当日的MF值视为负货币流量（NMF）
% 5.MFI=100-[100/(1+PMF/NMF)]
% 6.参数N一般设为14日。
%
% 应用法则
% 1.显示超买超卖是MFI指标最基本的功能。当MFI>80时为超买，在其回头向下跌破80时，为短线卖出时机。
% 2.当MFI<20时为超卖，当其回头向上突破20时，为短线买进时机。
% 3.当MFI>80，而产生背离现象时，视为卖出信号。
% 4.当MFI<20，而产生背离现象时，视为买进信号。

%% 预处理及计算
high = bar.high;
low = bar.low;
close = bar.close;
volume = bar.volume;

if ~exist('nDay', 'var') || isempty(nDay), nDay = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 信号
sig_rs = tai.Mfi(high, low, close, volume, nDay, type);

if nargout == 0
    mfi.mfi = ind.mfi(high, low, close, volume, nDay);
    bar.plotind2(sig_rs, mfi, true);
    title('mfi rs');
end

end


