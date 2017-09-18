function beta = beta( nav, benchmark)
% 本函数用于计算beta系数
% beta = beta( nav, benchmark)
%   nav 资产净值
%   benchmark 市场收益值
%---------------
%唐一鑫 20150511 将函数改写：仅采用nav而不用rate,故删去了flag
% 2015.8.17,lu,使用log的前提是nav为正，如果nav为负，怎么解决？使用传统收益率方式




%% main
% 2015.8.17修改以下两行
%  Rate       = log(nav(2:end,:)./nav(1:end-1,:));
%  benchmark  = log(benchmark(2:end,:)./benchmark(1:end-1,:));
 Rate       = diff(nav)./nav(1:end-1,:) ;
 benchmark  = diff(benchmark)./benchmark(1:end-1,:) ;
 
 nAsset = size(Rate, 2);
 beta   = zeros(1,nAsset);
 
 for iAsset      = 1:nAsset;
    covMatrix    = cov(Rate(:,iAsset), benchmark);     
    beta(iAsset) = covMatrix(1,2)/covMatrix(2,2);
 end
end
 




