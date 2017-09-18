function [ hfig ] = plot_delta_tau_mix( pricer )
%PLOT_DELTA_TAU ��delta~tau��ͼ
% ---------------------
% ��ܣ�20160124

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%% ��ͼ����

K = [1.8,2.3,2.7];

colorheader = 'rgb';
hfig = figure;
hold on

for i = 1 : 3
    pricer.K = K(i);
    pricer.tau = 0.01:0.02:0.5;
    pricer.calcDelta();
    plot( pricer.tau, pricer.delta,colorheader(i));
end

switch  pricer.CP
    case {'C', 'c', 'Call', 'call', 'CALL' }
        
        legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��')
    case {'P', 'p', 'put', 'Put', 'PUT'}
        legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��')
        
end
    
%%%%%%%%%%%%%%����������������
xlabel('\tau')
ylabel('delta')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩdelta��\tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

