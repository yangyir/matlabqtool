clear all; rehash;
T = 30;
r = 0.05;
sigma = 0.45;
S0 = 1;

%% ����BSģ�ͣ����ò���
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


%���໦��300
% mcp.payoffFunctionHandler = @payoff_IF_long;
% 
% p1ong_mc = mcp.calc_opt_price_mat();

% ���ջ���300
% mcp.payoffFunctionHandler = @payoff_IF_short;
% 
% pshort_mc = mcp.calc_opt_price_mat();

% ��ƽ����300
% mcp.payoffFunctionHandler = @payoff_IF_same;
% psame_mc = mcp.calc_opt_price_mat();

% ��
% mcp.payoffFunctionHandler = @payoff_IF_shock;
% pshock_mc = mcp.calc_opt_price_mat();

% sharkfin
% mcp.payoffFunctionHandler = @payoff_IF_sharkfin;
% psharkfin_mc = mcp.calc_opt_price_mat();

% sharkfin knockout
mcp.payoffFunctionHandler = @payoff_IF_sharkfin_knockout;
psharkfin_knockout_mc = mcp.calc_opt_price_mat();

%% ������������
pricer = BinomialPricer;
%  pricer.set_params_from_optPricer(oi);
%% �ֶ����ò���
 pricer.T_ = T;
 pricer.S_ = S0;
 pricer.u_ = exp(sigma * sqrt(1/365));
 pricer.d_ = exp(-sigma * sqrt(1/365));

 pricer.r_ = r;

 %% ����payoff���㷽��
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

