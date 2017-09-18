function [ hfig ] = plot_rho_tau_mix( pricer , tau )
%PLOT_RHO_TAU ��rho~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160215

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

S = [1.8,2.3,2.7];
colorheader = 'rgb';
hfig = figure;
hold on

for i = 1:3
    copy.S = S(i);
    copy.calcRho();
    plot( copy.tau, copy.rho,colorheader(i));
end

switch  copy.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��', 'Location' , 'best')
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��', 'Location' , 'best')           
end

xlabel('\sim tau')
ylabel('vega')

grid on;
txt = '��Ȩrho��\sim tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));

title(txt)

% ��ԭ��������
hold on

copy.tau = pricer.tau;
copy.S   = pricer.S;
copy.calcRho();
plot( copy.tau, copy.rho,'mo' , ...
    'MarkerFaceColor' , 'm');


end

