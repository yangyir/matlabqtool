function [] = pricing_xbjx1()
%% 给场外期权西部聚新1号定价
clear all;rehash;

 sigma = 0.5;
 r = 0.05;
 T = 72;
 S0 = 1;

 %% 生成BS模型，设置参数
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.model = model;
mcp.payoffFunctionHandler = @payoff_gddt1_MC;

p_gddt1_mc = mcp.calc_opt_price_mat()

end