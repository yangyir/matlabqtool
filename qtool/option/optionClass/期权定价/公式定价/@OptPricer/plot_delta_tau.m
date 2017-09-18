function [ hfig ] = plot_delta_tau( pricer )
%PLOT_DELTA_TAU ��delta~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���


%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%% ��ͼ

tau = 0.01:0.02:0.5;
delta = zeros( 1 , length( tau ) );
for i = 1 : length(tau)
    pricer.tau = tau(i);
    pricer.calcDelta();
    delta(i) = pricer.delta;
end

hfig = figure;

plot( tau, delta);

xlabel('\tau')
ylabel('delta')

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

