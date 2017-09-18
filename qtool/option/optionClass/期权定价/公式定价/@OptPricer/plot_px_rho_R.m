function [ hfig ] = plot_px_rho_R( pricer )
%PLOT_DELTA_S 画delta~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%% 画图

pricer.r = 0.005:0.005:0.095;

pricer.calcPx();
pricer.calcRho();

hfig = figure;
% px~R
subplot(211)
plot( pricer.r, pricer.px);
grid on
txt = '期权价格对R的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('R')
ylabel('px')

% rho~R
subplot(212)
plot( pricer.r, pricer.rho );
grid on
txt = 'Rho对R的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('R')
ylabel('Rho')

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

