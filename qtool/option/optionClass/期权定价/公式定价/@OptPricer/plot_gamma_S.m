function [ hfig ] = plot_gamma_S( pricer )
%PLOT_GAMMA_S 画gamma~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法


%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;
pricer.calcGamma();

hfig = figure;
plot( pricer.S, pricer.gamma);
legend('gamma');
%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('S')
ylabel('gamma')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '期权gamma对S的函数图';
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