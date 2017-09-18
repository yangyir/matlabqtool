function treynorR = TreynorRatio( nav, benchmark, rf)
% 本函数用于计算Treynor ratio
% treynorR = TreynorRatio( nav, benchmark, rf)
% nav 资产净值或比率
% benchmark 市场收益值或比率
% rf 无风险年利率。默认5%
% ---------------
% 唐一鑫 20150511重写，仅添加nav参数，且修改部分函数体（年化数据）

% if nargin < 4
%     flag = 'pct';
% end
% 
% if strcmp( flag, 'val')
%     navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
%     benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
% end
% 
% lrf = log(1+rf)/250;
% beta = evl.Beta(navOrRate, benchmark);
% treynorR = (mean(navOrRate)-lrf)./beta;
% end

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
%% 预处理
if ~exist('rf','var')
    rf = 0.05;
end
%% 重写main
beta        = evl.beta(nav,benchmark);
treynorR    = (evl.annualYield(nav)-rf) / beta;
end
