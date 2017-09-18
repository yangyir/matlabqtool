function [ hfig ] = plot_gamma_tau_mix( pricer , tau )
%PLOT_GAMMA_TAU 画gamma~tau的图
% 三类状态合一起的
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% 吴云峰，20160301，使用Copy的结果进行作图
% 吴云峰，20160316，按照刚哥的center取点的方法进行计算和hFig的输出判断方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 作图

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau     =   0.05 * [1:20] * longend ;
end

copy.tau = tau;

S = [1.8,2.3,2.7];
colorheader = 'rgb';
if nargout > 0
    hfig = figure;
end
hold on

for i = 1:3
    copy.S = S(i);
    copy.calcGamma();
    plot( copy.tau, copy.gamma,colorheader(i));
end

switch  copy.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('虚值（OTM）','平值（ATM）','实值（ITM）' , 'Location' , 'best' )
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('实值（ITM）','平值（ATM）','虚值（OTM）' , 'Location' , 'best' )          
end    

xlabel('tau')
ylabel('gamma')

grid on;
txt = '期权gamma对tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));

title(txt)

pricer.calcGamma();
hold on
plot( pricer.tau , pricer.gamma , 'mo' ,...
    'MarkerFaceColor' , 'm')


end

