function [ hfig ] = plot_px_rho_r( pricer , r )
%PLOT_DELTA_S 画delta~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 画图

if ~exist( 'r' , 'var' )
    r = 0.005:0.005:0.095;
end

copy.r = r;
copy.calcPx();
copy.calcRho();

% 计算原有的结果
pricer.calcPx();
pricer.calcRho();

hfig = figure;

% 用copy进行作图
% px~R
subplot(211)
plot( copy.r, copy.px );
grid on
txt = '期权价格对R的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));
title(txt)
xlabel('R')
ylabel('px')
% 做出原有的点的图
hold on
plot( pricer.r, pricer.px , 'ro' , ... 
    'MarkerFaceColor' , 'r' )

% rho~R
subplot(212)
plot( copy.r, copy.rho );
grid on
txt = 'Rho对R的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));
title(txt)
xlabel('R')
ylabel('Rho')
% 做出原有的点的图
hold on
plot( pricer.r, pricer.rho , 'ro' , ... 
    'MarkerFaceColor' , 'r' )


end

