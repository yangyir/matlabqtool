function [] = demo_plot(  )
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

tic;

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

toc;

%% --------------------��ͼ(�������|���Ʒ�����)----------------------------

%% --------------greeks~S---------------
hfig = pricer.plot_optprice_S();

figure(101);
hold off; pricer.plot_optprice_tau();
hold off; pricer.plot_optprice_r();
hold off; pricer.plot_optprice_sigma();

%% -----------------����-------------------
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

%% ---------------������4��ͼ---------------

pricer.plot_px_delta_gamma_S();
pricer.plot_px_vega_sigma();
pricer.plot_px_theta_tau( );
pricer.plot_px_rho_r( );

%% ---------------������ͼ------------------
pricer.plot_gamma_tau_mix();
pricer.plot_delta_tau_mix();
pricer.plot_rho_tau_mix();
pricer.plot_theta_tau_mix();



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
