function [] = demo(  )
%DEMO
%����һ����ͼ��Demo
% -----------------------
% �̸գ�20160124
% ���Ʒ壬20160129����Ի�ͼ�����޸ģ���Ӧ�����е�ͼ�����������
% ���Ʒ壬20160215�����calcPx�ĺ����ı䶯���޸���һЩ��ͼ�ĺ���ʹ���ܹ�������ͼ
% ���Ʒ壬20160316��������Ըո�Ŀ��������ͼ�ı䶯( ȫ�������һ�� )

%% --------------------���Ƚ��������и���-------------------------

clc
clear all;
format compact
format short g;

% ������Ȩ��Ϣ
% tau|K|S|sigma|r����
pricer = OptPricer;
pricer.fillOptInfo(1000000, '������Ȩ', 510050, datenum('2016-04-15'), 2.3, 'call')
pricer.currentDate = today;
pricer.calcTau;
% ����S����Ϣ
pricer.sigma = 0.3;
pricer.S = 2.5;
pricer.r = 0.05;
% ����Ȩ�۸�
pricer.calcPx();

%% --------------------��ͼ(�������|���Ʒ�����)----------------------------

%% --------------------delta�����ͼ--------------------------
hFig = pricer.plot_delta_K();
hFig = pricer.plot_delta_S();
hFig = pricer.plot_delta_sigma();
hFig = pricer.plot_delta_tau();
hFig = pricer.plot_delta_tau_mix();

%% -------------------gamma����ͼ------------------------------

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

%% ---------------��ͼ����px~S��ͼ����payoff---------------

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
% legend('��Ȩ����', '����payoff');
% grid on
% 
% self = pricer;
% txt = sprintf('%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', self.CP,datestr( self.T ), self.K, self.sigma*100, datestr(self.currentDate))
% title(txt)

%% ---------------��ͼ����delta~S��ͼ---------------

% pricer.S = 1.8:0.05:2.7;
% pricer.calcDelta();
% 
% figure;
% plot( pricer.S, pricer.delta);
% legend('delta');
% grid on;
% txt = '��Ȩdelta��S�ĺ���ͼ';
% self = pricer;
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,self.CP,datestr( self.T ), self.K, self.sigma*100, datestr(self.currentDate))
% title(txt)

end
