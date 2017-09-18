function [ hfig ] = plot_optprice_tau( obj  )
%PLOT_OPTPRICE_tau 画期权价格对tau的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
original = obj.getCopy();

%% 画图，画px~tau的图
T = obj.T;
currentDate = T-20:T-1;
obj.currentDate = currentDate;
px = obj.calcPx();
tau = obj.tau;

hfig = figure;
plot(tau, px);
xlabel('\tau')
ylabel('px')
grid on
txt = '期权价格对 \tau 的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%% ', txt, ...
    obj.CP,datestr( obj.T ), obj.K, obj.sigma*100 );
title(txt);

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

