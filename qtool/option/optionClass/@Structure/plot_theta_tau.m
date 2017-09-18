function [ hfig ] = plot_theta_tau( self )
%PLOT_THETA_TAU 画theta~tau的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%%

S = [1.8,2.3,2.7];
tau = 0.01:0.02:0.5;

colorheader = 'rgb';

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

hold on

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).tau = tau;
    end
end

for m = 1:3
    for j = 1:L1
        for i = 1:L2
            copy.optPricers(j,i).S = S(m);
        end
    end
    copy.calcTheta();
    plot( tau, copy.theta,colorheader(m));
end

legend('S=1.8','S=2.3','S=2.7')
    
%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('\sim tau')
ylabel('theta')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '期权组合Structure的theta对\sim tau的函数图';

title(txt)

hold off

end

