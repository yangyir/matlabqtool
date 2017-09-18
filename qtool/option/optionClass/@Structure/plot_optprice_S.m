function [ hfig ] = plot_optprice_S( self, S_values  )
%PLOT_OPTPRICE_S 画期权价格对S的图
% S_values用于描点，默认值1.8:0.05:2.7 （即所有的K）
% ----------------------------------
% 吴云峰，20160130
% 程刚，20160211，输入变量加入S_values
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% 画图，画px~S的图，带payoff
% 横轴S默认值域
if ~exist( 'S_values' , 'var' )
    center = self.S;
    if center == 0 || isempty(center) || isnan(center)
        center = 2.2;
    end
    mn = max( center * 0.8, 1.8);
    mx = min( center * 1.2, 2.8);
    S_values  = [0:19] * (mx-mn)/20 + mn;
end;

% if ~exist('S_values', 'var')
%     S_values = 1.8:0.05:2.7;
% end

% 这个是环境变量需要赋予
S = S_values;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end
copy.calcPx();

ST = S_values;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).ST = ST;
    end
end

copy.payoff = 0;
[ L1, L2 ] = size( copy.optPricers );
for j = 1:L1
    for i = 1:L2
        oi           = copy.optPricers(j,i);
        nums         = copy.num(j,i);
        copy.payoff  = copy.payoff + nums * oi.calcPayoff( ST );
    end
end 

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( S , copy.px );
hold on
plot( ST , copy.payoff , 'k' );
legend('期权组合Structure定价', '到期payoff');
grid on
txt = 'Structure期权组合价格对S的函数图';

xlabel('S')
ylabel('价格/价值')

title(txt)

hold off


end

