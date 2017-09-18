function [  ] = calc_last_all_greeks( obj )
%CALC_LAST_ALL_GREEKS ��last�۸�������е�greeks
% ------------------------------
% cg, 20160302
% �콭 20160308 ֻ����һ��impvol�������ڼ���ֵΪNaNʱ�����أ��������׳��쳣��

try
    rf = obj.r;
    impvol = obj.calcImpvol;
    obj.calcDelta(rf, impvol);
    obj.calcGamma(rf, impvol);
    obj.calcTheta(rf, impvol);
    obj.calcVega(rf, impvol);
    obj.calcRho(rf, impvol);
catch e
    disp('����ʧ��');
end


end

