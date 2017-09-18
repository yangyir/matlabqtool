function [ hfig ] = plot_px_delta_gamma_S( pricer , S )
%PLOT_PX_DELTA_GAMMA_S 画px_delta_gamma~S的图
% ---------------------
% 程刚，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

% 横轴S默认值域
if ~exist( 'S' , 'var' )
    center = pricer.S;
    try
        wrong =  center == 0 || isempty(center) || isnan(center);
        if wrong,  center = pricer.K; end    
    catch e
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

%% 计算

copy.S = S;

copy.calcPx();
copy.calcDelta();
copy.calcGamma();

hfig = figure;

%% 作图：px~S
subplot(311)
plot( copy.S, copy.px);
grid on
txt = '期权价格对S的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100,...
    datestr(copy.currentDate));
title(txt)
xlabel('S')
legend('px')

% 加画当前点
hold on
pricer.calcPx();
plot( pricer.S, pricer.px, 'or');

%% 作图：delta~S
subplot(312)
plot( copy.S, copy.delta);
grid on
xlabel('S')
legend('delta');

% 加画当前点
hold on
pricer.calcDelta();
plot( pricer.S, pricer.delta, 'or');


%% 作图：gamma~S
subplot(313)
plot( copy.S, copy.gamma );
legend('gamma');
grid on

% 加画当前点
hold on
pricer.calcGamma();
plot( pricer.S, pricer.gamma, 'or');

end

