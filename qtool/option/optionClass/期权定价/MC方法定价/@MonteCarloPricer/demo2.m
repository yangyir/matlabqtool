function [   ] = demo2(   )
%DEMO2 Summary of this function goes here
%   Detailed explanation goes here

clear all; rehash

%% ����ģ��
m = BlackScholesModel;
m.stepT = 90;
m.sigma = 0.5;
m.rfr = 0.05;


%% ����MCpricer�� ����ģ�ͣ�����payoff function
mcp = MonteCarloPricer;

mcp.model = m;
mcp.payoffFunctionHandler = @payoff_zxat82;

% payoff_zxat82([1,2,3;4,5,6])


%% �㶨��
pr = mcp.calc_opt_price_mat



end

