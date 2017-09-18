function [ hfig ] = plot_px_theta_tau( pricer )
%PLOT_DELTA_S 画delta~S的图
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


copy.tau = tau;
copy.calcPx();
copy.calcTheta();

hfig = figure;

%% px ~ tau
subplot(211)
plot( copy.tau, copy.px);
grid on
txt = '期权价格对\tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );

title(txt)
xlabel('\tau')
legend('px')

% 加画当前点
hold on 
pricer.calcPx();
plot( pricer.tau, pricer.px, 'or');


%% theta ~ tau
subplot(212)
txt = 'theta对\tau的函数图';
plot( copy.tau, copy.theta);
grid on

% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );
% title(txt)
xlabel('\tau')
legend('theta')

% 加画当前点
hold on 
pricer.calcTheta();
plot( pricer.tau, pricer.theta, 'or');

end

