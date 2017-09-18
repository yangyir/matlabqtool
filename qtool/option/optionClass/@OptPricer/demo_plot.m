function [] = demo_plot(  )
%DEMO
%这是一个作图的Demo
% -----------------------
% 程刚，20160124
% 吴云峰，20160129，针对画图做了修改，适应了所有的图都能做的情况
% 吴云峰，20160215，针对calcPx的函数的变动，修改了一些作图的函数使得能够流畅画图

%% --------------------首先将变量进行赋予-------------------------

clc
clear all;
format compact
format short g;

tic;

% 填入期权信息
% tau|K|S|sigma|r有了
pricer = OptPricer;
pricer.fillOptInfo(1000000, '自制期权', 510050, datenum('2016-04-15'), 2.3, 'call')
pricer.currentDate = today;
pricer.calcTau;
% 填入S的信息
pricer.sigma = 0.3;
pricer.S = 2.5;
pricer.r = 0.05;
% 算期权价格
pricer.calcPx();

toc;

%% --------------------画图(沈杰增加|吴云峰修正)----------------------------

%% --------------greeks~S---------------
hfig = pricer.plot_optprice_S();

figure(101);
hold off; pricer.plot_optprice_tau();
hold off; pricer.plot_optprice_r();
hold off; pricer.plot_optprice_sigma();

%% -----------------新增-------------------
figure; pricer.plot_delta_S();
figure; pricer.plot_gamma_S();
figure; pricer.plot_vega_S();
figure; pricer.plot_theta_S();
figure; pricer.plot_rho_S();

%% ----------------greeks~tau--------------
figure(110);
subplot(2,3,1); pricer.plot_delta_tau();
subplot(2,3,2); pricer.plot_gamma_tau();
subplot(2,3,3); pricer.plot_vega_tau();
subplot(2,3,4); pricer.plot_theta_tau();
subplot(2,3,5); pricer.plot_rho_tau();


%% ----------------greeks~sigma--------------
h = pricer.plot_delta_sigma();
h = pricer.plot_gamma_sigma();
h = pricer.plot_vega_sigma();

figure(100)
subplot(2,1,1)
pricer.plot_theta_sigma();
subplot(2,1,2)
pricer.plot_rho_sigma();



%% -----------------greeks~K----------------
pricer.plot_delta_K();
pricer.plot_gamma_K();
pricer.plot_vega_K();
pricer.plot_theta_K();
pricer.plot_rho_K();

%% ---------------新增的4张图---------------

pricer.plot_px_delta_gamma_S();
pricer.plot_px_vega_sigma();
pricer.plot_px_theta_tau( );
pricer.plot_px_rho_r( );

%% ---------------新增的图------------------
pricer.plot_gamma_tau_mix();
pricer.plot_delta_tau_mix();
pricer.plot_rho_tau_mix();
pricer.plot_theta_tau_mix();



%% ---------------画图，画delta~S的图---------------

% pricer.S = 1.8:0.05:2.7;
% pricer.calcDelta();
% 
% figure;
% plot( pricer.S, pricer.delta);
% legend('delta');
% grid on;
% txt = '期权delta对S的函数图';
% self = pricer;
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,self.CP,datestr( self.T ), self.K, self.sigma*100, datestr(self.currentDate))
% title(txt)

end
