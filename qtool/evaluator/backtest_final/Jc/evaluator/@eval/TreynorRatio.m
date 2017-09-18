function treynorR = TreynorRatio( navOrRate, benchmark, rf, flag)
% 本函数用于计算Treynor ratio
% navOrRate 资产净值或比率
% benchmark 市场收益值或比率
% rf 无风险年利率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 4
    flag = 'pct';
end

if strcmp( flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

lrf = log(1+rf)/250;
beta = eval.Beta(navOrRate, benchmark);
treynorR = (mean(navOrRate)-lrf)./beta;
end

%{
previous version
function treynorC = treynorCoefficient( R,Rf,betaC )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

if size(R,1)>1
    treynorC = (mean(R-Rf))/betaC;
else
    treynorC = nan;
end

end
%}
