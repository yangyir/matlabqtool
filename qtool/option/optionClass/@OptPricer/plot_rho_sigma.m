function [ hfig ] = plot_rho_sigma( pricer , sigma )
%PLOT_RHO_sigma 画rho~sigma的图
% ---------------------
% cg，20160302

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

% 横轴sigma默认值域
if ~exist( 'sigma' , 'var' )
    center = pricer.sigma;
    if isnan(center), center = 0.3; end
    if isempty(center), center = 0.3; end
    if center <= 0,  center = 0.3; end
    mn = min( [ center * 0.5, 0.1]);
    mx = max( [ center * 1.5, 0.6] ); 
    sigma =[0:20] * (mx-mn)/20 + mn;
end
%% 作图
% 用copy进行计算
copy.sigma = sigma;
rho    = copy.calcRho();


% 有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( copy.sigma, copy.rho);

xlabel('\sigma')
legend('rho')

grid on;
txt = '期权rho对\sigma的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% 加画当前点
hold on 
pricer.calcRho();
plot( pricer.sigma, pricer.rho, 'or');

end

