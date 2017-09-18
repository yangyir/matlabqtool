function [ hfig ] = plot_px_vega_sigma( pricer , sigma )
%PLOT_PX_VEGA_SIGMA 画px_vega~sigma的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


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
    sigma =[0:19] * (mx-mn)/20 + mn;
end
%% 作图


copy.sigma = sigma;
copy.calcPx();
copy.calcVega();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

%% px~sigma
subplot(211)
plot( copy.sigma, copy.px);
grid on
txt = '期权价格对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, ...
    datestr(copy.currentDate));
title(txt)
xlabel('sigma')
ylabel('px')

% 加画当前点
hold on
pricer.calcPx();
plot( pricer.sigma, pricer.px, 'or');


%% vega~sigma
subplot(212)
plot( copy.sigma, copy.vega );
grid on
txt = 'vega对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, ...
    datestr(copy.currentDate));
title(txt)
xlabel('sigma')
ylabel('vega')

% 加画当前点
hold on
pricer.calcVega();
plot( pricer.sigma, pricer.vega, 'or');
end

