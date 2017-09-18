
function [ ] = demo2(  )
%DEMO2
% 从excel中初始化当日所有期权信息( OptPricer )
% 然后，建立一个structure，算组合Greeks，并且画图
% ---------------------------
% 吴云峰，20160125，构建OptPricer的期权组合并计算
% 吴云峰，20160130，构建Structure的作图
% 吴云峰，20160229，基于volsurface进行了重要的改动
% 吴云峰，20160316，进行了组合的修改

%% -------------构建OptPricer期权组合 -------------------%%

load sStructure

%% ----------------作图1--------------

hFig = sStructure.plot_delta_K;
hFig = sStructure.plot_delta_S;
hFig = sStructure.plot_delta_tau;
hFig = sStructure.plot_delta_tau_mix;

hFig = sStructure.plot_gamma_K;
hFig = sStructure.plot_gamma_S;
hFig = sStructure.plot_gamma_tau;
hFig = sStructure.plot_gamma_tau_mix;

%% ----------------作图2--------------

hFig = sStructure.plot_optprice_r;
hFig = sStructure.plot_optprice_S; 
hFig = sStructure.plot_optprice_sigma;
hFig = sStructure.plot_optprice_tau;

%% -----------------------------------------

hFig = sStructure.plot_px_delta_gamma_S;
hFig = sStructure.plot_px_rho_R;
hFig = sStructure.plot_px_theta_tau;
hFig = sStructure.plot_px_vega_sigma;

%% ----------------作图3--------------

hFig = sStructure.plot_rho_K;
hFig = sStructure.plot_rho_S;
hFig = sStructure.plot_rho_tau;
hFig = sStructure.plot_rho_tau_mix;

%% -----------------作图4-------------------

hFig = sStructure.plot_vega_K;
hFig = sStructure.plot_vega_S;
hFig = sStructure.plot_vega_tau;

%% ----------------作图5--------------

hFig = sStructure.plot_theta_K;
hFig = sStructure.plot_theta_S;
hFig = sStructure.plot_theta_tau;
hFig = sStructure.plot_theta_tau_mix;

%% ----------------EOF---------------------

%--------------构建的组合---------------

% % 首先基于OptPricer获取今日行情的OptPricer
% [ ~ , m2tkCallPricer, m2tkPutPricer ] = OptPricer.init_from_sse_excel;
% % 然后随机的获取三个组合
% pricerStructure( 1 , 3 ) = OptPricer;
% pricerStructure( 1 , 1 ) = m2tkCallPricer.data( 1 , 1 );
% pricerStructure( 1 , 2 ) = m2tkCallPricer.data( 1 , 2 );
% pricerStructure( 1 , 3 ) = m2tkPutPricer.data( 1 , 1 );
% % 然后再获取构建的volsurf( VolSurface )
% % 波动率Surface的数据vs
% load vs
% 
% % 构建一个新的Structure
% sStructure = Structure;
% sStructure.volsurf = vs;
% % 当前的S的价格
% sStructure.S = vs.S;    
% % 当前的无风险的利率
% sStructure.r = 0.03;
% sStructure.optPricers = pricerStructure;
% sStructure.num = [ 1 2 3 ];
% % 得先将环境变量的值进行赋予
% sStructure.inject_environment_params;
% 
% % 计算期权组合的价值
% sStructure.calcPx()
% % 计算期权组合的时间价值
% sStructure.calcTimeValue()
% % 计算期权组合的Delta
% sStructure.calcDelta()
% % 计算期权组合的Gamma
% sStructure.calcGamma()
% % 计算期权组合的Vega
% sStructure.calcVega()
% % 计算期权组合的Theta
% sStructure.calcTheta()
% % 计算期权组合的Rho
% sStructure.calcRho()


end

