%% volatility and hedging error study 1
% 黄勉 20160202，参考 Jim Gatheral PPT volatility and hedging error 1999

% 验证如下结论
% If the market is range bound, hedging a short option
% position at a lower vol. hurts, and we need to use large vol.
% If the market is trending, hedging a short option
% position at a higher vol. hurts, and we need to use small vol.


% 以上结论仅验证对 ATM call 成立
% 对 deep ITM call 不成立

%% 1--- 研究在各种预设的vol情形下，Delta对冲的误差



%% 生成数据  data generation
%，1 几何布朗运动;2 白噪声;3 模拟趋势

% 1 几何布朗运动
S0 = 2;
mu = 0.05;
vol = 0.3;
len = 100;
S_path = zeros(len,1);
S_path(1) = S0;
for i = 2:100
    S_path(i) = S_path(i-1)*(1 + randn*vol*sqrt(1/250));
end

% 2 白噪声
% for i = 2:100
%     S_path(i) = S0*(1 + randn*vol*sqrt(1/250));
% end


% 3 模拟趋势
% for i = 2:100
%     S_path(i) = S0*(1 + mu*i/10 + randn*vol*sqrt(1/250));
% end

%plot(S_path)


%% step 1, 不同的预设vol下，期权理论价格的路径

c0 = zeros(len,1); % 期权价格序列
p0 = zeros(len,1); % 期权价格序列
K = 2.4;
r = 0.05;
vol = 0.3;
K_put = 1.8;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol,0);
    c0(i) = c_price; 
    [c_price,p_price] = blsprice(s,K_put,r,tau,vol,0);
    p0(i) = p_price;     
end

c_low = zeros(len,1); % 期权价格序列
c_high = zeros(len,1); % 期权价格序列
vol_low = 0.15;
vol_high = 0.6;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol_low,0);
    c_low(i) = c_price; 
    [c_price,p_price] = blsprice(s,K,r,tau,vol_high,0);
    c_high(i) = c_price;     
end

init1 = c_high(1)-c0(1)
init2 = c_low(1)-c0(1)

% figure()
% subplot(211)
% plot(S_path)
% subplot(212)
% hold on 
% plot(c_low-c0,'b')
% plot(c_high-c0,'r')

%% step 2，不同的路径下，期权理论价格与对冲误差关系

delta0 = zeros(len,1);
delta_low = zeros(len,1);
delta_high = zeros(len,1);
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol,0);
    delta0(i) = c_delta;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_low,0);
    delta_low(i) = c_delta;  
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_high,0);
    delta_high(i) = c_delta;    
end

delta0_pnl = [0;delta0(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
delta0_cpnl = cumsum(delta0_pnl);
deltalow_pnl = [0;delta_low(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltalow_cpnl = cumsum(deltalow_pnl);
deltahigh_pnl = [0;delta_high(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltahigh_cpnl = cumsum(deltahigh_pnl);

% figure()
% plot(delta0_cpnl - c0 + c0(1))

figure()
plot(delta_high)




end1 = deltahigh_cpnl(end) - c_high(end) + c_high(1)
end2 = deltalow_cpnl(end) - c_low(end) + c_low(1)

(end1 - end2) - (init1 - init2)

%[p0(1),p0(end)]


figure()
subplot(211)
plot(S_path)
subplot(212)
plot(deltahigh_cpnl - deltalow_cpnl)




figure()
subplot(311)
plot(S_path)
subplot(312)
hold on 
plot(deltalow_cpnl - c_low + c_low(1),'b')
subplot(313)
plot(deltahigh_cpnl - c_high + c_high(1),'b')





%plot(deltahigh_cpnl - deltalow_cpnl)



%% step 3，组合对冲效果

figure()
plot(S_path)
hold
plot(deltahigh_cpnl - deltalow_cpnl)


