function [ mdd ] = maxDrawDown( nav )
% 计算最大回撤，结果是百分比
% TODO:加入idx

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

