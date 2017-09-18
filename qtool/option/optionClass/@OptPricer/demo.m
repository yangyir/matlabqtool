function [] = demo(  )
%DEMO
%这是一个作图的Demo
% -----------------------
% 程刚，20160124
% 吴云峰，20160129，针对画图做了修改，适应了所有的图都能做的情况
% 吴云峰，20160215，针对calcPx的函数的变动，修改了一些作图的函数使得能够流畅画图
% 吴云峰，20160316，重新针对刚哥的框架做了作图的变动( 全部检查了一遍 )

%% --------------------首先将变量进行赋予-------------------------

clc
clear all;
format compact
format short g;

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

%% --------------------画图(沈杰增加|吴云峰修正)----------------------------

%% --------------------delta类的作图--------------------------
hFig = pricer.plot_delta_K();
hFig = pricer.plot_delta_S();
hFig = pricer.plot_delta_sigma();
hFig = pricer.plot_delta_tau();
hFig = pricer.plot_delta_tau_mix();

%% -------------------gamma类作图------------------------------

hFig = pricer.plot_gamma_K();
hFig = pricer.plot_gamma_S();
hFig = pricer.plot_gamma_sigma();
hFig = pricer.plot_gamma_tau();
hFig = pricer.plot_gamma_tau_mix();

%% --------------greeks~S---------------

hFig = pricer.plot_optprice_S();
hFig = pricer.plot_optprice_tau();
hFig = pricer.plot_optprice_r();
hFig = pricer.plot_optprice_sigma();

%% --------------------px--------------------

hFig = pricer.plot_px_delta_gamma_S();
hFig = pricer.plot_px_vega_sigma();
hFig = pricer.plot_px_theta_tau();
hFig = pricer.plot_px_rho_r();

%% ------------------rho----------------------

hFig = pricer.plot_rho_K();
hFig = pricer.plot_rho_S();
hFig = pricer.plot_rho_tau();
hFig = pricer.plot_rho_sigma();
hFig = pricer.plot_rho_tau_mix();

%% -----------------theta-------------------

hFig = pricer.plot_theta_S();
hFig = pricer.plot_theta_tau();
hFig = pricer.plot_theta_K();
hFig = pricer.plot_theta_sigma();
hFig = pricer.plot_theta_tau_mix();

%% ----------------vega--------------

hFig = pricer.plot_vega_tau();
hFig = pricer.plot_vega_S();
hFig = pricer.plot_vega_K();
hFig = pricer.plot_vega_sigma();

%% ---------------画图，画px~S的图，带payoff---------------

% pricer.S = 1.8:0.05:2.7;
% pricer.calcPx();
% 
% pricer.ST = 1.8:0.05:2.7;
% pricer.calcPayoff();
% 
% figure;
% plot(pricer.S, pricer.px);
% hold on
% plot(pricer.ST, pricer.payoff, 'k');
% legend('期权定价', '到期payoff');
% grid on
% 
% self = pricer;
% txt = sprintf('%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', self.CP,datestr( self.T ), self.K, self.sigma*100, datestr(self.currentDate))
% title(txt)

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
