function [] = demo()

clear all; rehash 

%% 生成 optPricer
 oi = OptPricer;
 oi.K = 1.1;
 oi.T = '2016-05-28';
 oi.S = 1;
 oi.sigma = 0.5;
 oi.r = 0.05;
 oi.CP = 'put';
 
 p1 = oi.calcPx

 %% 生成二叉树根
 pricer = BinomialPricer;
 pricer.set_params_from_optPricer(oi);
 pricer.r_ = oi.r;

 pricer.payoff_handler = @oi.calcPayoff;
 pricer.u_ = exp(oi.sigma * sqrt(1/365));
 pricer.d_ = exp(-oi.sigma*sqrt(1/365));
pricer.forward_T_step();

% p2_rc = pricer.calc_price_recusive()
p2 = pricer.calc_price()

end