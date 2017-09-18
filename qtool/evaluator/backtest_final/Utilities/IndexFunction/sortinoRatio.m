%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算sortino ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  SoRa  = sortinoRatio( R,Rf,slicesPerDay )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];



logR = cumsum(R);
dayly_logR = zeros((length(R)+1)/fix(slicesPerDay),1);
dayly_logR = logR((1:(length(R)+1)/slicesPerDay)*fix(slicesPerDay)-1);
dayly_R = diff(dayly_logR);
dayly_Rf = Rf(1)*slicesPerDay*ones(length(dayly_R),1);

difRR = dayly_R - dayly_Rf;

SoRm = mean(dayly_R - dayly_Rf)/std(dayly_R(difRR<0));
SoRa = SoRm*sqrt(250);


end