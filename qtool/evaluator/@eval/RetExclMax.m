function  retExclMax  = RetExclMax(navOrRate, flag)
% 扣除最大盈利后的收益率
% navOrRate 资产净值或比率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 2
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = navOrRate(2:end,:)./navOrRate(1:end-1,:) - 1;
end

maxRet=max(navOrRate);
[~, nAsset]=size(navOrRate);

retExclMax = zeros(1,nAsset);
for iAsset = 1:nAsset
    retExclMax(iAsset) = prod(navOrRate(navOrRate(:,iAsset)<maxRet(iAsset),iAsset) + 1);
    retExclMax(iAsset) = retExclMax(iAsset).^(1/sum(~(navOrRate(:,iAsset)==maxRet(iAsset))));
    retExclMax(iAsset) = retExclMax(iAsset) - 1;
end

end

