function [ hfig ] = plot_vega_tau( self )
%PLOT_VEGA_TAU 画vega~tau的图
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

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).tau = tau;
    end
end

colorheader = 'rgb';

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

hold on

for m = 1:3
    for j = 1:L1
        for i = 1:L2
            copy.optPricers(j,i).S = S(m);
        end
    end
    copy.calcVega();
    plot( tau, copy.vega,colorheader(m));
end

legend('S=1.8','S=2.3','S=2.7')  

xlabel('\sim tau')
ylabel('vega')

grid on;
txt = '期权组合Structure的vega对\sim tau的函数图';

title(txt)

hold off



end

