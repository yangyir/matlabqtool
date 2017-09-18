%% Volatility and Hedging Errors study 2

% 黄勉 20160203 参考 Jim Gatheral PPT volatility and hedging error 1999
% hekang 20160427 分别使用real vol/low vol/high vol进行delta hedge,并与理论价格走势进行比较

%% 验证如下结论 for CALL
% In the two scenarios analysed, if the option is sold and hedged at a
% volatility greater than the realised volatility, the trade makes money.
clear,clc
B = 1000;
PL_rec_high = nan(B,1);
PL_rec_low = nan(B,1);
H_minus_L = nan(B,1);
for xx = 1:B
waitbar(xx/B)

%% 生成数据  data generation
%，1 几何布朗运动;2 白噪声;3 模拟趋势
S0 = 2;
mu = 0.05;
vol = 0.3;
len = 100;
S_path = zeros(len,1);
S_path(1) = S0;
for i = 2:len
    S_path(i) = S_path(i-1)*(1 + randn*vol*sqrt(1/250));
end

% 2 白噪声
% for i = 2:100
%     S_path(i) = S0*(1 + randn*vol/sqrt(2)*sqrt(1/250));
% end


% 3 模拟趋势
% for i = 2:len
%     S_path(i) = S0*(1 + mu*i/10 + randn*vol*sqrt(1/250));
%     S_path(i) = S_path(i-1)*(1 + mu/10 + randn*vol*sqrt(1/250));  
% end
% 
real_vol = std(diff(S_path)./S_path(1:end-1))*sqrt(250);
S_ret = [0;diff(S_path)./S_path(1:end-1)*vol/real_vol];
S_path = S0*cumprod(1+S_ret);


%plot(S_path)



%% step 1, 不同的预设vol下，期权理论价格的路径

c0 = zeros(len,1); % 期权价格序列
p0 = zeros(len,1); % 期权价格序列
K = 1.7;
r = 0.05;
vol = 0.3;
%K_put = 1.8;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol,0);
    c0(i) = c_price; 
    %[c_price,p_price] = blsprice(s,K_put,r,tau,vol,0);
    p0(i) = p_price;     
end

c_low = zeros(len,1); % 期权价格序列
c_high = zeros(len,1); % 期权价格序列
vol_low = 0.15;
vol_high = 0.4;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol_low,0);
    c_low(i) = c_price; 
    [c_price,p_price] = blsprice(s,K,r,tau,vol_high,0);
    c_high(i) = c_price;     
end



%% step 2，不同的路径下，期权理论价格与对冲误差关系

delta0 = zeros(len,1);
delta_low = zeros(len,1);
delta_high = zeros(len,1);
gamma_low = zeros(len,1);
gamma_high = zeros(len,1);
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol,0);
    delta0(i) = c_delta;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_low,0);
    delta_low(i) = c_delta;  
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_high,0);
    delta_high(i) = c_delta;   
    gamma_low(i) = blsgamma(s,K,r,tau,vol_low,0);
    gamma_high(i) = blsgamma(s,K,r,tau,vol_high,0);
end

% delta_low = delta_low + delta0(1) - delta_low(1);
% delta_high = delta_high + delta0(1) - delta_high(1);

delta0_pnl = [0;delta0(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
delta0_cpnl = cumsum(delta0_pnl);
deltalow_pnl = [0;delta_low(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltalow_cpnl = cumsum(deltalow_pnl);
deltahigh_pnl = [0;delta_high(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltahigh_cpnl = cumsum(deltahigh_pnl);

%检查对冲效果 
% figure()
% plot(delta0_cpnl - p0 + p0(1))

%figure()
% subplot(3,1,1)
% plot(1:len,delta0_cpnl,'r',1:len,c0 - c0(1),'b')
% legend('DH P&L','Theoretical call P&L','Location','Best')
% subplot(3,1,2)
% plot(1:len,deltalow_cpnl,'r',1:len,c0 - c0(1),'b')
% legend('DH P&L(low vol)','Theoretical call P&L','Location','Best')
% subplot(3,1,3)
% plot(1:len,deltahigh_cpnl,'r',1:len,c0 - c0(1),'b')
% legend('DH P&L(high vol)','Theoretical call P&L','Location','Best')
% pause


% plot(1:len,deltalow_cpnl,'r',1:len,deltahigh_cpnl,'b',1:len,c0-c0(1),'k')
% legend('P&L(low vol)','P&L(high vol)','P&L(theoretical call)','Location','Best')
% pause
%% 验证如下结论
% In the two scenarios analysed, if the option is sold and hedged at a
% volatility greater than the realised volatility, the trade makes money.

% plot(S_path)

% sale and hedge pnl c_high(1) 
PL_rec_high(xx) = c_high(1) + deltahigh_cpnl(end) - c0(end);
PL_rec_low(xx) = c_high(1) + deltalow_cpnl(end) - c0(end);
H_minus_L(xx) = deltahigh_cpnl(end) - deltalow_cpnl(end);

end
mean_PL_high = mean(PL_rec_high)
ProfitRatio_high = length(PL_rec_high(PL_rec_high>0))/length(PL_rec_high)

mean_PL_low = mean(PL_rec_low)
ProfitRatio_low = length(PL_rec_low(PL_rec_low>0))/length(PL_rec_low)

mean_H_minus_L = mean(H_minus_L)
H_beat_L_Ratio = length(H_minus_L(H_minus_L>0))/length(H_minus_L)

%%  验证 PUT
% 其他设定与前面一样
clear,clc
B = 1000;
PL_rec_high = nan(B,1);
PL_rec_low = nan(B,1);
H_minus_L = nan(B,1);
for xx = 1:B

waitbar(xx/B)
%% 生成数据  data generation
%，1 几何布朗运动;2 白噪声;3 模拟趋势
S0 = 2;
mu = 0.05;
vol = 0.3;
len = 100;
S_path = zeros(len,1);
S_path(1) = S0;
for i = 2:len
    S_path(i) = S_path(i-1)*(1 + randn*vol*sqrt(1/250));
end

% 2 白噪声
% for i = 2:100
%     S_path(i) = S0*(1 + randn*vol*sqrt(1/250));
% end


% 3 模拟趋势
% for i = 2:len
%     S_path(i) = S0*(1 + mu*i/10 + randn*vol*sqrt(1/250));
%     S_path(i) = S_path(i-1)*(1 + mu/10 + randn*vol*sqrt(1/250));  
% end


%plot(S_path)



%% step 1, 不同的预设vol下，期权理论价格的路径

%c0 = zeros(len,1); % 期权价格序列
p0 = zeros(len,1); % 期权价格序列
K = 2.3;
r = 0.05;
vol = 0.3;
%K_put = 1.8;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol,0);
    c0(i) = c_price; 
    %[c_price,p_price] = blsprice(s,K,r,tau,vol,0);
    p0(i) = p_price;     
end

c_low = zeros(len,1); % 期权价格序列
c_high = zeros(len,1); % 期权价格序列
p_low = zeros(len,1); % 期权价格序列
p_high = zeros(len,1); % 期权价格序列

vol_low = 0.15;
vol_high = 0.45;
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_price,p_price] = blsprice(s,K,r,tau,vol_low,0);
    p_low(i) = p_price; 
    [c_price,p_price] = blsprice(s,K,r,tau,vol_high,0);
    p_high(i) = p_price;     
end



%% step 2，不同的路径下，期权理论价格与对冲误差关系

delta0 = zeros(len,1);
delta_low = zeros(len,1);
delta_high = zeros(len,1);
gamma_low = zeros(len,1);
gamma_high = zeros(len,1);
for i = 1:len
    s = S_path(i);
    tau = (len - i +1)/250;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol,0);
    delta0(i) = p_delta;
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_low,0);
    delta_low(i) = p_delta;  
    [c_delta,p_delta] = blsdelta(s,K,r,tau,vol_high,0);
    delta_high(i) = p_delta;   
    gamma_low(i) = blsgamma(s,K,r,tau,vol_low,0);
    gamma_high(i) = blsgamma(s,K,r,tau,vol_high,0);
end

delta_low = delta_low + delta0(1) - delta_low(1);
delta_high = delta_high + delta0(1) - delta_high(1);

delta0_pnl = [0;delta0(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
delta0_cpnl = cumsum(delta0_pnl);
deltalow_pnl = [0;delta_low(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltalow_cpnl = cumsum(deltalow_pnl);
deltahigh_pnl = [0;delta_high(1:end-1).*(S_path(2:end)-S_path(1:end-1))];
deltahigh_cpnl = cumsum(deltahigh_pnl);

%检查对冲效果 
% figure()
% plot(delta0_cpnl - p0 + p0(1))

%figure()
% subplot(3,1,1)
% plot(1:len,delta0_cpnl,'r',1:len,p0 - p0(1),'b')
% legend('DH P&L','Theoretical put P&L','Location','Best')
% subplot(3,1,2)
% plot(1:len,deltalow_cpnl,'r',1:len,p0 - p0(1),'b')
% legend('DH P&L(low vol)','Theoretical put P&L','Location','Best')
% subplot(3,1,3)
% plot(1:len,deltahigh_cpnl,'r',1:len,p0 - p0(1),'b')
% legend('DH P&L(high vol)','Theoretical put P&L','Location','Best')
% pause


% plot(1:len,deltalow_cpnl,'r',1:len,deltahigh_cpnl,'b',1:len,p0-p0(1),'k')
% legend('P&L(low vol)','P&L(high vol)','P&L(theoretical put)','Location','Best')
% pause

plot(1:len,deltalow_cpnl,'r',1:len,deltahigh_cpnl,'b',1:len,delta0_cpnl,'k')
legend('P&L(low vol)','P&L(high vol)','P&L(real vol)','Location','Best')
pause
%% 验证如下结论
% In the two scenarios analysed, if the option is sold and hedged at a
% volatility greater than the realised volatility, the trade makes money.

% plot(S_path)

% sale and hedge pnl c_high(1) 
PL_rec_high(xx) = p_high(1) + deltahigh_cpnl(end) - p0(end);
PL_rec_low(xx) = p_high(1) + deltalow_cpnl(end) - p0(end);
H_minus_L(xx) = deltahigh_cpnl(end) - deltalow_cpnl(end);


end
mean_PL_high = mean(PL_rec_high)
ProfitRatio_high = length(PL_rec_high(PL_rec_high>0))/length(PL_rec_high)

mean_PL_low = mean(PL_rec_low)
ProfitRatio_low = length(PL_rec_low(PL_rec_low>0))/length(PL_rec_low)

mean_H_minus_L = mean(H_minus_L)
H_beat_L_Ratio = length(H_minus_L(H_minus_L>0))/length(H_minus_L)





