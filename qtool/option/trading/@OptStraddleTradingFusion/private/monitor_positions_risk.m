function monitor_positions_risk(positions, vs, description, S)
pa = positions;
L = pa.latest; 
if L == 0
    return;
end
L = length( pa.node );

s = Structure;

%% 把position放入s.optPricer,用j来计数在有效期内的期权持仓。
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

%% 给structure一个volsurface
s.volsurf = vs;

%% 注入structrue的市场变量

s.S = S;
% s.r = 0.05;
s.r = quote.r;
s.inject_environment_params



%% 现在，可以用sturcture算风险
% 算
% TODO： 这里面有错，改写了px
s.calcDelta;
s.calcGamma;
s.calcVega;
s.calcTheta;
s.calcRho;
s.calcIntrinsicValue;
s.calcTimeValue;

% 输出
% 输出， 形同：
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [沽3月1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
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
    
    % 加和
    ttl(2) = ttl(2) +  sss(i, 2) * num;
    ttl(4:end) = ttl(4:end) +  sss(i, 4:end) * num;

    ttl(1)  = ttl(1) + abs( num );
    ttl(3)  = ttl(3) + sss(i, 3) * abs(num);
end


% iv 求均值
ttl(3) = ttl(3) / ttl(1);

% 风险项单位用千元
ttl(2)  = ttl(2)/1000;
ttl(4:end) = ttl(4:end)/1000;

fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
     '合计(千元)', ttl);

 % 算净值占比，需要用这个book的净值
% fprintf('[%s]\t%6.0f\t%4.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %4.0f\t %4.0f\n', ...
%      '合计(千元)', ttl);

%% 算delta==0 的S点
[delta0_S, delta] = s.calc_delta0_S0(0.75*S, 1.25*S, 0.001);
fprintf('S0=%0.3f,  delta0=%0.4f\n', delta0_S, delta);
fprintf('-1%% S: %0.3f, +1%% S: %0.3f\n', delta0_S * 0.99, delta0_S * 1.01);







end