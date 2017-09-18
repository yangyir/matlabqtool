%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算修正夏普比
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modifiedSharpeR = modifiedSharpe( R,Rf,VaR)
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

udAlpha = VaR;
z = udAlpha;
S = skewness(R);
E = kurtosis(R);
MVaR = -(mean(R)+std(R)*(z+(z^2-1)*S/6+(z^3-3*z)*E/24-(2*z^3-5*z)*S^2/36));
modifiedSharpeR = mean(R-Rf)/MVaR;

end

