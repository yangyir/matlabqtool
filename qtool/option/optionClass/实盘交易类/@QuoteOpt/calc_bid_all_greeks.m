function [  ] = calc_bid_all_greeks( obj )
%CALC_BID_ALL_GREEKS ��bid�۸�������е�greeks
% ------------------------------
% cg, 20160302
% �콭 20160308 ֻ����һ��impvol�������ڼ���ֵΪNaNʱ�����أ��������׳��쳣��

try
    rf = obj.r;
    impvol_bid = obj.calcImpvol_bid;
    obj.calcDelta_bid(rf, impvol_bid);
    obj.calcGamma_bid(rf, impvol_bid);
    obj.calcTheta_bid(rf, impvol_bid);
    obj.calcVega_bid(rf, impvol_bid);
    obj.calcRho_bid(rf, impvol_bid);
catch e
    disp('����ʧ��');
end

end

