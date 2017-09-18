function [maVal] = ma(price,lag,flag)
% Moving Average
% [maVal] = ma(price,lag,flag)
% price：（多个）资产价格序列
% lag：   滞后阶数 （默认 10）
% flag：  MA计算方法
%         e = 指数移动平均
%         0 = 简单移动平均
%         0.5 = 平方根加权平均
%         1 = 线性平均
%         2 = 平方加权平均

% 数据预处理以及分配输出大小
[nPeriod, nAsset] = size(price);

if nargin<2 || isempty(lag)
    lag=10;
end
if nPeriod<lag
    error('data is too short');
end

if nargin<3 || isempty(flag)
    flag = 'e';
end

maVal = nan(nPeriod, nAsset);

% 计算各个资产移动平均
if flag =='e'
    for iAsset = 1:nAsset
        param = 2/(lag+1);
        idxFirst = find(~isnan(price(:,iAsset)),1,'first');
        if isempty(idxFirst) || idxFirst==nPeriod
            continue
        else
            maVal(idxFirst,iAsset) = price(idxFirst,iAsset);
            for jPeriod = idxFirst+1:nPeriod
                maVal(jPeriod,iAsset) = maVal(jPeriod-1,iAsset)+param*(price(jPeriod,iAsset)-maVal(jPeriod-1,iAsset));
            end
        end
    end
else
        j = 1: lag;
        w = (lag-j+1).^flag./sum([1:lag].^flag);
        for iAsset = 1:nAsset
            idxFirst = find(~isnan(price(:,iAsset)),1,'first');
            if isempty(idxFirst) || idxFirst==nPeriod
                continue
            else
                maVal(idxFirst:end,iAsset) = filter(w,1,price(idxFirst:end,iAsset));
            end
        end
end
maVal(1:lag,:) = nan;
end