function [ hfig ] = plot_optprice_r( pricer , r  )
%PLOT_OPTPRICE_R 画期权价格对R的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了obj.sigma长度大于1的情况
% 吴云峰，20160129，增加了不改变原有值的方法
% 吴云峰，20160301，使用Copy的结果进行作图

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 画图，画px~r的图

if ~exist( 'r' , 'var' )
    r = 0.005:0.005:0.095;
end

copy.r = r;
copy.calcPx();

if nargout > 0
    hfig = figure;
end

plot(copy.r, copy.px);
grid on
txt = '期权价格对r的函数图';

% sigma数据的长度
sigmaL = length( copy.sigma );

if sigmaL == 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, datestr(copy.currentDate));
else
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K , datestr(copy.currentDate));
end


title(txt)

% 将原先的点加上去
copy.r = pricer.r;
copy.calcPx();
hold on
plot( copy.r, copy.px , 'ro' , ...
    'MarkerFaceColor' , 'r' )


end

