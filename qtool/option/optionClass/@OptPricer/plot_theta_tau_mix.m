function [ hfig ] = plot_theta_tau_mix( pricer , tau )
%PLOT_THETA_TAU_MIX ��theta_tau~ITM,ATM,OTM��ͼ
% ---------------------
% ��ܣ�20160124

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ

% ����tauĬ��ֵ
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
          legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��' , 'Location' , 'best' )
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��' , 'Location' , 'best' )         
end    
    
xlabel('\sim tau')
ylabel('theta')

grid on;
txt = '��Ȩtheta��\sim tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));

title( txt )

% ��ԭ��������
hold on

copy.tau = pricer.tau;
copy.K   = pricer.K;
copy.calcTheta();
plot( copy.tau, copy.theta ,'mo' , ...
    'MarkerFaceColor' , 'm');



end

