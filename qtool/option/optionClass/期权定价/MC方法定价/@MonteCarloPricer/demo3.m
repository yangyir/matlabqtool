function [   ] = demo3(   )
%DEMO 检验：公式法和MC法，结果一样

clear all; rehash
 

%% 生成 optPricer
 oi = OptPricer;
 oi.K = 1.1;
 oi.T = '2016-03-23';
 oi.S = 1;
 oi.sigma = 0.5;
 oi.r = 0.04;
 
 p1 = oi.calcPx
 
 
 %% 生成model， mc
 model = BlackScholesModel;
 model.set_params_from_optPricer( oi ); 
 model.rfr = oi.r;



%% 生成MC定价器
 mc = MonteCarloPricer;
 mc.rfr = oi.r;

 
 %% 外面挂model function
 mc.SgeneratorHandler = @(x)model.generate_S_from_model(x);
 mc.payoffFunctionHandler = @oi.calcMCpayoff;
 
 p2 = mc.calc_opt_price_mat

 
 
 %% 内挂
  mc.model = model;
 p3 = mc.calc_opt_price_mat
 
 
 %% 外部修改model
 model.sigma = 0.6;
 oi.sigma = 0.6;
 
 p4 = oi.calcPx
 p5 = mc.calc_opt_price_mat
 
 
 %% 外部修改oi
 oi.K = 0.9;
 p6 = oi.calcPx
 p7 = mc.calc_opt_price_mat
 
 
 
 %% 挂一个别的payoff
 
 
 
 
 
 


end

