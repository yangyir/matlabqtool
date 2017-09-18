function monitor_positions_risk(positions, vs, description, S)
pa = positions;
L = pa.latest; 
if L == 0
    return;
end
L = length( pa.node );

s = Structure;

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
    s.num(j)    = num;
    quoteLast(j) = quote.last;
end

L = j;

%% ��structureһ��volsurface
s.volsurf = vs;

%% ע��structrue���г�����

s.S = S;
% s.r = 0.05;
s.r = quote.r;
s.inject_environment_params



%% ���ڣ�������sturcture�����
% ��
% TODO�� �������д���д��px
s.calcDelta;
s.calcGamma;
s.calcVega;
s.calcTheta;
s.calcRho;
s.calcIntrinsicValue;
s.calcTimeValue;

% ���
% ����� ��ͬ��
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��3��2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [��3��1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('%s \n', description);
fprintf('S = %0.3f  |  %s\n', s.S, datestr(now));
fprintf('optName\t\tpos\t\tpx\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\tinValue\ttimeValue\n');
ttl = zeros(1,9);
for i = 1:L
    tmp = s.optPricers(i);
    num = s.num(i);
%     if i == 2, tmp = put; end
    on      = tmp.optName(6:end);
%     px     = tmp.px * tmp.multiplier;
    px      = quoteLast(i) * tmp.multiplier;
    iv      = tmp.sigma*100;
    delta1  = tmp.delta * tmp.multiplier * tmp.S*0.01;
%     delta2  = tmp.delta * tmp.multiplier * tmp.S*0.02;
    gamma1  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0001/2 ;
%     gamma2  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0004/2 ;
    theta   = tmp.theta * tmp.multiplier / 365 ;
    vega    = tmp.vega * tmp.multiplier * 0.01;
    intrinsic_value = tmp.intrinsicValue * tmp.multiplier;
    time_value = tmp.timeValue * tmp.multiplier;
    
    
    sss(i,:) = [num, px, iv, delta1, gamma1, theta, vega, intrinsic_value, time_value];    
    fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n',  ...
         on, num, px, iv, delta1,  gamma1, theta, vega, intrinsic_value, time_value);
    
    % �Ӻ�
    ttl(2) = ttl(2) +  sss(i, 2) * num;
    ttl(4:end) = ttl(4:end) +  sss(i, 4:end) * num;

    ttl(1)  = ttl(1) + abs( num );
    ttl(3)  = ttl(3) + sss(i, 3) * abs(num);
end


% iv ���ֵ
ttl(3) = ttl(3) / ttl(1);

% �����λ��ǧԪ
ttl(2)  = ttl(2)/1000;
ttl(4:end) = ttl(4:end)/1000;

fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
     '�ϼ�(ǧԪ)', ttl);

 % �㾻ֵռ�ȣ���Ҫ�����book�ľ�ֵ
% fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
%      '�ϼ�(ǧԪ)', ttl);

%% ��delta==0 ��S��
[delta0_S, delta] = s.calc_delta0_S0(0.75*S, 1.25*S, 0.001);
fprintf('S0=%0.3f,  delta0=%0.4f\n', delta0_S, delta);
fprintf('-1%% S: %0.3f, +1%% S: %0.3f\n', delta0_S * 0.99, delta0_S * 1.01);







end