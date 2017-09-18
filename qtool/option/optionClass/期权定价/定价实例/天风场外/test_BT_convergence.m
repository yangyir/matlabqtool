%% 验证二叉树方法，切细后，定价收敛 —— 暂未 成功
% 
% M =     1
% px2 =     0.0611
% 
% M =      2
% px2 =     0.0671
% 
% M =      3
% px2 =     0.0682




clear all;
rehash;


for M = 1:1:3
% M =5;
M

%% 
bt = BinomialPricer;
bt.T_ = 30 * M * M;
bt.S_ = 1;
sigma = 0.3 / M; 
bt.u_ = exp( sigma * sqrt(1/365) ) ;
bt.d_ = exp( - sigma * sqrt(1/365));
bt.r_ = 0.05/ M/M; 
bt.payoff_handler = @payoff_design_1_call;


%% 
bt.forward_T_step;
px2 = bt.calc_price

end