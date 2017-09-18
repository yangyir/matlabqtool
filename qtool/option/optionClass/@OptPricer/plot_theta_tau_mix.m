function [ hfig ] = plot_theta_tau_mix( pricer , tau )
%PLOT_THETA_TAU_MIX 画theta_tau~ITM,ATM,OTM的图
% ---------------------
% 沈杰，20160124

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 作图

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

copy.tau = tau;

K = [1.8,2.3,2.7];
colorheader = 'rgb';
if nargout > 0
    hfig = figure;
end

hold on

for i = 1:3
    copy.K = K(i);
    copy.calcTheta();
    plot( copy.tau, copy.theta,colorheader(i));
end

switch  copy.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('虚值（OTM）','平值（ATM）','实值（ITM）' , 'Location' , 'best' )
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('实值（ITM）','平值（ATM）','虚值（OTM）' , 'Location' , 'best' )         
end    
    
xlabel('\sim tau')
ylabel('theta')

grid on;
txt = '期权theta对\sim tau的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));

title( txt )

% 将原点做出来
hold on

copy.tau = pricer.tau;
copy.K   = pricer.K;
copy.calcTheta();
plot( copy.tau, copy.theta ,'mo' , ...
    'MarkerFaceColor' , 'm');



end

