function [ hfig ] = plot_theta_K( self , K )
%PLOT_THETA_K 画theta~K的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).K = K;
    end
end

copy.calcTheta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot(  K, copy.theta );
legend('theta');

%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('K')
ylabel('theta')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '期权组合Structure的theta对K的函数图';

title(txt)

hold off

end

