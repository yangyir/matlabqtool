function [ hfig ] = plot_gamma_tau( pricer )
%PLOT_GAMMA_TAU ��gamma~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%

tau = 0.01:0.02:0.5;
% ���gamma����
gamma = zeros( 1 , length( tau ) ); 
for i = 1 : length(tau)
    pricer.tau = tau(i);
    pricer.calcGamma();
    gamma(i) = pricer.gamma;
end

hfig = figure;
plot( tau, gamma);

%%%%%%%%%%%%%%����������������
xlabel('\tau')
ylabel('gamma')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩgamma��\tau�ĺ���ͼ';
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

