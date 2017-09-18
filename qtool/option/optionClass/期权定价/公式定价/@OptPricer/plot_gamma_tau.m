function [ hfig ] = plot_gamma_tau( pricer )
%PLOT_GAMMA_TAU 画gamma~tau的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%

tau = 0.01:0.02:0.5;
% 存放gamma变量
gamma = zeros( 1 , length( tau ) ); 
for i = 1 : length(tau)
    pricer.tau = tau(i);
    pricer.calcGamma();
    gamma(i) = pricer.gamma;
end

hfig = figure;
plot( tau, gamma);

%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('\tau')
ylabel('gamma')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '期权gamma对\tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

