function [ hfig ] = plot_delta_tau( pricer , tau )
%PLOT_DELTA_TAU 画delta~tau的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% 吴云峰，20160301，使用Copy的结果进行作图
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO: 相关预处理

% 在copy上面进行研究
copy = pricer.getCopy();

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

%% 作图
% 用copy进行计算
copy.tau = tau;
delta    = copy.calcDelta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( tau, delta );

xlabel('\tau');
ylabel('delta');

grid on;
txt = '期权delta对\tau的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));

txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt);

% 加画当前点
hold on
pricer.calcDelta();
plot( pricer.tau, pricer.delta, 'or');


end

