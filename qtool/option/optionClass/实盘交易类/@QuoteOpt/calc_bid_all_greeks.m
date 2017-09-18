function [  ] = calc_bid_all_greeks( obj )
%CALC_BID_ALL_GREEKS 用bid价格计算所有的greeks
% ------------------------------
% cg, 20160302
% 朱江 20160308 只计算一次impvol，并且在计算值为NaN时，返回，而不是抛出异常。

try
    rf = obj.r;
    impvol_bid = obj.calcImpvol_bid;
    obj.calcDelta_bid(rf, impvol_bid);
    obj.calcGamma_bid(rf, impvol_bid);
    obj.calcTheta_bid(rf, impvol_bid);
    obj.calcVega_bid(rf, impvol_bid);
    obj.calcRho_bid(rf, impvol_bid);
catch e
    disp('计算失败');
end

end

