function [ hfig ] = plot_delta_K( pricer )
%PLOT_DELTA_K 画delta~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%

pricer.K = 1.7:0.02:2.7;
pricer.calcDelta();
hfig = figure;

plot( pricer.K, pricer.delta );
legend('delta');
%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('K')
ylabel('delta')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '期权delta对K的函数图';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

