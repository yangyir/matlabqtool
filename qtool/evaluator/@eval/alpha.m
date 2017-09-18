function alpha = alpha( navOrRate, benchmark, rf, flag)
% 本函数用于计算alpha系数
% navOrRate 资产净值或比率
% benchmark 市场收益值或比率
% rf 无风险年利率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 4
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

beta = eval.beta( navOrRate, benchmark);
lrf = log(rf + 1)/250;


alpha = mean(navOrRate - lrf) - beta.*(mean(benchmark - lrf));

end
%{
previous version
function alphaC = alphaCoefficient( R,Rm,Rf,betaC)

loc = isnan(R) | isnan(Rf)| isnan(Rm);
R (loc) = [];
Rf(loc) = [];
Rm(loc) = [];
% 数据不够输出nan
if size(R,1)>1
    alphaC = mean(R - Rf) - betaC*(mean(Rm-Rf));
else
    alphaC  =nan;
end
end
%}
