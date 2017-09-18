function [ hfig ] = plot_px_theta_tau( self )
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

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

copy.calcPx();
copy.calcTheta();

tau = copy.optPricers(1,1).tau;

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% px~S
subplot(211)
plot( tau , copy.px );
grid on
txt = '期权组合Structure价格对\tau的函数图';
title(txt)
xlabel('\tau')
ylabel('px')

% delta~S
subplot(212)
txt = '期权组合Structure的theta对\tau的函数图';
plot( tau, copy.theta );
grid on
title(txt)
xlabel('\tau')
ylabel('theta')

hold off

end

