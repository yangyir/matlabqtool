function [ hfig ] = plot_px_vega_sigma( pricer )
%PLOT_PX_VEGA_SIGMA 画px_vega~sigma的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%
pricer.sigma = 0.10:0.05:1;
pricer.calcPx();
pricer.calcVega();


hfig = figure;
% px~sigma
subplot(211)
plot( pricer.sigma, pricer.px);
grid on
txt = '期权价格对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, datestr(pricer.currentDate));
title(txt)
xlabel('sigma')
ylabel('px')

% vega~sigma
subplot(212)
plot( pricer.sigma, pricer.vega);
grid on
txt = 'vega对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, datestr(pricer.currentDate));
title(txt)
xlabel('sigma')
ylabel('vega')

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

