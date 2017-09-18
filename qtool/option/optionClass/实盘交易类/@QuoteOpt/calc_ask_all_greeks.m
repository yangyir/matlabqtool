function [  ] = calc_ask_all_greeks( obj )
%CALC_ASK_ALL_GREEKS 用ask价格计算所有的greeks
% ------------------------------
% cg, 20160302, TODO: 提高效率
% 朱江 20160308 只计算一次impvol，并且在计算值为NaN时，返回，而不是抛出异常。

try
    rf = obj.r;
    impvol_ask = obj.calcImpvol_ask;
    obj.calcDelta_ask(rf, impvol_ask);
    obj.calcGamma_ask(rf, impvol_ask);
    obj.calcTheta_ask(rf, impvol_ask);
    obj.calcVega_ask(rf, impvol_ask);
    obj.calcRho_ask(rf, impvol_ask);
catch e
    disp('计算失败');
end

end

