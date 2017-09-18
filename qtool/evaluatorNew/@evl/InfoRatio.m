function[ infoRatio ] = InfoRatio( nav, benchmark)
%这个函数用于计算Information raio
%[ infoRatio ] = infoRatio( nav, benchmark,)
%nav: 净资产
% benchmark:基准净资产
% ——————————
% 唐一鑫 20150511


%% main
delta       = evl.nav2yield(nav)-evl.nav2yield(benchmark);
sigma       = std(delta)*sqrt(365);
infoRatio   = (evl.annualYield(nav)-evl.annualYield(benchmark))/sigma;

end

