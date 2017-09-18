function upRatio = upr(ret, MAR)
%% Calculate upside potential ratio(upr) of return RET at MAR.
% MAR = minimum acceptalbe ratio, is a scalar.
%%
MAR = MAR/250;
upRatio = hpm(ret,MAR,1)/sqrt(lpm(ret,MAR,2));
end
