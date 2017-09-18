function [   ] = demo3(   )
%DEMO ���飺��ʽ����MC�������һ��

clear all; rehash
 

%% ���� optPricer
 oi = OptPricer;
 oi.K = 1.1;
 oi.T = '2016-03-23';
 oi.S = 1;
 oi.sigma = 0.5;
 oi.r = 0.04;
 
 p1 = oi.calcPx
 
 
 %% ����model�� mc
 model = BlackScholesModel;
 model.set_params_from_optPricer( oi ); 
 model.rfr = oi.r;



%% ����MC������
 mc = MonteCarloPricer;
 mc.rfr = oi.r;

 
 %% �����model function
 mc.SgeneratorHandler = @(x)model.generate_S_from_model(x);
 mc.payoffFunctionHandler = @oi.calcMCpayoff;
 
 p2 = mc.calc_opt_price_mat

 
 
 %% �ڹ�
  mc.model = model;
 p3 = mc.calc_opt_price_mat
 
 
 %% �ⲿ�޸�model
 model.sigma = 0.6;
 oi.sigma = 0.6;
 
 p4 = oi.calcPx
 p5 = mc.calc_opt_price_mat
 
 
 %% �ⲿ�޸�oi
 oi.K = 0.9;
 p6 = oi.calcPx
 p7 = mc.calc_opt_price_mat
 
 
 
 %% ��һ�����payoff
 
 
 
 
 
 


end

