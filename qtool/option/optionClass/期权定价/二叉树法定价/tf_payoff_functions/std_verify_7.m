clear all; rehash;

sigma = 0.3;
r = 0.05;
T = 90;
S0 = 1;

oi_1 = OptPricer;
oi_1.sigma = sigma;
oi_1.r = r;
oi_1.S = S0;
oi_1.K = 1;
oi_1.T = (today + T);
price1 = oi_1.calcPx()

oi_2 = OptPricer;
oi_2.sigma = sigma;
oi_2.r = r;
oi_2.S = S0;
oi_2.K = 1.15;
oi_2.T = (today + T);
price2 = oi_2.calcPx()

cost = (1 / 0.15) * (price1 - price2)

%         sigma = 0.3;              % 波动率
%         S;                        % underlier的当前价格
%         r = 0.05;    