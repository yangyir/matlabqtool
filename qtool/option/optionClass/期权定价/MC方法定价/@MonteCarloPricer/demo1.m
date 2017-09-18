function [  ] = demo1(  )
%DEMO5 最简单的demo，直接写s_generator和payoff函数，挂上，定价

clear all; rehash;

%% 方法一：使用单路径S， 基本淘汰此法
% 生成mcpricer
pricer = MonteCarloPricer;
pricer.iterN    = 100000;
pricer.rfr      = 0.03;

% mcpricer挂上两个函数，单路径版S
pricer.SgeneratorHandler = @my_s_generator;
pricer.payoffFunctionHandler = @my_payoff;

% 定价，使用单路径S，mcpricer.calc_opt_price()
tic
px1 = pricer.calc_opt_price
toc


%% 方法二： 使用矩阵版S，要特别注意payoff_func的写法
% 生成mcpricer
pricer2 = MonteCarloPricer;
pricer2.iterN   = 100000;
pricer2.rfr     = 0.03;

% mcpricer挂上两个函数， 矩阵版S
pricer2.SgeneratorHandler = @my_s_mat_generator;
pricer2.payoffFunctionHandler = @my_payoff;

% 定价，使用矩阵S，mcpricer.calc_opt_price_mat()
tic
px2 = pricer2.calc_opt_price_mat
toc

end


%% 产生S序列，只是一条路径
function [S] = my_s_generator()
% 这里只产生一条路径，要在pricer里循环
S = rand(1,100);
end


%% 产生S 矩阵，多条路径一次生成
function [S] = my_s_mat_generator(iterN)

S = rand(iterN, 100);

end



%% payoff函数， 单路径S和矩阵S通用
function [payoff] = my_payoff( S )

    % 如果S是序列，转成 1*stepT
%     payoff = mean( S(:,end-3:end), 2 ) ;
    payoff = S(:,end) .* S(:,end);   

end




