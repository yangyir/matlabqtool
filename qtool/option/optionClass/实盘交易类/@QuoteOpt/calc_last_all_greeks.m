function [  ] = calc_last_all_greeks( obj )
%CALC_LAST_ALL_GREEKS 用last价格计算所有的greeks
% ------------------------------
% cg, 20160302
% 朱江 20160308 只计算一次impvol，并且在计算值为NaN时，返回，而不是抛出异常。

try
    rf = obj.r;
    impvol = obj.calcImpvol;
    obj.calcDelta(rf, impvol);
    obj.calcGamma(rf, impvol);
    obj.calcTheta(rf, impvol);
    obj.calcVega(rf, impvol);
    obj.calcRho(rf, impvol);
catch e
    disp('计算失败');
end


end

