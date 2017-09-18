function [ hfig ] = plot_rho_tau( self )
%PLOT_RHO_TAU 画rho~tau的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%% 画图

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).tau = tau;
    end
end

copy.calcRho();

plot( tau , copy.rho);

%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('\tau')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%   

grid on;
txt = '期权组合Structure的rho对\tau的函数图';

title(txt)

hold off


end

