function [  ] = calc_ask_all_greeks( obj )
%CALC_ASK_ALL_GREEKS ��ask�۸�������е�greeks
% ------------------------------
% cg, 20160302, TODO: ���Ч��
% �콭 20160308 ֻ����һ��impvol�������ڼ���ֵΪNaNʱ�����أ��������׳��쳣��

try
    rf = obj.r;
    impvol_ask = obj.calcImpvol_ask;
    obj.calcDelta_ask(rf, impvol_ask);
    obj.calcGamma_ask(rf, impvol_ask);
    obj.calcTheta_ask(rf, impvol_ask);
    obj.calcVega_ask(rf, impvol_ask);
    obj.calcRho_ask(rf, impvol_ask);
catch e
    disp('����ʧ��');
end

end

