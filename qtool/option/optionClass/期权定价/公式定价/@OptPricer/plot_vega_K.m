function [ hfig ] = plot_vega_K( pricer )
%PLOT_VEGA_K 画vega~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
original = pricer.getCopy();

%%

pricer.K = 1.7:0.02:2.7;
pricer.calcVega();
hfig = figure;

plot( pricer.K, pricer.vega);
legend('vega');

%%%%%%%%%%%%%%新增的坐标轴名称
xlabel('K')
ylabel('vega')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '期权vega对K的函数图';
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

