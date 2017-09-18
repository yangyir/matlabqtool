%% 验证MonteCarlo方法，切细后，定价收敛 ： 成功
clear all;
rehash;

for M = 1:5
% M  = 5
M

%%
m  = BlackScholesModel;
m.rfr = 0.05 / M/M;
m.sigma = 0.3 / M;
m.stepT  = 30*M*M;
m.println;


%%
p = MonteCarloPricer;
p.rfr = m.rfr;
p.model = m;
p.payoffFunctionHandler = @payoff_design_1_call_MC;
p.println;

%% 
px = p.calc_opt_price_mat

end
