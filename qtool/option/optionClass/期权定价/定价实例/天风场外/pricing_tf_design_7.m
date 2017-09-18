function [] = pricing_tf_design_7()
    clear all; rehash

    sigma = 0.3;
    r = 0.05;
    T = 90;
    S0 = 1;

    %% 生成二叉树根
    pricer = BinomialPricer;
    %  pricer.set_params_from_optPricer(oi);
    %% 手动设置参数
    pricer.T_ = T;
    pricer.S_ = S0;
    pricer.u_ = exp(sigma * sqrt(1/365));
    pricer.d_ = exp(-sigma * sqrt(1/365));

    pricer.r_ = r;

    %% 挂载payoff计算方法
    pricer.payoff_handler = @payoff_design_7;
    pricer.forward_T_step();

    % p2_rc = pricer.calc_price_recusive()
    p7 = pricer.calc_price()

    %% 生成BS模型，设置参数
    model = BlackScholesModel;
    model.stepT = T;
    model.sigma = sigma;
    model.rfr = r;

    %% MonteCarloPricer
    mcp = MonteCarloPricer;
    mcp.model = model;
    mcp.payoffFunctionHandler = @payoff_design_7_MC;

    p7_mc = mcp.calc_opt_price_mat()

    %% 对比反向构造期权
    %% 生成二叉树根
    pricer2 = BinomialPricer;
    %  pricer.set_params_from_optPricer(oi);
    %% 手动设置参数
    pricer2.T_ = T;
    pricer2.S_ = S0;
    pricer2.u_ = exp(sigma * sqrt(1/365));
    pricer2.d_ = exp(-sigma * sqrt(1/365));

    pricer2.r_ = r;

    %% 挂载payoff计算方法
    pricer2.payoff_handler = @payoff_design_7_cmp;
    pricer2.forward_T_step();

    % p2_rc = pricer.calc_price_recusive()
    p7_cmp = pricer2.calc_price()

    %% 生成BS模型，设置参数
    model2 = BlackScholesModel;
    model2.stepT = T;
    model2.sigma = sigma;
    model2.rfr = r;

    %% MonteCarloPricer
    mcp2 = MonteCarloPricer;
    mcp2.model = model2;
    mcp2.payoffFunctionHandler = @payoff_design_7_cmp_MC;
    
    model2.println;
    mcp2.println;

    p7_cmp_mc = mcp2.calc_opt_price_mat()

end