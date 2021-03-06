function [ hfig ] = plot_delta_sigma( pricer , sigma )
%PLOT_DELTA_sigma 画delta~sigma的图
% ---------------------
% cg，20160302


%% 预处理
% 在copy上面进行研究
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
delta    = copy.calcDelta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( sigma, delta);

xlabel('\sigma');
ylabel('delta');

grid on;
txt = '期权delta对\sigma的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));

txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt);



% 加画当前点
hold on
pricer.calcDelta();
plot( pricer.sigma, pricer.delta, 'or');


end

