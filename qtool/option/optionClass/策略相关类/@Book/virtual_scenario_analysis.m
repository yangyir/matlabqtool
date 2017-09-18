function [] = virtual_scenario_analysis(obj, cur_vs, cur_S, target_S, target_vol, target_tau, detail)
%[] = virtual_scenario_analysis(obj, cur_vs, cur_S, target_S, target_vol, target_tau)
% ��Book���ֲ�λ���龰������cur_vs�ǵ�ǰ��vol_surf��cur_SΪ��ǰSֵ
% target_SΪ�龰Sֵ, target_vol ���龰�����ʣ������гֲֶ�ͳһ����ΪĿ�겨����
% target_tau ��ʱ��仯����ͳһ���������гֲ֡�
% detail �Ǹ��߼�����Ĭ��Ϊfalse, ��Ϊtrueʱ����Լ��ʾ����Լ�ϵ���

if ~exist('detail', 'var')
    detail = false;
end

pa = obj.positions;
L = pa.latest;
if L == 0
    return;
end
L = length( pa.node );

s = Structure;
st = Structure;
%% ��position����s.optPricer,��j����������Ч���ڵ���Ȩ�ֲ֡�
j = 0;
for i = 1:L
    pos = pa.node(i);
    try
        if (isnan(pos.quote))
            continue;
        end
    catch e
    end
    quote = pos.quote;
    j = j + 1;
    try
        pricer = quote.QuoteOpt_2_OptPricer('ask');
    catch e
        pricer = OptPricer;
    end
    num = pos.volume * pos.longShortFlag;
    s.optPricers(j) = pricer;
    st.optPricers(j) = pricer.getCopy;
    s.num(j)    = num;
    st.num(j) = num;
end
L = j;
%% ��structureһ��volsurface
s.volsurf = cur_vs;

%% ע��structrue���г�����
s.S = cur_S;
s.r = quote.r;
s.inject_environment_params

s.calcDelta;
s.calcGamma;
s.calcVega;
s.calcTheta;
s.calcRho;
s.calcIntrinsicValue;
s.calcTimeValue;
s.calcPx;

s_vol = s.volsurf.calc_Sigma;
output_scenario(s, '��ǰ���:', L, s_vol, detail);

st.set_environment_S(target_S);
st.set_environment_vol(target_vol);
st.set_environment_tau(target_tau);
st.calcDelta;
st.calcGamma;
st.calcVega;
st.calcTheta;
st.calcRho;
st.calcIntrinsicValue;
st.calcTimeValue;
st.calcPx;

st_vol = target_vol;
output_delta(s, st, target_tau, (st_vol - s_vol), L, detail);
output_scenario(st, 'Ŀ�����:', L, target_vol, detail);

end

function [] = output_scenario(s, description, L, atmiv, detail)
% ���
% ��ͬ�� S = 2.300, Tau = 0.13, ATM iv = 30%
%       M2M = 13500
%       Risk:
%       1% delta   1%gamma  1%vega  Dtheta
%       details:
%       ����������
if ~exist('detail', 'var')
    detail = false;
end

fprintf('%s \n', description);
fprintf('S = %0.3f  |  delta Tau: %s  |  ATM iv = %0.1f%% \n', s.S, datestr(now), atmiv * 100);
% m2m = 0;
% for i = 1:L
%     op = s.optPricers(i);
%     num = s.num(i);
%     m2m = m2m + num * op.px * op.multiplier;
% end
fprintf(' M2M = %0.3f \n', s.px * 10000);

output_s_risk(s, L, detail);

end

function [] = output_delta(s0, st, deltaTau, deltaIv, L, detail)
if ~exist('detail', 'var')
    detail = false;
end

fprintf(' S �仯��%0.3f, tau �仯��%0.4f, ATM iv �仯��%0.3f\n', (st.S - s0.S), deltaTau, deltaIv);
fprintf(' M2M �仯��%0.3f \n', (st.px - s0.px)*10000);
fprintf('optName\t\tpos\t\td_px\td_iv\tDdelta\tDgamma\tDtheta\tDvega\tdinValue\tdtimeValue\n');
total_diff_result = zeros(1, 9);
for i = 1:L
    num = s0.num(i);
    op_s0 = s0.optPricers(i);
    op_st = st.optPricers(i);
    op_name = op_s0.optName(6:end);
    d_px = (op_st.px - op_s0.px) * op_s0.multiplier;
    d_iv = (op_st.sigma - op_s0.sigma)*100;
    ddelta = (op_s0.delta * op_s0.multiplier) * 0.01 * (op_st.S - op_s0.S);
    dgamma = (op_s0.gamma * op_s0.multiplier * 0.0001 / 2) * (op_st.S - op_s0.S) * (op_st.S - op_s0.S);
    dtheta   =  (op_s0.theta * op_s0.multiplier) * (deltaTau);
    dvega    = op_s0.vega * op_s0.multiplier * 0.01 * d_iv;
    dintrinsic_value = (op_st.intrinsicValue - op_s0.intrinsicValue) * op_s0.multiplier;
    dtime_value = (op_st.timeValue - op_s0.timeValue) * op_s0.multiplier;
    sss(i,:) = [num, d_px, d_iv, ddelta, dgamma, dtheta, dvega, dintrinsic_value, dtime_value];
    if detail
        fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n',  ...
            op_name, num, d_px, d_iv, ddelta, dgamma, dtheta, dvega, dintrinsic_value, dtime_value);
    end
    %�Ӻ�
    total_diff_result(2:end) = total_diff_result(2:end) +  sss(i, 2:end) * num;
    total_diff_result(1) = total_diff_result(1) + abs( num );
end

% iv ���ֵ
total_diff_result(3) = total_diff_result(3) / total_diff_result(1);

% �����λ��ǧԪ
total_diff_result(2)  = total_diff_result(2)/1000;
total_diff_result(4:end) = total_diff_result(4:end)/1000;
fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
    '�ϼ�(ǧԪ)', total_diff_result);

end

function [] = output_s_risk(s, L, detail)

if ~exist('detail', 'var')
    detail = false;
end
% ���
% ����� ��ͬ��
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [��3��1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50

% fprintf('S = %0.3f  |  %s\n', s.S, datestr(now));
fprintf('optName\t\tpos\t\taskP\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\tinValue\ttimeValue\n');
ttl = zeros(1,9);
for i = 1:L
    tmp = s.optPricers(i);
    num = s.num(i);
    %     if i == 2, tmp = put; end
    on      = tmp.optName(6:end);
    bid     = tmp.px * tmp.multiplier;
    iv      = tmp.sigma*100;
    delta1  = tmp.delta * tmp.multiplier * tmp.S*0.01;
    %     delta2  = tmp.delta * tmp.multiplier * tmp.S*0.02;
    gamma1  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0001/2 ;
    %     gamma2  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0004/2 ;
    %     delta1  = tmp.delta * tmp.multiplier * 0.01;
    %     delta2  = tmp.delta * tmp.multiplier * 0.02;
    %     gamma1  = tmp.gamma * tmp.multiplier * 0.0001/2;
    %     gamma2  = tmp.gamma * tmp.multiplier * 0.0004/2;
    theta   = tmp.theta * tmp.multiplier / 365 ;
    vega    = tmp.vega * tmp.multiplier * 0.01;
    intrinsic_value = tmp.intrinsicValue * tmp.multiplier;
    time_value = tmp.timeValue * tmp.multiplier;
    
    
    sss(i,:) = [num, bid, iv, delta1, gamma1, theta, vega, intrinsic_value, time_value];
    if detail
        fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n',  ...
            on, num, bid, iv, delta1,  gamma1, theta, vega, intrinsic_value, time_value);
    end
    % �Ӻ�
    ttl(2) = ttl(2) + sss(i, 2) * num;
    ttl(3) = ttl(3) + sss(i, 3) * abs(num);
    ttl(4:end) = ttl(4:end) + sss(i, 4:end) * num;
    %     ttl(2:end) = ttl(2:end) +  sss(i, 2:end) * num;
    ttl(1)  = ttl(1) + abs( num );
end


% iv ���ֵ
ttl(3) = ttl(3) / ttl(1);

% �����λ��ǧԪ
ttl(2)  = ttl(2)/1000;
ttl(4:end) = ttl(4:end)/1000;

fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
    '�ϼ�(ǧԪ)', ttl);
end