function [ hfig ] = plot_delta_tau( self )
%PLOT_DELTA_TAU 画delta~tau的图
% ---------------------
% 吴云峰，20160129
% 吴云峰，20160316，使用copy的方法进行作图

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% 作图

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

copy.calcDelta;

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( tau, copy.delta );

xlabel('\tau')
ylabel('delta')

grid on;
txt = 'Structure期权组合期权delta对\tau的函数图';
title( txt )

hold off

end

