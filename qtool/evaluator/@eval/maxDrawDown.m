function [ mdd ] = maxDrawDown( nav )
%MAXDRAWDOWN 计算最大回撤
%   Detailed explanation goes here
[nPeriod, nAsset] = size(nav);
mdd = zeros(nAsset, 1);
for iAsset = 1: nAsset
    nowHigh = -inf;
    for iPeriod = 1: nPeriod
        price = nav(iPeriod, iAsset);
        if price > nowHigh
            nowHigh = price;
        end
        dawndown = ( nowHigh - price) / nowHigh;
        mdd(iAsset) = max(mdd(iAsset), dawndown);
    end
end

end

