function [ out_long, out_short ] = sigStopWin( price, sig_long, sig_short, initBp, bp, pct )
% 在原来的买入卖出信号中插入止赢点
% 止盈点按浮动水线设置，当买入后价格向有利方向变动initBp个单位后，按照回撤点数或回撤百分比发出止盈信号
% 本函数只按照买入点设置平仓信号，而不管实际仓位如何
% @input    price:  价格序列，实际过程中，进入点价格应以成交单价格设置。
% @input    sig_long:   多头方向交易信号，{1, 0, -1}分别代表{买入开仓，不做动作，卖出平仓}
% @input    sig_short:  空头方向交易信号，{1, 0，-1}分别代表{买入平仓，不做动作，卖空开仓}
% @param    initBp: 有利方向变动触发点数。 默认触发 15
% @param    bp：    不利方向变动基点。股指期货中，bp需是0.2的整数倍
% @param    pct：   不利方向变动百分比。
% @explain  如果同时输入bp和pct，则在计算止损点位时用较保守的止损线
% @author   daniel  20130508

% 预处理

if nargin<5
    error('input data is not enough')
end

if nnz(size(price)~=size(sig_long)) || nnz(size(price) ~= size(sig_short))
    error('input data must be same size');
end

if ~exist('initBp','var'), initBp = 15; end % 默认15个点触发止盈条件

if isempty(bp) && isempty(pct), error('must set one of bp and pct'); end 
if ~exist('bp','var'),  bp  = 3000; end
if ~exist('pct','var'), pct = 1 ; end 

[ nPeriod , nAsset ] = size(sig_long);
out_long  = sig_long;
out_short = sig_short;

% 计算止盈位置

for jAsset = 1:nAsset
    % 初始化状态变量和价格寄存器
    rs_long  = 0;
    monitorLongStopWin = 0;
    longWaterMarkPrice = 0;
    
    rs_short = 0;
    monitorShortStopWin = 0;
    shortWaterMarkPrice = 0;
    
    for iPeriod = 1:nPeriod
        tradeLong   = sig_long(iPeriod, jAsset);
        tradeShort  = sig_short(iPeriod, jAsset);
        nowPrice    = price(iPeriod, jAsset);
        % 多头
        if rs_long == 0
            if tradeLong ==1
                rs_long = 1;
                priceLong = nowPrice;
             end
           
        elseif rs_long == 1
            if tradeLong == -1
                rs_long = 0;
                priceLong = 0;
            else
                if monitorLongStopWin == 0 %盈利超过initBp 后开始观察止盈条件
                    if nowPrice >= priceLong + initBp
                        monitorLongStopWin = 1;
                        longWaterMarkPrice = nowPrice;
                    end
                else  % 在观察止盈条件下，当价格跌到水线下方bp或pct百分比时平仓，状态变量恢复，记录平仓点
                    if nowPrice <= max(longWaterMarkPrice-bp, longWaterMarkPrice*(1-pct))
                        rs_long = 0;
                        longWaterMarkPrice =0;
                        monitorLongStopWin = 0;
                        out_long(iPeriod, jAsset) = -1;
                    else % 如果不满足关仓，则继续更新水线
                        longWaterMarkPrice = max(longWaterMarkPrice, nowPrice);
                    end
                end
            end
        end
        
        % 空头
        if rs_short == 0
            if tradeShort == -1
                rs_short = -1;
                priceShort = nowPrice;
            end
        elseif rs_short == -1
            if tradeShort == 1
                rs_short = 0;
                priceLong = 0;
            else
                if monitorShortStopWin == 0
                    if nowPrice <= priceShort - initBp
                        monitorShortStopWin = 1;
                        shortWaterMarkPrice = nowPrice;
                    end
                else
                    if nowPrice >= max(shortWaterMarkPrice + bp, shortWaterMarkPrice*(1+pct))
                        rs_short = 0;
                        shortWaterMarkPrice = 0;
                        monitorShortStopWin = 0;
                        out_short(iPeriod,jAsset) = 1;
                    else
                        shortWaterMarkPrice = min(shortWaterMarkPrice, nowPrice);
                    end
                end
            end
        end
    end
end
 



end %EOF

