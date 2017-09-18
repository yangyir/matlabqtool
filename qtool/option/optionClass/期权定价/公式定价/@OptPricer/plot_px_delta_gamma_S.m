function [ hfig ] = plot_px_delta_gamma_S( pricer )
%PLOT_PX_DELTA_GAMMA_S 画px_delta_gamma~S的图
% ---------------------
% 程刚，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;

pricer.calcPx();
pricer.calcDelta();
pricer.calcGamma();

hfig = figure;

% px~S
subplot(311)
plot( pricer.S, pricer.px);
grid on
txt = '期权价格对S的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('S')
ylabel('px')

% delta~S
subplot(312)
plot( pricer.S, pricer.delta);
grid on
xlabel('S')
ylabel('delta')
txt = 'Delta对S的函数图';

title(txt)

% gamma~S
subplot(313)
plot( pricer.S, pricer.gamma);
grid on
txt = 'Gamma对S的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

