function [ hfig ] = plot_optprice_sigma( self )
%PLOT_OPTPRICE_SIGMA 画期权价格对sigma的图
% ----------------------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% 画图，画px~sgima的图 obj.sigma*100

volsurf = 0.10:0.05:1;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).sigma = volsurf;
    end
end

copy.calcPx();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( volsurf , copy.px );

xlabel('sigma')
ylabel('px') 
grid on

txt = '期权组合Structure价格对sigma的函数图';

title(txt)

hold off

end

