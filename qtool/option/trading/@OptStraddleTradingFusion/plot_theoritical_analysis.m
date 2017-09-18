function [  ] = plot_theoritical_analysis( obj, Smin, Smax )
%PLOT_THEORITICAL_ANALYSIS 此处显示有关此函数的摘要
% 1，构造一个structure，就是straddle
% 2，算出理论曲线 px ~ S, 画出来
% 3，取实际价格，标出straddle的bid和ask
% 4，设置下单健，按动后下单，这里就要使用到实际交易的部分了
% --------------------------
% 201705, 程刚， 加入变量Smin，Smax

%%
% clear all;
% rehash;

if ~exist('Smin', 'var'),
    Smin = 2.1;
end

if ~exist('Smax', 'var'),
    Smax = 2.4;
end


%% 取QuoteOpt
cquote = obj.call;
pquote = obj.put;


%% 取仓位



%% 构造straddle structure
s = Structure;
s.volsurf = obj.volsurf;
% s.volsurf.update_VolSurface( 'h' )
% s.volsurf.plot

% [p, mat] = getCurrentPrice('510050', '1');
% s.S = p(1);

S = obj.quoteS.last;
obj.S = S;
s.S = obj.S;

% 从QuoteOpt转成OptPricer，以供后面画图用
call = cquote.QuoteOpt_2_OptPricer('bid');
put  = pquote.QuoteOpt_2_OptPricer('bid');

s.optPricers(1) = put;
s.optPricers(2) = call;
s.num = [1,1];

s.inject_environment_params

% s.plot_optprice_S
% s.plot_gamma_S
% s.plot_delta_S
% s.plot_px_delta_gamma_S

%% 取理论价格，作图
% call.S = s.S; call.calcPx; 
% put.S = s.S; put.calcPx;
% 
% % call.px = 0.0432;
% % put.px = 0.0562;
% cost = call.px + put.px;
% 
% 
% cost = s.calcPx;
%     
% s.plot_optprice_S(1.8:0.01:2.2)
% hold on
% plot( s.S, cost, 'ro');
% 
% % 画直线
% x = 1.8:0.01:2.2;
% y = cost* ones(size(x));
% plot( x, y, 'r');


%% 算delta==0 的S点
% tic
% [delta0_S, delta] = s.solve_delta0_S(2.1, 2.2, 0.001);
% toc
% fprintf('S0 = %f,  delta0 = %f\n', delta0_S, delta);

%% 取实际价格, 估算交易盈亏
figure(211); hold off;
ask = cquote.askP1 + pquote.askP1;
bid = cquote.bidP1 + pquote.bidP1;
cost= ask;

abs = ask - bid;
abs_pct = abs/bid;

% 自己更改画图的横轴范围和精度，例：1.8:0.01:2.1    
% x = 2:0.01:2.3;
x = Smin:0.01:Smax;

s.plot_optprice_S(x)
hold on
plot( s.S, cost, 'ro');

% 画直线
y = cost* ones(size(x));
z = bid * ones( size(x));
plot( x, y, 'r');
plot( x, z, 'g');





%% 

end
