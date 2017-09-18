function [ masw, indexmat ] = masw( price, mas )
%masw 均线强弱指数
%   均线强弱指数利用多根均线给当前资产打分
%   小于所有均线得1分，大于第一小，小于第二小得2分，以此类推
%   inputs：
%       price: 各个资产的
%       mas：用于均线打分的均线（默认八均线[8, 13, 21, 34, 55, 89, 144, 233])
%   outputs:
%       masw: 各资产均线强弱指数的和，可能是(nan, 1*nasset, 2*nasset…)
%       indexmat: 所有资产的指标矩阵

if ~exist('mas', 'var') || isempty(mas)
    mas = [8, 13, 21, 34, 55, 89, 144, 233]; 
end

nma = length(mas);
[nperiod, nasset] = size(price);
pma = nan(nperiod, nasset, nma);
indexmat = nan(nperiod, nasset);
% masw = nan(nperiod, 1);
for iasset = 1:nasset
    for ima = 1: nma
        pma(:, iasset, ima) = ind.ma(price(:, iasset), mas(ima));
    end
    % 对pma排序
    sort(pma(:, iasset, :), 2);
end

for iasset = 1:nasset
    for iperiod = 1:nperiod
        if sum(isnan( pma(iperiod, iasset, :))) > 0, continue; end
        % 计算当前价格评分
        for ima = 1:nma
            if price(iperiod, iasset) < pma(iperiod, iasset, ima)
                indexmat(iperiod, iasset) = ima;
                break;
            end
        end
        if price(iperiod, iasset) > pma(iperiod, iasset, ima)
            indexmat(iperiod, iasset) = nma + 1;
        end
    end
end

masw = sum(indexmat, 2);