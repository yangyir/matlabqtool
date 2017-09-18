function [ hfig ] = plot_delta_K( pricer , K )
%PLOT_DELTA_K 画delta~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% 吴云峰，20160301，使用Copy的结果进行作图
% 吴云峰，20160316，按照刚哥的center取点的方法进行计算和hFig的输出判断方法

%% 预处理
% TODO: 相关预处理

% 在copy上面进行研究
copy = pricer.getCopy();

%% 作图

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcDelta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.delta , 'b-' );
legend('delta');

xlabel('K')
ylabel('delta')

grid on;
txt = '期权delta对K的函数图';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100,...
    datestr( copy.currentDate ) );

hold on

% 做出中心的点
copy.K = center;
copy.calcDelta();
plot( copy.K, copy.delta , 'r*' ,...
    'MarkerSize' , 10 );

title( txt )

hold off

end

