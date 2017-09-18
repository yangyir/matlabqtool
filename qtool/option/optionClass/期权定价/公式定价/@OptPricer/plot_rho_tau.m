function [ hfig ] = plot_rho_tau( pricer )
%PLOT_RHO_TAU ��rho~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%

hfig = figure;

pricer.tau = 0.01:0.02:0.5;
pricer.calcRho();

plot( pricer.tau, pricer.rho);

%%%%%%%%%%%%%%����������������
xlabel('\tau')
ylabel('rho')
%%%%%%%%%%%%%%%%%%%%%%%   
    

grid on;
txt = '��Ȩrho��\tau�ĺ���ͼ';
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

