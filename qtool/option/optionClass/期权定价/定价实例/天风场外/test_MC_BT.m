%% 验证：stepT较大时， MC方法和二叉树方法结果一致

clear all; rehash;

M  = 1


tic
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

toc

tic

%%

% M =5;


%% 
bt = BinomialPricer;
bt.T_ = m.stepT; % 30 * M * M;
bt.S_ = 1;
bt.r_ = m.rfr; % 0.05/ M/M; 
sigma = m.sigma;  %0.3 / M; 

% bt.r * sqrt

exp( bt.r_ * 1/365)
bt.u_ = exp(   sigma * sqrt(1/365) ) ;
bt.d_ = exp(  - sigma * sqrt(1/365));
bt.payoff_handler = @payoff_design_1_call;


%% 
bt.forward_T_step;
px2 = bt.calc_price

toc