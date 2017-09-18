function [] = pricing_xbjx1()
%% ��������Ȩ��������1�Ŷ���
clear all;rehash;

 sigma = 0.5;
 r = 0.05;
 T = 268;
 S0 = 1;

 %% ����BSģ�ͣ����ò���
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.model = model;
mcp.payoffFunctionHandler = @payoff_xbjx1_MC;

p_xbjx_mc = mcp.calc_opt_price_mat()

end