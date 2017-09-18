%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ���alphaϵ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function alphaC = alphaCoefficient( R,Rm,Rf,betaC)

loc = isnan(R) | isnan(Rf)| isnan(Rm);
R (loc) = [];
Rf(loc) = [];
Rm(loc) = [];
% ���ݲ������nan
if size(R,1)>1
    alphaC = mean(R - Rf) - betaC*(mean(Rm-Rf));
else
    alphaC  =nan;
end
end
