function [] = demo(  )
%DEMO
%����һ����ͼ��Demo
% -----------------------
% �̸գ�20160124
% ���Ʒ壬20160129����Ի�ͼ�����޸ģ���Ӧ�����е�ͼ�����������
% ���Ʒ壬20160215�����calcPx�ĺ����ı䶯���޸���һЩ��ͼ�ĺ���ʹ���ܹ�������ͼ

%% --------------------���Ƚ��������и���-------------------------

clc
clear all;
format compact
format short g;

% ������Ȩ��Ϣ
% tau|K|S|sigma|r����
pricer = OptPricer;
pricer.fillOptInfo(1000000, '������Ȩ', 510050, datenum('2016-03-15'), 2.3, 'call')
pricer.currentDate = today;
pricer.calcTau;
% ����S����Ϣ
pricer.sigma = 0.3;
pricer.S = 2.5;
pricer.r = 0.05;
% ����Ȩ�۸�
pricer.calcPx();

%% --------------------��ͼ(�������|���Ʒ�����)----------------------------

%% --------------greeks~S---------------

pricer.plot_optprice_S();
pricer.plot_optprice_tau();
pricer.plot_optprice_r();
pricer.plot_optprice_sigma();

%% -----------------����-------------------
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

%% ---------------������4��ͼ---------------

pricer.plot_px_delta_gamma_S();
pricer.plot_px_vega_sigma();
pricer.plot_px_theta_tau( );
pricer.plot_px_rho_R( );

%% ---------------������ͼ------------------

pricer.plot_delta_tau_mix();
pricer.plot_rho_tau_mix();
pricer.plot_theta_tau_mix();

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
