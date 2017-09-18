%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算sortino ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  SoRa  = sortinoRatio( R,Rf,slicesPerDay )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

difRR = R - Rf;
lenTR = length(R);
sTRR = 0;
for i =1:lenTR
    baseRR = min(difRR(i),0);
    sTRR = sTRR + baseRR^2;
end

DDex = sqrt(sTRR/(lenTR-1));
SoRm = mean(R-Rf)/DDex;
SoRa = SoRm*sqrt(250);

SoRa = SoRa*(250*slicesPerDay)^0.5;
end

