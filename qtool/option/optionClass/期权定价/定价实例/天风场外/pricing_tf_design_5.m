function [] = pricing_tf_design_5()
clear all; rehash 

 sigma = 0.5;
 r = 0.05;
 T = 60;
 S0 = 1;
 
 %% 生成二叉树根
 pricer = BinomialPricer;
%  pricer.set_params_from_optPricer(oi);
%% 手动设置参数
 pricer.T_ = T;
 pricer.S_ = S0;
 pricer.u_ = exp(sigma * sqrt(1/365));
 pricer.d_ = exp(-sigma * sqrt(1/365));

 pricer.r_ = r;

 %% 挂载payoff计算方法
 pricer.payoff_handler = @payoff_design_5;
 pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
p5 = pricer.calc_price()

%% 生成BS模型，设置参数
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.model = model;
mcp.payoffFunctionHandler = @payoff_design_5_MC;

p5_mc = mcp.calc_opt_price_mat()

end

