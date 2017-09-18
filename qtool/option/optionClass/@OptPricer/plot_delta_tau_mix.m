function [ hfig ] = plot_delta_tau_mix( pricer , tau )
%PLOT_DELTA_TAU 画delta~tau的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160301，使用Copy的结果进行作图
% 吴云峰，20160316，按照刚哥的center取点的方法进行计算和hFig的输出判断方法

%% 预处理
% TODO: 相关预处理

% 在copy上面进行研究
copy = pricer.getCopy();

%% 作图程序

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau     =   0.05 * [1:20] * longend ;
end

K = [1.8,2.3,2.7];
copy.tau = tau;

colorheader = 'rgb';
if nargout > 0
    hfig = figure;
end
hold on

for i = 1 : 3
    copy.K = K(i);
    copy.calcDelta();
    plot( copy.tau, copy.delta , colorheader(i) );
end

switch  copy.CP
    case {'C', 'c', 'Call', 'call', 'CALL' }
        legend('实值（ITM）','平值（ATM）','虚值（OTM）' , 'Location' , 'best')
    case {'P', 'p', 'put', 'Put', 'PUT'}
        legend('虚值（OTM）','平值（ATM）','实值（ITM）' , 'Location' , 'best')
end

xlabel('\tau')
ylabel('delta')

grid on;
txt = '期权delta对\tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100,...
    datestr(copy.currentDate) );

pricer.calcDelta();
hold on
plot( pricer.tau , pricer.delta , 'mo' ,...
    'MarkerFaceColor' , 'm')

title(txt)

end

