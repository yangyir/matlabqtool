function [ out_long, out_short ] = sigStopLoss( price, sig_long, sig_short, bp, pct )
% 在原来的买入卖出信号中插入止损点
% 本函数只按照买入点设置平仓信号，而不管仓位如何
% @input    price:  价格序列，实际过程中，进入点价格应以成交单价格设置。
% @input    sig_long:   多头方向交易信号，{1, 0, -1}分别代表{买入开仓，不做动作，卖出平仓}
% @input    sig_short:  空头方向交易信号，{1, 0，-1}分别代表{买入平仓，不做动作，卖空开仓}
% @param    bp：    不利方向变动点数。股指期货中，bp需是0.2的整数倍
% @param    pct：   不利方向变动百分比。
% @explain  如果同时输入bp和pct，则在计算止损点位时用较保守的止损线
% @author   daniel  20130508

% 预处理

if nargin<=3
    error('input data is not enough')
end

if nnz(size(price)~=size(sig_long)) || nnz(size(price) ~= size(sig_short))
    error('input data must be same size');
end

if isempty(bp) && isempty(pct), error('must set one of bp and pct'); end 
if ~exist('bp','var'),  bp  = 3000; end
if ~exist('pct','var'), pct = 1 ; end 

[ nPeriod , nAsset ] = size(sig_long);
out_long  = sig_long;
out_short = sig_short;

% 计算止损位置
for jAsset = 1:nAsset
    rs_long  = 0;
    rs_short = 0;
    for iPeriod = 1:nPeriod
        tradeLong   = sig_long(iPeriod, jAsset);
        tradeShort  = sig_short(iPeriod, jAsset);
        nowPrice = price(iPeriod, jAsset);
        % 多头
        if rs_long == 0
            if tradeLong ==1
                rs_long = 1;
                priceLong = nowPrice;
                longStopLossPrice = max(priceLong - bp, priceLong*(1-pct));
            end
           
        elseif rs_long == 1
            if tradeLong == -1
                rs_long = 0;
                priceLong = 0;
            elseif nowPrice <= longStopLossPrice
                rs_long = 0;
                priceLong = 0;
                out_long(iPeriod, jAsset) = -1;
            end
        end
        
        % 空头
        if rs_short ==0
            if tradeShort == -1;
                rs_short = -1;
                priceShort = nowPrice;
                shortStopLossPrice = min (priceShort + bp, priceShort*(1+pct));
            end
        elseif rs_short ==1
            if tradeShort == 1
                rs_short = 0;
                priceShort = 0;
            elseif nowPrice >= shortStopLossPrice
                rs_short = 0;
                priceShort = 0;
                out_short(iPeriod, jAsset) = 1;
            end
        end            
    end
end



end

