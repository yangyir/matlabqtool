%% support file

% including basic bs formula, combination of options, gamma vs vol
% surface...


r = 0.05;
S = 1.9;
K = 2.0;
vol = 0.3;
T = 0.1;
[call_delta,put_delta] = blsdelta(S,K,r,T,vol,0);

call_delta

-put_delta
%blsgamma(S,K,r,0.2,vol,0)

K = 2.1;



%% function for the P/L turnning point

r = 0.03;
S = 1.6;
K = 1.9;
vol = 0.3;
T = 10/365;

[call_price,put_price] = blsprice(S,K,r,T,vol,0)

up_tp = K + call_price + put_price

down_tp = K - call_price - put_price




vol = 0.55;
TS = 0.001:1/365:0.4;
time2mature = 0.5-TS;
len = length(TS);
Theta = zeros(len,1);
K = 2400;

for j =1:len
    t = time2mature(j);
    [ctheta,ptheta] = blstheta(S,K,r,t,vol,0);
    Theta(j) = ctheta;
    
end
    
plot(time2mature,Theta)






%% plot the combination of options


u = 1.8:0.005:2.4;
K1 = 2.0;
K2 = 2.05;
S = 2.15;

r = 0.03;
vol = 0.35;
tau = 0.2;
[c1_price,p1_price] = blsprice(S,K1,r,tau,vol,0);
[c2_price,p2_price] = blsprice(S,K2,r,tau,vol,0);

ST = u;
c1_yield = max(0,ST - K1) - c1_price;
c2_yield = max(0,ST - K2) - c2_price;
p1_yield = max(0,K1 - ST) - p1_price;
p2_yield = max(0,K2 - ST) - p2_price;



% O-method

plot(ST,c2_yield-c1_yield -p1_yield)


% ITM Call bear spread

plot(ST,c1_yield-c2_yield -p1_yield)




% stock repair method
%plot(ST,c1_yield)
%plot(ST,c2_yield)
plot(ST,c1_yield -c2_yield)

S = 2.1;
% short put(K2) long put(K1)
plot(ST,p1_yield -p2_yield,'linewidth',2)
hold
plot(ST,zeros(length(ST),1),'r--')


S = 2.1;
% long call(K1) sell call(K2)
plot(ST,-c1_yield,'linewidth',2)
hold
plot(ST,zeros(length(ST),1),'r--')
%plot(ST,c1_yield -c2_yield)
legend('Short Call Yield')

plot(ST,-p1_yield,'linewidth',2)
hold
plot(ST,zeros(length(ST),1),'r--')
%plot(ST,c1_yield -c2_yield)
legend('Short Put Yield')

% sell call(K1) long put(K2)
plot(ST,c1_yield + p1_yield,'linewidth',2)
hold
plot(ST,zeros(length(ST),1),'r--')
legend('Long Strip Yield')


plot(ST,-c1_yield - p1_yield,'linewidth',2)
hold
plot(ST,zeros(length(ST),1),'r--')
legend('Short Strip Yield')


plot(ST,-c1_yield + p2_yield + ST - S)





%% test of early stop
% the result is not good enough
% setup
u = 1.7:0.001:2.4;
K1 = 1.95;
K2 = 2.0;
S = 2.086;

r = 0.03;
vol = 0.25;
tau = 42/365;
[c1_price,p1_price] = blsprice(S,K1,r,tau,vol,0);
[c2_price,p2_price] = blsprice(S,K2,r,tau,vol,0);

ST = u;
c1_yield = max(0,ST - K1) - c1_price;
c2_yield = max(0,ST - K2) - c2_price;
p1_yield = max(0,K1 - ST) - p1_price;
p2_yield = max(0,K2 - ST) - p2_price;
% O-method
% plot(ST,c2_yield-c1_yield -p1_yield)
hold on
% test of early stop
S2 = u;

figure()
hold on
for tau2 = tau : -(1/365) : 1/365
    % tau2 = 0.03;
    % S2 = 1.75:0.005:2.5;
    [nc1_price,np1_price] = blsprice(S2,K1,r,tau2,vol,0);
    [nc2_price,np2_price] = blsprice(S2,K2,r,tau2,vol,0);

    nc1_yield = nc1_price - c1_price;
    nc2_yield = nc2_price - c2_price;
    np1_yield = np1_price - p1_price;
    np2_yield = np2_price - p2_price;

    % figure()
    % hold on
    plot(S2,nc2_yield-nc1_yield -np1_yield)
end
plot(ST,c2_yield-c1_yield -p1_yield,'r')
grid

% calculate (conditional) expected payoff
S0 = S;
mu = 0.03;
pdf_ST = lognpdf(u, log(S0)+(mu-vol^2/2)*tau, vol*sqrt(tau)); % Unconditional pdf of ST
cpdf_ST = pdf_ST/(logncdf(u(end), log(S0)+(mu-vol^2/2)*tau, vol*sqrt(tau)) - logncdf(u(1), log(S0)+(mu-vol^2/2)*tau, vol*sqrt(tau))); % Conditional pdf of ST given u(1)<ST<u(end)
epayoff = sum((c2_yield-c1_yield -p1_yield).* cpdf_ST)*(u(2)-u(1)) % conditional expectation

epayoff = sum((c2_yield-c1_yield -p1_yield).* pdf_ST)*(u(2)-u(1))

epayoff = sum((c2_yield-c1_yield -p1_yield) .* pdf_ST/sum(pdf_ST)) % an alternative approach, more accurate
plot(u,pdf_ST,u,cpdf_ST)

%% test of early stop + hedging
% the result is not good enough
% setup
clear,clc
u = 1.75:0.005:2.5;
K1 = 2.05;
K2 = 2.1;
S = 2.15;

% hedging using a put
% long put at strike K3, start hedging at KS
K3 = 2.0;
KS = 2.0;

r = 0.03;
vol = 0.35;
T = 30;
tau_short = 30/365;         %近期的tau
tau_long = 60/365;          %远期的tau
[c1_price,p1_price] = blsprice(S,K1,r,tau_short,vol,0);
[c2_price,p2_price] = blsprice(S,K2,r,tau_short,vol,0);

TT = 15;        %启动hedging时straddle+call组合的到期时间,在该时间以前S未曾跌至KS
tau_ph = TT/365 + tau_long - tau_short;     %启动hedging时put的到期时间
[ch_price,ph_price] = blsprice(KS,K3,r,tau_ph,vol,0);

ST = u;
c1_yield = max(0,ST - K1) - c1_price;
c2_yield = max(0,ST - K2) - c2_price;
p1_yield = max(0,K1 - ST) - p1_price;
p2_yield = max(0,K2 - ST) - p2_price;
% O-method
% plot(ST,c2_yield-c1_yield -p1_yield)

% test of early stop
S2 = u;

% lenu = length(u);
% rec1 = zeros(lenu,T);
% rec2 = zeros(lenu,T);
% 
% iter = 1;

figure()
hold on
for tau2 = tau_short : -(1/365) : 1/365
    % tau2 = 0.03;
    % S2 = 1.75:0.005:2.5;
    if tau2 > TT/365
        S2 = u(u > KS);
        [nc1_price,np1_price] = blsprice(S2,K1,r,tau2,vol,0);
        [nc2_price,np2_price] = blsprice(S2,K2,r,tau2,vol,0);
        %[nch_price,nph_price] = blsprice(S2,K3,r,tau2 + tau_long - tau_short,vol,0);
        nc1_yield = nc1_price - c1_price;
        nc2_yield = nc2_price - c2_price;
        np1_yield = np1_price - p1_price;
        np2_yield = np2_price - p2_price;
        plot(S2, nc2_yield - nc1_yield - np1_yield)
    else
        S2 = u;
        [nc1_price,np1_price] = blsprice(S2,K1,r,tau2,vol,0);
        [nc2_price,np2_price] = blsprice(S2,K2,r,tau2,vol,0);
        [nch_price,nph_price] = blsprice(S2,K3,r,tau2 + tau_long - tau_short,vol,0);
        nc1_yield = nc1_price - c1_price;
        nc2_yield = nc2_price - c2_price;
        np1_yield = np1_price - p1_price;
        np2_yield = np2_price - p2_price;        
        nph_yield = nph_price - ph_price;
        plot(S2, nc2_yield - nc1_yield - np1_yield + nph_yield,'k')
    end

    % figure()
    % hold on
    %plot(S2,nc2_yield-nc1_yield -np1_yield)
%     rec1(:,iter) =  nc2_yield-nc1_yield -np1_yield;
%     rec2(:,iter) =  nph_price - ph_price;
%     iter = iter + 1;
end
grid

[~, temp] = blsprice(ST,K3,r,tau_long - tau_short,vol,0);
ph_yield = temp - ph_price;

plot(ST,c2_yield-c1_yield -p1_yield+ph_yield,'r')

% for i = 1:T
%     plot(S2,rec1(:,i))
%     
% end
% grid
% 
% 
% figure()
% hold on
% plot(ST,c2_yield-c1_yield -p1_yield,'r')
% 
% q = 2;
% for i = 1:q
%     plot(S2,rec1(:,i+T-q)+rec2(:,i)+0.04)
%     
% end
% 
% grid
% 
% 
% figure()
% hold on
% plot(ST,c2_yield-c1_yield -p1_yield,'r')
% 
% plot(S2,rec2(:,1))



%% test of broken butterfly superposition
% 
% setup
clear,clc
u = 1.75:0.005:2.5;
K1 = 2.05;
K2 = 2.1;
S0 = 2.15;


% superpose broken butterfly (K1_s, K2_s) when S drops to KS
KS = 2.0;
K1_s = 1.95;
K2_s = 2;

r = 0.03;
vol = 0.35;
T = 30/365;

[c1_price,p1_price] = blsprice(S0,K1,r,T,vol,0);
[c2_price,p2_price] = blsprice(S0,K2,r,T,vol,0);

TT = 15/365;        % time to maturity when S drops to KS

[c1_s_price,p1_s_price] = blsprice(KS,K1_s,r,TT,vol,0);
[c2_s_price,p2_s_price] = blsprice(KS,K2_s,r,TT,vol,0);

ST = u;
c1_yield = max(0,ST - K1) - c1_price;
c2_yield = max(0,ST - K2) - c2_price;
p1_yield = max(0,K1 - ST) - p1_price;
p2_yield = max(0,K2 - ST) - p2_price;

c1_s_yield = max(0,ST - K1_s) - c1_s_price;
c2_s_yield = max(0,ST - K2_s) - c2_s_price;
p1_s_yield = max(0,K1_s - ST) - p1_s_price;
p2_s_yield = max(0,K2_s - ST) - p2_s_price;



plot(ST,c2_yield-c1_yield -p1_yield,'b')
hold on
plot(ST,c2_yield-c1_yield -p1_yield +c2_s_yield-c1_s_yield -p1_s_yield ,'r')
grid
plot(ST,c2_s_yield-c1_s_yield -p1_s_yield ,'k')
% figure
% plot(ST,c2_yield-c1_yield -p1_yield,'b')
% hold on
% plot(ST,c2_yield-c1_yield -p1_yield +c2_s_yield-c1_s_yield  ,'r')
% grid

plot(ST,c2_s_yield-c1_s_yield -p1_s_yield ,'r')
grid


%% test of using tables 

t1 = table(s.num,'RowNames',{'call','put'});
%cellfun( @num2str , xx , 'UniformOutput' ,false )
xx = cellfun( @num2str , num2cell( m2tkCallinfo.xProps ) , ...
    'UniformOutput' , false );
t2 = table(s.num(1,:)',s.num(2,:)','RowNames',xx,'VariableNames',{'call','put'})

t2{ {'1.9'}  , {'call'}} = 5;


table2array(t2)



%% 计算50ETF期望payoff---------------------------%%

% 首先设置ST数据
ST = 1.6:0.05:2.8;
% 可以进行向量计算
payOff = s.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '期权组合的期望payoff为 = %.3f' , EF );
disp( str );




%% support of hedging error

S0 = 2;
mu = 0.05;
vol = 0.3;
len = 100;
S_path = zeros(len,1);
S_path(1) = S0;
% for i = 2:len
%     S_path(i) = S_path(i-1)*(1 + randn*vol*sqrt(1/250));
% end



% 2 白噪声
% for i = 2:len
%     S_path(i) = S0*(1 + randn*vol/sqrt(2)*sqrt(1/250));
% end
% real_vol = std(diff(S_path)./S_path(1:end-1))*sqrt(250)


% 3 模拟趋势
for i = 2:len
    S_path(i) = S0*(1 + mu*i/10 + randn*vol*sqrt(1/250));
end

real_vol = std(diff(S_path)./S_path(1:end-1))*sqrt(250);
S_ret = [0;diff(S_path)./S_path(1:end-1)*0.3/real_vol];
S_path = S0*cumprod(1+S_ret);
%plot(S_path)

real_vol = std(diff(S_path)./S_path(1:end-1))*sqrt(250);




% gamma vs vol

vol_seq = 0.15:0.01:0.7;
lenvol = length(vol_seq);
gamma_seq = zeros(lenvol,1);
tau = 0.1;
K = 1.8;
s = 2.3;
r = 0.05;

for i = 1:lenvol
gamma_seq(i) = blsgamma(s,K,r,tau,vol_seq(i),0);
end

figure()
plot(vol_seq,gamma_seq)
legend('gamma vs vol')




% delta vs vol

vol_seq = 0.15:0.01:0.7;
lenvol = length(vol_seq);
call_delta_seq = zeros(lenvol,1);
put_delta_seq = zeros(lenvol,1);
tau = 0.15;
K = 1.8;
s = 2.3;
r = 0.05;

for i = 1:lenvol
[call_delta_seq(i),put_delta_seq(i)] = blsdelta(s,K,r,tau,vol_seq(i),0);
end

% figure()
% plot(vol_seq,call_delta_seq)
% legend('call delta vs vol')

figure()
plot(vol_seq,-put_delta_seq)
legend('put delta vs vol')



% gamma vs vol surface
vol_seq = 0.15:0.01:0.5;
K = 1.5:0.1:2.7;
lenvol = length(vol_seq);
lenk = length(K);
gamma_seq = zeros(lenvol,lenk);
tau = 0.2;

s = 2;
r = 0.05;
for j = 1:lenk
for i = 1:lenvol
gamma_seq(i,j) = blsgamma(s,K(j),r,tau,vol_seq(i),0);
end
end


mesh(vol_seq,K,gamma_seq')

% delta vs vol surface

vol_seq = 0.15:0.01:0.5;
K = 1.5:0.1:2.7;
lenvol = length(vol_seq);
lenk = length(K);
call_delta_seq = zeros(lenvol,lenk);
put_delta_seq = zeros(lenvol,lenk);
tau = 0.2;

s = 2;
r = 0.05;
for j = 1:lenk
for i = 1:lenvol
[call_delta_seq(i,j),put_delta_seq(i,j)] = blsdelta(s,K(j),r,tau,vol_seq(i),0);
end
end

figure()
mesh(vol_seq,K,call_delta_seq')

%% check the profit of hedging long a call/put position

% sell a put
plot(data)
s = data/1000;
plot(s)

K1 = 2.03;
K2 = 2.6;
S = 2.0;
r = 0.03;
vol = 0.2;
tau = 0.1;
blsdelta(S,2.03,r,tau,vol,0) - blsdelta(S,2.05,r,tau,vol,0)



load('data_etf')
plot(data_etf)


%% the method of stock repair

start = 650;
y = data_etf(start:start+100);
len = length(y);


K1 = y(1);
r = 0.05;
vol = 0.3;
tau = 0.005;

d1 = blsdelta(K1,K1,r,tau,vol,0);
u = 0:0.001:0.4;
d2s = blsdelta(K1,K1+u,r,tau,vol,0);

[a,b] = min(abs(2*d2s-d1));

K2 = K1 + u(b)

%K2 = y(1) + 0.15;
%K3 = y(1) - 0.15;
cdelta1 = zeros(len,1);
pdelta1 = zeros(len,1);
cdelta2 = zeros(len,1);
pdelta2 = zeros(len,1);

for i = 1:len
    s = y(i);
    [c_delta,p_delta] = blsdelta(s,K1,r,tau,vol,0);
    cdelta1(i) = c_delta;
    pdelta1(i) = p_delta;
    [c_delta,p_delta] = blsdelta(s,K2,r,tau,vol,0);
    cdelta2(i) = c_delta;    
    pdelta2(i) = p_delta;
end
delta0 = (cdelta1 - 2*cdelta2)*100 ;
%plot(delta0)
delta0_pnl = [0;delta0(1:end-1).*(y(2:end)-y(1:end-1))];
delta0_cpnl = cumsum(delta0_pnl);

figure()
subplot(211)
plot(y)
subplot(212)
plot(delta0_cpnl)







% delta vs S

s_seq = 1.7:0.01:2.4;
lenvol = length(s_seq);
call_delta_seq = zeros(lenvol,1);
put_delta_seq = zeros(lenvol,1);
tau = 0.3;
K = 2.15;
s = 2.1;
r = 0.05;
vol = 0.25;

for i = 1:lenvol
[call_delta_seq(i),put_delta_seq(i)] = blsdelta(s_seq(i),K,r,tau,vol,0);
end



% figure()
% plot(s_seq,-put_delta_seq)
% legend('put delta vs vol')


call_delta_seq2 = zeros(lenvol,1);
put_delta_seq2 = zeros(lenvol,1);
K = 2.25;
r = 0.05;
vol = 0.25;

for i = 1:lenvol
[call_delta_seq2(i),put_delta_seq2(i)] = blsdelta(s_seq(i),K,r,tau,vol,0);
end

% figure()
% plot(vol_seq,call_delta_seq)
% legend('call delta vs vol')

figure()
plot(s_seq,-call_delta_seq+call_delta_seq2)
legend('delta vs S')


figure()
plot(s_seq,-put_delta_seq+put_delta_seq2)
legend('delta vs S')


%entropy
p1 = [1/3,1/3,1/3];
e1 = -sum(p1.*log(p1))

p1 = [1/200,100/200,99/200];
e1 = -sum(p1.*log(p1))

p1 = 0.02;
-p1.*log(p1)



