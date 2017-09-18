function [ hfig ] = plot_gamma_S( self , S )
%PLOT_GAMMA_S 画gamma~S的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

% 横轴S默认值域
if ~exist( 'S' , 'var' )
    center = copy.optPricers(1,1).S;
    try
        wrong =  center == 0 || isempty(center) || isnan(center);
        if wrong,  center = pricer.K; end    
    catch e
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end

copy.calcGamma();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( S , copy.gamma );
legend('gamma');

%%%%%%%%%%%%%%新增的坐标轴名称

xlabel('S')
ylabel('gamma')

%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = 'Structure期权组合gamma对S的函数图';

title( txt )

hold off

end