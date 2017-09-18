%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算sharpe ratio（夏普比）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sharperatio = SharpeRatio( R,Rf,slicesPerDay)

loc = isnan(R) | isnan(Rf);

R (loc) = [];
Rf(loc) = [];
if size(R,1)>1
    sharperatio = (mean(R-Rf))/std(R);
else
    sharperatio = nan;
end

sharperatio = sharperatio*(slicesPerDay*250)^0.5;
end

