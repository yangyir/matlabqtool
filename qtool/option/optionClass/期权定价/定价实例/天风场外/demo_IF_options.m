clear all; rehash;
T = 30;
r = 0.05;
sigma = 0.45;
S0 = 1;

%% 生成BS模型，设置参数
 model = BlackScholesModel;
 model.stepT = T;
 model.sigma = sigma;
 model.rfr = r;
 model.println; 
%% MonteCarloPricer
mcp = MonteCarloPricer;
mcp.iterN = mcp.iterN ;
mcp.model = model;
mcp.println;
mcp.model.println;

% mcp.payoffFunctionHandler = @payoff_dual_opt_long;
% p1ong_mc = mcp.calc_opt_price_mat();

% mcp.payoffFunctionHandler = @payoff_dual_opt_short;
% pshort_mc = mcp.calc_opt_price_mat();


%看多沪深300
% mcp.payoffFunctionHandler = @payoff_IF_long;
% 
% p1ong_mc = mcp.calc_opt_price_mat();

% 看空沪深300
% mcp.payoffFunctionHandler = @payoff_IF_short;
% 
% pshort_mc = mcp.calc_opt_price_mat();

% 看平沪深300
% mcp.payoffFunctionHandler = @payoff_IF_same;
% psame_mc = mcp.calc_opt_price_mat();

% 震荡
% mcp.payoffFunctionHandler = @payoff_IF_shock;
% pshock_mc = mcp.calc_opt_price_mat();

% sharkfin
% mcp.payoffFunctionHandler = @payoff_IF_sharkfin;
% psharkfin_mc = mcp.calc_opt_price_mat();

% sharkfin knockout
mcp.payoffFunctionHandler = @payoff_IF_sharkfin_knockout;
psharkfin_knockout_mc = mcp.calc_opt_price_mat();

%% 二叉树法定价
pricer = BinomialPricer;
%  pricer.set_params_from_optPricer(oi);
%% 手动设置参数
 pricer.T_ = T;
 pricer.S_ = S0;
 pricer.u_ = exp(sigma * sqrt(1/365));
 pricer.d_ = exp(-sigma * sqrt(1/365));

 pricer.r_ = r;

 %% 挂载payoff计算方法
%  pricer.payoff_handler = @payoff_dual_opt_long_bin;
%  pricer.forward_T_step();
%  plong_bin = pricer.calc_price();

%  pricer.payoff_handler = @payoff_dual_opt_short_bin;
%  pricer.forward_T_step();
%  pshort_bin = pricer.calc_price();
 
%  pricer.payoff_handler = @payoff_IF_long_bin;
%  pricer.forward_T_step();
%  
% plong_bin = pricer.calc_price();



%  pricer.payoff_handler = @payoff_IF_short_bin;
%  pricer.forward_T_step();
%  pshort_bin = pricer.calc_price();
 
%  pricer.payoff_handler = @payoff_IF_same_bin;
%  pricer.forward_T_step();
%  psame_bin = pricer.calc_price();
 
% sharkfin
%  pricer.payoff_handler = @payoff_IF_sharkfin_bin;
%  pricer.forward_T_step();
%  psharkfin_bin = pricer.calc_price();

