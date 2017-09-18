function [ hfig ] = plot_theta_K( pricer , K )
%PLOT_THETA_K 画theta~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 作图

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K      = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcTheta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.theta );
legend('theta');

xlabel('K')
ylabel('theta')

grid on;
txt = '期权theta对K的函数图';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100, ...
    datestr(copy.currentDate));

title(txt)

hold on
% 将原点做出来
copy.K = center;
copy.calcTheta();
plot( copy.K, copy.theta , 'r*' ,...
    'MarkerSize' , 10 );



end

