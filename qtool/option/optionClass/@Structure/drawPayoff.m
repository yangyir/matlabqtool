function  [ hfig ] = drawPayoff( obj , ST, cost )
% 画structure的payoff图像
% -------------------------
% 吴云峰，20160120
% 黄勉，20160128，加入 cost

if ~exist( 'ST' , 'var' )
    ST = 1.7:0.05:3;  % 所有的K的范围
end
if ~exist( 'cost' , 'var' )
    cost = 0;  % 期权组合成本
end

L = length(ST);
payoff = zeros(L,1);

for i = 1:L
    payoff(i) = obj.calcPayoff(ST(i)) - cost;
end

% TODO：画的更好看
hfig = figure;
plot( ST , payoff , 'r-*' , 'LineWidth' , 2 )
grid on
title( 'Structure的PayOff曲线' ,...
    'FontSize',13,'FontName','华文楷体' )
xlabel( 'ST' , ...
    'FontSize',13,'FontName','华文楷体' )
ylabel( 'PayOff' , ...
    'FontSize',13,'FontName','华文楷体' )
hold on

end
