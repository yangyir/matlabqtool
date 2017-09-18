%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算基于VaR的超额收益比
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exRetVaR = excessReturnOnVaR( R,Rf,VaR)
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];
exRetVaR = mean(R-Rf)/VaR;
end

