function [] = pricing_tf_design_1()
clear all; rehash 

 sigma = 0.3;
 r = 0.05;
 T = 30;
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
 pricer.payoff_handler = @payoff_design_1_call;
 pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
p1 = pricer.calc_price()

%% 生成BS模型，设置参数
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.iterN = mcp.iterN ;
mcp.model = model;
mcp.println;
mcp.model.println;
mcp.payoffFunctionHandler = @payoff_design_1_call_MC;

p1_mc = mcp.calc_opt_price_mat()

%% 看跌
 %% 生成二叉树根
 put_pricer = BinomialPricer;
%  pricer.set_params_from_optPricer(oi);
%% 手动设置参数
 put_pricer.T_ = T;
 put_pricer.S_ = S0;
 put_pricer.u_ = exp(sigma * sqrt(1/365));
 put_pricer.d_ = exp(-sigma * sqrt(1/365));

 put_pricer.r_ = r;

 %% 挂载payoff计算方法
 put_pricer.payoff_handler = @payoff_design_1_put;
 put_pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
put_p1 = put_pricer.calc_price()

%% 生成BS模型，设置参数
 model2 = BlackScholesModel;
 model2.stepT = T;
 model2.sigma = sigma;
 model2.rfr = r;
 
%% MonteCarloPricer
mcp2 = MonteCarloPricer;
mcp2.iterN = mcp2.iterN;
mcp2.rfr = r;
mcp2.model = model2;
mcp2.println;
mcp2.model.println;
mcp2.payoffFunctionHandler = @payoff_design_1_put_MC;

put_p1_mc = mcp2.calc_opt_price_mat()

% %% 变化T和sigma 组合，测试结果
% % sigma = 30
% % T = 30
% % r = 0.5
% model.stepT = 30;
% model.sigma = 0.3;
% mcp.rfr = 0.05;
% call_price_30T = mcp.calc_opt_price_mat()
% 
% model2.stepT = 30;
% model2.sigma = 0.3;
% mcp2.rfr = 0.05;
% put_price_30T = mcp2.calc_opt_price_mat()
% 
% Bi_pricer_30T = BinomialPricer;
% Bi_pricer_30T.T_ = model.stepT;
% Bi_pricer_30T.S_ = S0;
% Bi_pricer_30T.u_ = exp(model.sigma * sqrt(1/365));
% Bi_pricer_30T.d_ = exp(- model.sigma * sqrt(1/365));
% 
% Bi_pricer_30T.r_ = mcp.rfr;
% Bi_pricer_30T.payoff_handler = @payoff_design_1_call;
% Bi_pricer_30T.forward_T_step();
% bi_price_30T_call = Bi_pricer_30T.calc_price()
% 
% 
% % sigma = 15
% % T = 120
% % r = 0.125
% model.stepT = 120;
% model.sigma = 0.3 / 2;
% mcp.rfr = 0.05 / 4;
% model.rfr = mcp.rfr;
% mcp.println;
% call_price_120T = mcp.calc_opt_price_mat()
% 
% Bi_pricer_120T = BinomialPricer;
% Bi_pricer_120T.T_ = model.stepT;
% Bi_pricer_120T.S_ = S0;
% Bi_pricer_120T.u_ = exp(model.sigma * sqrt(1/365));
% Bi_pricer_120T.d_ = exp(- model.sigma * sqrt(1/365));
% 
% Bi_pricer_120T.r_ = mcp.rfr;
% Bi_pricer_120T.payoff_handler = @payoff_design_1_call;
% Bi_pricer_120T.forward_T_step();
% bi_price_120T_call = Bi_pricer_120T.calc_price()
% 
% 
% model2.stepT = 120;
% model2.sigma = 0.15;
% mcp2.rfr = 0.05 / 4;
% put_price_120T = mcp2.calc_opt_price_mat()
% 
% % sigma = 10
% % T = 270
% model.stepT = 270;
% model.sigma = 0.10;
% mcp.rfr = 0.05 / 9;
% model.rfr = mcp.rfr;
% mcp.println;
% model.println;
% call_price_270T = mcp.calc_opt_price_mat()
% 
% Bi_pricer_270T = BinomialPricer;
% Bi_pricer_270T.T_ = model.stepT;
% Bi_pricer_270T.S_ = S0;
% Bi_pricer_270T.u_ = exp(model.sigma * sqrt(1/365));
% Bi_pricer_270T.d_ = exp(- model.sigma * sqrt(1/365));
% 
% Bi_pricer_270T.r_ = mcp.rfr;
% Bi_pricer_270T.payoff_handler = @payoff_design_1_call;
% Bi_pricer_270T.forward_T_step();
% bi_price_270T_call = Bi_pricer_120T.calc_price()
% 
% model2.stepT = 270;
% model2.sigma = 0.10;
% mcp2.rfr = 0.05 / 9;
% put_price_270T = mcp2.calc_opt_price_mat()

% sigma = 7.5
% T = 480
% model.stepT = 480;
% model.sigma = 0.075;
% mcp.rfr = 0.06 / 16;
% call_price_480T = mcp.calc_opt_price_mat()
% 
% Bi_pricer_480T = BinomialPricer;
% Bi_pricer_480T.T_ = model.stepT;
% Bi_pricer_480T.S_ = S0;
% Bi_pricer_480T.u_ = exp(model.sigma * sqrt(1/365));
% Bi_pricer_480T.d_ = exp(- model.sigma * sqrt(1/365));
% 
% Bi_pricer_480T.r_ = mcp.rfr;
% Bi_pricer_480T.payoff_handler = @payoff_design_1_call;
% Bi_pricer_480T.forward_T_step();
% bi_price_480T_call = Bi_pricer_120T.calc_price()
% 
% model2.stepT = 480;
% model2.sigma = 0.075;
% mcp2.rfr = 0.06 / 16;
% put_price_480T = mcp2.calc_opt_price_mat()



end