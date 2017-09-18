function [] = pricing_tf_design_3()
clear all; rehash 

 sigma = 0.3;
 r = 0.05;
 T = 60;
 S0 = 1;
 
 %% ���ɶ�������
 pricer = BinomialPricer;
%  pricer.set_params_from_optPricer(oi);
%% �ֶ����ò���
 pricer.T_ = T;
 pricer.S_ = S0;
 pricer.u_ = exp(sigma * sqrt(1/365));
 pricer.d_ = exp(-sigma * sqrt(1/365));

 pricer.r_ = r;

 %% ����payoff���㷽��
 pricer.payoff_handler = @payoff_design_3;
 pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
p3 = pricer.calc_price()


%% ����BSģ�ͣ����ò���
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.model = model;
mcp.payoffFunctionHandler = @payoff_design_3_MC;

p3_mc = mcp.calc_opt_price_mat()


end