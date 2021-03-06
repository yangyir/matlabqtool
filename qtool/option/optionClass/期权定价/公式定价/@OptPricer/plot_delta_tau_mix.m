function [ hfig ] = plot_delta_tau_mix( pricer )
%PLOT_DELTA_TAU 画delta~tau的图
% ---------------------
% 沈杰，20160124

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%% 作图程序

K = [1.8,2.3,2.7];

colorheader = 'rgb';
hfig = figure;
hold on

for i = 1 : 3
    pricer.K = K(i);
    pricer.tau = 0.01:0.02:0.5;
    pricer.calcDelta();
    plot( pricer.tau, pricer.delta,colorheader(i));
end

switch  pricer.CP
    case {'C', 'c', 'Call', 'call', 'CALL' }
        
        legend('实值（ITM）','平值（ATM）','虚值（OTM）')
    case {'P', 'p', 'put', 'Put', 'PUT'}
        legend('虚值（OTM）','平值（ATM）','实值（ITM）')
        
end
    
%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('\tau')
ylabel('delta')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '期权delta对\tau的函数图';
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

