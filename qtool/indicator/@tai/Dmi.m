function [ sig_long, sig_short, sig_rs] = Dmi( highPrice, lowPrice, closePrice, lag, thred,type)
%DMI 计算DMI(动向指数）并给出信号
%   输入：
%    highPrice 最高价格
%    lowPrice 最低价格
%    closePrice 收盘价格
%    lag 延时（默认14）
%    thred ADX牛皮市阀值
%   输出：
%    sig 买卖信号
%    dmi.diup +DI，
%    dmi.didown -DI
%    dmi.dx DX指数
%    dmi.adx ADX指数（DX经过EMA后得到）


if ~exist('lag', 'var') || isempty(lag), lag = 14; end
if ~exist('thred', 'var') || isempty(thred), thred = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end
[nPeriod, nAsset] = size(highPrice);

if nPeriod<lag
    error('data is too short');
end


% 计算+DM，-DM


[dmiup, dmidown, adx ]=ind.dmi(highPrice, lowPrice, closePrice, lag);

sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

if type==1
for jAsset = 1: nAsset
    for iPeriod = 2: nPeriod -1 
        %ADX小于thred为牛皮市，信号不可靠
        if adx( iPeriod, jAsset) > thred
            %＋DMI上升，－DMI下降，买进讯号
            if dmiup(iPeriod - 1, jAsset) < dmidown(iPeriod - 1, jAsset) && dmiup(iPeriod, jAsset) > dmidown(iPeriod, jAsset)
                sig_long(iPeriod, jAsset ) = 1;
            end
            %＋DMI下降，－DMI上升，卖出讯号
            if dmiup(iPeriod - 1, jAsset) > dmidown(iPeriod - 1, jAsset) && dmiup(iPeriod, jAsset) < dmidown(iPeriod, jAsset)
                sig_short(iPeriod, jAsset ) = -1;
            end
            
            %ADX继续上行，加强原有趋势
            if adx(iPeriod, jAsset) > adx(iPeriod - 1, jAsset) 
                if dmiup(iPeriod, jAsset) > dmiup( iPeriod -1, jAsset) && dmiup(iPeriod, jAsset) > dmidown(iPeriod, jAsset)
                    sig_rs(iPeriod, jAsset) = 1;
                end
                if dmidown(iPeriod, jAsset) > dmidown(iPeriod - 1, jAsset) && dmidown(iPeriod, jAsset) > dmiup(iPeriod, jAsset)
                    sig_rs(iPeriod, jAsset) = -1;
                end
            end
        end

    end
end
else
;
end
end