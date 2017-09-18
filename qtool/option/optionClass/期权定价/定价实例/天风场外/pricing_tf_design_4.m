function [] = pricing_tf_design_4()
clear all; rehash 

 sigma = 0.3;
 r = 0.05;
 T = 43;
 S0 = 1;
 
 %% ����BSģ�ͣ����ò���
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% ����MonteCarlo������
 pricer = MonteCarloPricer;
 pricer.model = model;
 pricer.payoffFunctionHandler = @payoff_design_4_MC;

% p2_rc = pricer.calc_price_recusive()
p4 = pricer.calc_opt_price_mat

end

