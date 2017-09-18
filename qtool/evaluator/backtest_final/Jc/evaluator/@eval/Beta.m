function beta = Beta( navOrRate, benchmark, flag)
% 本函数用于计算beta系数
% navOrRate 资产净值或比率
% benchmark 市场收益值或比率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 3
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

nAsset = size(navOrRate, 2);
beta = zeros(1,nAsset);

for iAsset = 1:nAsset
    covMatrix=cov(navOrRate(:,iAsset), benchmark);
    beta(iAsset) = covMatrix(1,2)/covMatrix(2,2);
end

end
%{
previous version
function betaC =betaCoefficient( R,Rm)
loc = isnan(R) | isnan(Rm);
R (loc) = [];
Rm (loc) = [];

if size(R,1)>1
    covRRm = cov(R,Rm);
    betaC = covRRm(1,2)/var(Rm);
else
    betaC = nan;
end
end
%}