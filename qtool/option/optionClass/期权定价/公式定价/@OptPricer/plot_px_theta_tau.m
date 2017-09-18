function [ hfig ] = plot_px_theta_tau( pricer )
%PLOT_DELTA_S 画delta~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%

T = pricer.T;
currentDate = T-20:T-1;
pricer.currentDate = currentDate;
% 基于这样可以计算tau的值
% pricer.tau = 0.01:0.008:0.155;
pricer.calcPx();
pricer.calcTheta();

hfig = figure;
% px~S
subplot(211)
plot( pricer.tau, pricer.px);
grid on
txt = '期权价格对\tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100 );
title(txt)
xlabel('\tau')
ylabel('px')

% delta~S
subplot(212)
txt = 'theta对\tau的函数图';
plot( pricer.tau, pricer.theta);
grid on
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100 );
title(txt)
xlabel('\tau')
ylabel('theta')

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

