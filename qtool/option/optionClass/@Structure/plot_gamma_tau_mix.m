function [ hfig ] = plot_gamma_tau_mix( self )
%PLOT_GAMMA_TAU 画gamma~tau的图
% 三类状态合一起的
% ---------------------
% 吴云峰，20160129

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%%

S = [1.8,2.3,2.7];

colorheader = 'rgb';
% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end
hold on

tau = 0.01:0.02:0.5;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

for m = 1:3
    for j = 1:L1
        for i = 1:L2
            copy.optPricers( j , i ).S = S(m);
        end
    end
    copy.calcGamma();
    plot( tau, copy.gamma,colorheader(m));
end

legend('S=1.8','S=2.3','S=2.7')

xlabel('\tau')
ylabel('gamma')

grid on;
txt = 'Structure期权组合gamma对\tau的函数图';

title(txt)

hold off

end

