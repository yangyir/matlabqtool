function [ hfig ] = plot_rho_S( pricer )
%PLOT_RHO_S 画rho~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;
pricer.calcRho();

hfig = figure;
plot( pricer.S, pricer.rho);
legend('rho');
%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('S')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = 'rho';
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
