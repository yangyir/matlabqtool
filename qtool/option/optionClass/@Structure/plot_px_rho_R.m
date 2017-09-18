function [ hfig ] = plot_px_rho_R( self )
%PLOT_DELTA_S 画delta~S的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

r = 0.005:0.005:0.095;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).r = r;
    end
end

copy.calcPx();
copy.calcRho();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% px~R
subplot(211)
plot( r , copy.px );
grid on
txt = '期权组合Structure价格对R的函数图';
title(txt)
xlabel('R')
ylabel('px')

% rho~R
subplot(212)
plot( r , copy.rho );
grid on
txt = '期权组合Structure的Rho对R的函数图';
title(txt)
xlabel('R')
ylabel('Rho')

hold off

end

