function [ hfig ] = plot_optprice_r( self )
%PLOT_OPTPRICE_R 画期权价格对R的图
% ----------------------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy  = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图，画px~r的图

% 三个环境变量:r和S和sigma都会被进行赋予
r = 0.005:0.005:0.095;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).r = r;
    end
end

copy.calcPx();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( r , copy.px );

grid on
txt = 'Structure期权组合的价格对r的函数图';

xlabel('r')
ylabel( '价格/价值' )

title(txt)

hold off

end

