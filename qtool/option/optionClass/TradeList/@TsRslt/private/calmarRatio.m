function calmarR = calmarRatio( nav ,Rf,slicesPerDay)

% 潘其超，20140710，V1.0

% 计算连续收益率
R = log(nav(2:end)./nav(1:end-1));

% 计算最大回撤
md = calcMaxDD(nav);

calmarR = mean(R-Rf)/min(md);
calmarR = calmarR*(250*slicesPerDay);

end

