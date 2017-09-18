function [ hfig ] = plot_vega_tau( pricer , tau )
%PLOT_VEGA_TAU 画vega~tau的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg, 20160302，使只画一张图
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% 将旧的变量进行保存
copy = pricer.getCopy();

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

%% 作图
% 用copy进行计算
copy.tau = tau;
copy.calcVega();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( copy.tau, copy.vega);


xlabel('\tau')
ylabel('vega')

grid on;
txt = '期权vega对\sim tau的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% 加画当前点
hold on
pricer.calcVega()
plot( pricer.tau, pricer.vega, 'or');



end

