function [ hfig ] = plot_rho_K( self , K )
%PLOT_RHO_K 画rho~K的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );


%%

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers(j,i).K = K;
    end
end

copy.calcRho();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( K, copy.rho );
legend('rho');

%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('K')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '期权组合Structure的rho对K的函数图';

title(txt)

hold off

end

