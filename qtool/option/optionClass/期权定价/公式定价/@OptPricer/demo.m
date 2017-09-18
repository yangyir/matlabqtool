function [] = demo(  )
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

% 填入期权信息
% tau|K|S|sigma|r有了
pricer = OptPricer;
pricer.fillOptInfo(1000000, '自制期权', 510050, datenum('2016-03-15'), 2.3, 'call')
pricer.currentDate = today;
pricer.calcTau;
% 填入S的信息
pricer.sigma = 0.3;
pricer.S = 2.5;
pricer.r = 0.05;
% 算期权价格
pricer.calcPx();

%% --------------------画图(沈杰增加|吴云峰修正)----------------------------

%% --------------greeks~S---------------

pricer.plot_optprice_S();
pricer.plot_optprice_tau();
pricer.plot_optprice_r();
pricer.plot_optprice_sigma();

%% -----------------新增-------------------
pricer.plot_delta_S();
pricer.plot_gamma_S();
pricer.plot_vega_S();
pricer.plot_theta_S();
pricer.plot_rho_S();

%% ----------------greeks~tau--------------
pricer.plot_delta_tau();
pricer.plot_gamma_tau();
pricer.plot_gamma_tau_mix();
pricer.plot_vega_tau();
pricer.plot_theta_tau();
pricer.plot_rho_tau();

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
pricer.plot_px_rho_R( );

%% ---------------新增的图------------------

pricer.plot_delta_tau_mix();
pricer.plot_rho_tau_mix();
pricer.plot_theta_tau_mix();

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
