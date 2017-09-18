function pricing_tf_design_2()
clear all; rehash 

 sigma = 0.3;
 r = 0.05;
 T = 30;
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
 pricer.payoff_handler = @payoff_design_2;
 pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
p2 = pricer.calc_price()

 %% ����BSģ�ͣ����ò���
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% ����MonteCarlo������
 pricer = MonteCarloPricer;
 pricer.model = model;
 pricer.payoffFunctionHandler = @payoff_design_2_MC;

% p2_rc = pricer.calc_price_recusive()
p2_mc = pricer.calc_opt_price_mat

end