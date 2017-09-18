%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算Treynor ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

