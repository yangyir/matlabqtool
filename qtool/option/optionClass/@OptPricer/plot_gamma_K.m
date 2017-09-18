function [ hfig ] = plot_gamma_K( pricer , K )
%PLOT_GAMMA_K 画gamma~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% 吴云峰，20160316，按照刚哥的center取点的方法进行计算和hFig的输出判断方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 画图

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcGamma();

if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.gamma , 'b-' );
legend('gamma');

xlabel('K')
ylabel('gamma')

grid on;
txt = '期权gamma对K的函数图';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100, ...
    datestr(copy.currentDate) );

title(txt)

% 做出中心的点
copy.K = center;
copy.calcGamma();
hold on
plot( copy.K, copy.gamma , 'r*' ,...
    'MarkerSize' , 10 );


end

