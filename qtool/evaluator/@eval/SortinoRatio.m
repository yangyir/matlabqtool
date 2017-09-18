function sortinoR = SortinoRatio( navOrRate, rf, flag)
% 本函数用于计算sortino ratio
% navOrRate 资产净值或比率
% rf 无风险年利率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 3
    flag = 'pct';
end

if strcmp( flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
end

lrf = log(1+rf)/250;

sortinoR = (mean(navOrRate)-lrf)./sqrt(lpm(navOrRate, lrf, 2));
end

%{
function  SoRa  = sortinoRatio( R,Rf )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

difRR = R - Rf;
lenTR = length(R);
sTRR = 0;
for i =1:lenTR
    baseRR = min(difRR(i),0);
    sTRR = sTRR + baseRR^2;
end

DDex = sqrt(sTRR/(lenTR-1));
SoRm = mean(R-Rf)/DDex;
SoRa = SoRm*sqrt(250);

end
%}

