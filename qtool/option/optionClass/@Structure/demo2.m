
function [ ] = demo2(  )
%DEMO2
% ��excel�г�ʼ������������Ȩ��Ϣ( OptPricer )
% Ȼ�󣬽���һ��structure�������Greeks�����һ�ͼ
% ---------------------------
% ���Ʒ壬20160125������OptPricer����Ȩ��ϲ�����
% ���Ʒ壬20160130������Structure����ͼ
% ���Ʒ壬20160229������volsurface��������Ҫ�ĸĶ�
% ���Ʒ壬20160316����������ϵ��޸�

%% -------------����OptPricer��Ȩ��� -------------------%%

load sStructure

%% ----------------��ͼ1--------------

hFig = sStructure.plot_delta_K;
hFig = sStructure.plot_delta_S;
hFig = sStructure.plot_delta_tau;
hFig = sStructure.plot_delta_tau_mix;

hFig = sStructure.plot_gamma_K;
hFig = sStructure.plot_gamma_S;
hFig = sStructure.plot_gamma_tau;
hFig = sStructure.plot_gamma_tau_mix;

%% ----------------��ͼ2--------------

hFig = sStructure.plot_optprice_r;
hFig = sStructure.plot_optprice_S; 
hFig = sStructure.plot_optprice_sigma;
hFig = sStructure.plot_optprice_tau;

%% -----------------------------------------

hFig = sStructure.plot_px_delta_gamma_S;
hFig = sStructure.plot_px_rho_R;
hFig = sStructure.plot_px_theta_tau;
hFig = sStructure.plot_px_vega_sigma;

%% ----------------��ͼ3--------------

hFig = sStructure.plot_rho_K;
hFig = sStructure.plot_rho_S;
hFig = sStructure.plot_rho_tau;
hFig = sStructure.plot_rho_tau_mix;

%% -----------------��ͼ4-------------------

hFig = sStructure.plot_vega_K;
hFig = sStructure.plot_vega_S;
hFig = sStructure.plot_vega_tau;

%% ----------------��ͼ5--------------

hFig = sStructure.plot_theta_K;
hFig = sStructure.plot_theta_S;
hFig = sStructure.plot_theta_tau;
hFig = sStructure.plot_theta_tau_mix;

%% ----------------EOF---------------------

%--------------���������---------------

% % ���Ȼ���OptPricer��ȡ���������OptPricer
% [ ~ , m2tkCallPricer, m2tkPutPricer ] = OptPricer.init_from_sse_excel;
% % Ȼ������Ļ�ȡ�������
% pricerStructure( 1 , 3 ) = OptPricer;
% pricerStructure( 1 , 1 ) = m2tkCallPricer.data( 1 , 1 );
% pricerStructure( 1 , 2 ) = m2tkCallPricer.data( 1 , 2 );
% pricerStructure( 1 , 3 ) = m2tkPutPricer.data( 1 , 1 );
% % Ȼ���ٻ�ȡ������volsurf( VolSurface )
% % ������Surface������vs
% load vs
% 
% % ����һ���µ�Structure
% sStructure = Structure;
% sStructure.volsurf = vs;
% % ��ǰ��S�ļ۸�
% sStructure.S = vs.S;    
% % ��ǰ���޷��յ�����
% sStructure.r = 0.03;
% sStructure.optPricers = pricerStructure;
% sStructure.num = [ 1 2 3 ];
% % ���Ƚ�����������ֵ���и���
% sStructure.inject_environment_params;
% 
% % ������Ȩ��ϵļ�ֵ
% sStructure.calcPx()
% % ������Ȩ��ϵ�ʱ���ֵ
% sStructure.calcTimeValue()
% % ������Ȩ��ϵ�Delta
% sStructure.calcDelta()
% % ������Ȩ��ϵ�Gamma
% sStructure.calcGamma()
% % ������Ȩ��ϵ�Vega
% sStructure.calcVega()
% % ������Ȩ��ϵ�Theta
% sStructure.calcTheta()
% % ������Ȩ��ϵ�Rho
% sStructure.calcRho()


end

