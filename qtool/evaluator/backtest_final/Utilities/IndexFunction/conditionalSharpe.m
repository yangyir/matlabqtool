%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算conditional sharpe ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function conditionalSharpeR = conditionalSharpe( R,Rf,VaR)
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];
newTR = R;
newTR( newTR > -VaR)=[];
conditionalSharpeR = -(mean(R-Rf))/mean(newTR);

end

