function [ hfig ] = plot_gamma_tau_mix( pricer , tau )
%PLOT_GAMMA_TAU ��gamma~tau��ͼ
% ����״̬��һ���
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% ���Ʒ壬20160301��ʹ��Copy�Ľ��������ͼ
% ���Ʒ壬20160316�����ոո��centerȡ��ķ������м����hFig������жϷ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ

% ����tauĬ��ֵ
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau     =   0.05 * [1:20] * longend ;
end

copy.tau = tau;

S = [1.8,2.3,2.7];
colorheader = 'rgb';
if nargout > 0
    hfig = figure;
end
hold on

for i = 1:3
    copy.S = S(i);
    copy.calcGamma();
    plot( copy.tau, copy.gamma,colorheader(i));
end

switch  copy.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��' , 'Location' , 'best' )
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��' , 'Location' , 'best' )          
end    

xlabel('tau')
ylabel('gamma')

grid on;
txt = '��Ȩgamma��tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));

title(txt)

pricer.calcGamma();
hold on
plot( pricer.tau , pricer.gamma , 'mo' ,...
    'MarkerFaceColor' , 'm')


end

