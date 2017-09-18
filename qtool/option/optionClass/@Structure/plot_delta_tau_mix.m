function [ hfig ] = plot_delta_tau_mix( self )
%PLOT_DELTA_TAU 画delta~tau的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

K   = [1.8,2.3,2.7];
tau = 0.01:0.02:0.5;

colorheader = 'rgb';

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

hold on

for m = 1 : 3
    
    for j = 1:L1
        for i = 1:L2
            copy.optPricers( j , i ).K   = K(m);
            copy.optPricers( j , i ).tau = tau;
        end
    end
    
    copy.calcDelta();
    
    plot( tau , copy.delta , colorheader(m) );
    
    copy.delta = [];
end

legend('K=1.8','K=2.3','K=2.7')
    
%%%%%%%%%%%%%%新增的坐标轴名称

xlabel('\tau')
ylabel('delta')

%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = 'Structure期权组合delta对\tau的函数图';

title(txt)

hold off

end

