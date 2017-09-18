function [ ] = demo3()
%根据需要使用者自己制定
clc
clear
format compact
format short g
rehash;

pricer1 = OptPricer;
copy = pricer1.getCopy();
copy.K = 2;% 根据需要自己定
copy.T = 3;% 根据需要自己定
copy.CP = 'call'; % 选择期权类型

copy.fillOptInfo(1000000, '自选期权', 510050, datenum('2016-03-15'), copy.K, copy.CP) %产生期权
copy.currentDate = today;
copy.calcTau;

%%
center = copy.S;
try
    wrong =  center == 0 || isempty(center) || isnan(center);
    if wrong,  center = copy.K; end
catch e
    center = copy.K;
end
mn = center * 0.7;
mx = center * 1.3;
S  = [0:19] * (mx-mn)/20 + mn;

copy.S = S;
copy.sigma = 0.3;
copy.calcPx() ;
copy.calcDelta() ;
copy.calcGamma() ;

%% 做图
% figure
% subplot(311)
% plot_optprice_S( copy  )
% subplot(312)
% plot_delta_S( copy  )
%
figure
subplot(311)
plot(copy.S,copy.px)
txt = '期权Px～S Delta～S Gamma～S函数图';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f,  K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('S')
ylabel('px')

% % 加画当前点
% hold on
% pricer1.calcPx();
% plot( pricer1.S,pricer1.px, 'or');

subplot(312)
plot(copy.S,copy.delta)
txt = sprintf('sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('S')
ylabel('delta')

subplot(313)
plot(copy.S,copy.gamma)
txt = sprintf('sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('S')
ylabel('gamma')

%% px～vol vega～vol
copy.S = pricer1.S;
copy.sigma = [0.1:0.05:0.8];
copy.calcPx() ;
copy.calcDelta() ;
copy.calcGamma() ;
copy.calcVega() ;
figure
subplot(211)
plot(copy.sigma,copy.px)
txt = '期权px～vol vega～vol函数图';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)

xlabel('vol')
ylabel('px')
subplot(212)
plot(copy.sigma,copy.vega)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f',...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('vol')
ylabel('vega')

%% px～tau theta～tau
copy.S = pricer1.S;
copy.sigma = pricer1.sigma;
longend = ceil(copy.tau * 10 ) / 10;
tau =   0.05 * [1:20] * longend ;
copy.tau = tau;
copy.calcPx() ;
copy.calcTheta() ;
figure
subplot(211)
plot(copy.tau,copy.px)
txt = '期权px～tau theta～tau函数图';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('px')
subplot(212)
plot(copy.tau,copy.theta)
txt = sprintf(' sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('theta')
%% px～r vega～r
copy.S = pricer1.S;
copy.sigma = pricer1.sigma;
copy.r = [0.01:0.01:0.1];
copy.tau = pricer1.tau;
copy.calcPx() ;
copy.calcRho() ;
figure
subplot(211)
plot(copy.r,copy.px)
txt = '期权px～r vega～r函数图';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('px')
subplot(212)
plot(copy.r,copy.rho)
txt = sprintf('sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('rho')

%% Delta(S,sigma,tau,r)
%调整S的范围
center = pricer1.S;
try
    wrong =  center == 0 || isempty(center) || isnan(center);
    if wrong,  center = copy.K; end
catch e
    center = copy.K;
end
mn = center * 0.7;
mx = center * 1.3;
S  = [0:19] * (mx-mn)/20 + mn;

copy.S = S;
copy.r = pricer1.r;
copy.calcDelta() ;
figure
hold on
subplot(221)
plot(copy.S,copy.delta)
txt = 'Delta(S,sigma,tau,r)';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('s')
ylabel('delta')

%对sigma的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = [0.1:0.05:0.8];
copy.calcDelta() ;
subplot(222)
plot(copy.sigma,copy.delta)
txt = sprintf(' sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('sigma')
ylabel('delta')

%对tau的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = pricer1.sigma;
longend = ceil( copy.tau * 10 ) / 10;
tau =   0.05 * [1:20] * longend ;
copy.tau = tau;
copy.calcDelta() ;
subplot(223)
plot(copy.tau,copy.delta)
txt = sprintf(' sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('delta')

%对r的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = pricer1.sigma;
copy.tau = pricer1.tau;
copy.r = [0.01:0.01:0.1];
copy.calcDelta() ;
subplot(224)
plot(copy.r,copy.delta)
txt = sprintf(' sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f',...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('delta')
%% Gamma(S,sigma,tau,r)

%调整S的范围
center = pricer1.S;
try
    wrong =  center == 0 || isempty(center) || isnan(center);
    if wrong,  center = copy.K; end
catch e
    center = copy.K;
end
mn = center * 0.7;
mx = center * 1.3;
S  = [0:19] * (mx-mn)/20 + mn;

copy.S = S;
copy.r = pricer1.r;
copy.calcGamma() ;
figure
hold on
subplot(221)
plot(copy.S,copy.gamma)
txt = ' Gamma(S,sigma,tau,r)';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S);
title(txt)
xlabel('s')
ylabel('gamma')

%对sigma的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = [0.1:0.05:0.8];
copy.calcGamma() ;
subplot(222)
plot(copy.sigma,copy.gamma)
txt = sprintf('  t=%s, S=%0.3f, K=%0.2f',...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('sigma')
ylabel('gamma')

%对tau的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = pricer1.sigma;
longend = ceil( copy.tau * 10 ) / 10;
tau =   0.05 * [1:20] * longend ;
copy.tau = tau;
copy.calcGamma() ;
subplot(223)
plot(copy.tau,copy.gamma)
txt = sprintf('  t=%s, S=%0.3f, K=%0.2f',...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('gamma')

%对r的调整
copy.S = pricer1.S;
copy.sigma = pricer1.sigma;
copy.r = [0.01:0.01:0.1];
copy.tau = pricer1.tau;
copy.calcGamma() ;
subplot(224)
plot(copy.r,copy.delta)
txt = sprintf('  t=%s, S=%0.3f, K=%0.2f',...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('gamma')
%% Vega(S,sigma,tau,r)
%调整S的范围
center = pricer1.S;
try
    wrong =  center == 0 || isempty(center) || isnan(center);
    if wrong,  center = copy.K; end
catch e
    center = copy.K;
end
mn = center * 0.7;
mx = center * 1.3;
S  = [0:19] * (mx-mn)/20 + mn;

copy.S = S;
copy.r = pricer1.r;
copy.calcVega() ;
figure
hold on
subplot(221)
plot(copy.S,copy.vega)
txt = 'Vega(S,sigma,tau,r)';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('s')
ylabel('vega')

%对sigma的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = [0.1:0.05:0.8];
copy.calcVega() ;
subplot(222)
plot(copy.sigma,copy.vega)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('sigma')
ylabel('vega')

%对tau的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = pricer1.sigma;
longend = ceil( copy.tau * 10 ) / 10;
tau =   0.05 * [1:20] * longend ;
copy.tau = tau;
copy.calcVega() ;
subplot(223)
plot(copy.tau,copy.vega)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('vega')

%对r的调整
copy.S = pricer1.S;
copy.sigma = pricer1.sigma;
copy.r = [0.01:0.01:0.1];
copy.tau = pricer1.tau;
copy.calcVega() ;
subplot(224)
plot(copy.r,copy.vega)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('vega')
%% Theta(S,sigma,tau,r)
%调整S的范围
center = pricer1.S;
try
    wrong =  center == 0 || isempty(center) || isnan(center);
    if wrong,  center = copy.K; end
catch e
    center = copy.K;
end
mn = center * 0.7;
mx = center * 1.3;
S  = [0:19] * (mx-mn)/20 + mn;

copy.S = S;
copy.r = pricer1.r;
copy.calcTheta() ;
figure
hold on
subplot(221)
plot(copy.S,copy.theta)
txt = 'Theta(S,sigma,tau,r)';
txt = sprintf('%s\n sigma=%0.0f%%, t=%s, S=%0.3f, K=%0.2f', txt,...
    pricer1.sigma*100, datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('s')
ylabel('theta')

%对sigma的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = [0.1:0.05:0.8];
copy.calcTheta() ;
subplot(222)
plot(copy.sigma,copy.theta)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('sigma')
ylabel('theta')

%对tau的调整
copy.S = pricer1.S;
copy.r = pricer1.r;
copy.sigma = pricer1.sigma;
longend = ceil( copy.tau * 10 ) / 10;
tau =   0.05 * [1:20] * longend ;
copy.tau = tau;
copy.calcTheta() ;
subplot(223)
plot(copy.tau,copy.theta)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('tau')
ylabel('theta')

%对r的调整
copy.S = pricer1.S;
copy.sigma = pricer1.sigma;
copy.r = [0.01:0.01:0.1];
copy.tau = pricer1.tau;
copy.calcTheta() ;
subplot(224)
plot(copy.r,copy.theta)
txt = sprintf(' t=%s, S=%0.3f, K=%0.2f', ...
    datestr(pricer1.currentDate,'yyyymmdd'), pricer1.S, pricer1.K);
title(txt)
xlabel('r')
ylabel('theta')
end