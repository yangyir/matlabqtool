function [ hfig ] = plot_optprice_sigma( obj  )
%PLOT_OPTPRICE_SIGMA 画期权价格对sigma的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
original = obj.getCopy();

%% 画图，画px~sgima的图 obj.sigma*100

obj.sigma = 0.10:0.05:1;
obj.calcPx();

hfig = figure;
plot(obj.sigma, obj.px );

xlabel('sigma')
ylabel('px') 
grid on
txt = '期权价格对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    obj.CP,datestr( obj.T ), obj.K ,datestr(obj.currentDate) );

title(txt)

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end



end

