function [ hfig ] = plot_rho_tau( pricer , tau )
%PLOT_RHO_TAU 画rho~tau的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO: 相关预处理

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
rho    = copy.calcRho();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( copy.tau, copy.rho);

xlabel('\tau')
ylabel('rho')

grid on;
txt = '期权rho对\tau的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% 加画当前点
hold on 
pricer.calcRho();
plot( pricer.tau, pricer.rho, 'or');


end

