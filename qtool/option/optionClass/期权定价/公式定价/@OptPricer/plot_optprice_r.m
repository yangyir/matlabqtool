function [ hfig ] = plot_optprice_r( obj  )
%PLOT_OPTPRICE_R 画期权价格对R的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了obj.sigma长度大于1的情况
% 吴云峰，20160129，增加了不改变原有值的方法


%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
original = obj.getCopy();

%% 画图，画px~r的图

obj.r = 0.005:0.005:0.095;
obj.calcPx();

hfig = figure;
plot(obj.r, obj.px);
grid on
txt = '期权价格对r的函数图';

% sigma数据的长度
sigmaL = length( obj.sigma );

if sigmaL == 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K, obj.sigma*100, datestr(obj.currentDate));
else
    % 针对obj.sigma可能会出现长度大于1的情况
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        obj.CP,datestr( obj.T ), obj.K , datestr(obj.currentDate));
end


title(txt)

%% 最后将原先的变量原封不动的返回

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

