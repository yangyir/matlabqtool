%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算beta系数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function betaC =betaCoefficient( R,Rm)
loc = isnan(R) | isnan(Rm);
R (loc) = [];
Rm (loc) = [];

if size(R,1)>1
    covRRm = cov(R,Rm);
    betaC = covRRm(1,2)/var(Rm);
else
    betaC = nan;
end
end