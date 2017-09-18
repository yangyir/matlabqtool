function [ hfig ] = plot_delta_tau_mix( pricer , tau )
%PLOT_DELTA_TAU ��delta~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160301��ʹ��Copy�Ľ��������ͼ
% ���Ʒ壬20160316�����ոո��centerȡ��ķ������м����hFig������жϷ���

%% Ԥ����
% TODO: ���Ԥ����

% ��copy��������о�
copy = pricer.getCopy();

%% ��ͼ����

% ����tauĬ��ֵ
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau     =   0.05 * [1:20] * longend ;
end

K = [1.8,2.3,2.7];
copy.tau = tau;

colorheader = 'rgb';
if nargout > 0
    hfig = figure;
end
hold on

for i = 1 : 3
    copy.K = K(i);
    copy.calcDelta();
    plot( copy.tau, copy.delta , colorheader(i) );
end

switch  copy.CP
    case {'C', 'c', 'Call', 'call', 'CALL' }
        legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��' , 'Location' , 'best')
    case {'P', 'p', 'put', 'Put', 'PUT'}
        legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��' , 'Location' , 'best')
end

xlabel('\tau')
ylabel('delta')

grid on;
txt = '��Ȩdelta��\tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100,...
    datestr(copy.currentDate) );

pricer.calcDelta();
hold on
plot( pricer.tau , pricer.delta , 'mo' ,...
    'MarkerFaceColor' , 'm')

title(txt)

end

