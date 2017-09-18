function sortinoR = SortinoRatio( nav, benchmark,rf)
% 本函数用于计算sortino ratio
% sortinoR = SortinoRatio( nav, rf)
% % navOrRate 资产净值或比率
% % rf 无风险年利率
% % flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'
% ----------------
% 唐一鑫，20150511 将函数修改为仅含参数nav，rf默认为0.05,且修改了部分函数体：主要是使用年化收益

% if nargin < 3
%     flag = 'pct';
% end
% 
% if strcmp( flag, 'val')
%     navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
% end
% 
% lrf = log(1+rf)/250;
% 
% sortinoR = (mean(navOrRate)-lrf)./sqrt(lpm(navOrRate, lrf, 2));
% end

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


%% 预处理
if ~exist('rf','var')
    rf = 0.05;
end

%% 重写main

Rate    = evl.nav2yield(nav);
benchmarkAnnualYield    = evl.annualYield(benchmark);
sortinoR = (evl.annualYield(nav)-benchmarkAnnualYield)./sqrt(lpm(Rate, benchmarkAnnualYield, 2));

end

