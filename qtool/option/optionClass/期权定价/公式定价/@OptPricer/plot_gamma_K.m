function [ hfig ] = plot_gamma_K( pricer )
%PLOT_GAMMA_K ��gamma~K��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%% ��ͼ

pricer.K = 1.7:0.02:2.7;
pricer.calcGamma();
hfig = figure;

plot( pricer.K, pricer.gamma);
legend('gamma');

%%%%%%%%%%%%%%����������������
xlabel('K')
ylabel('gamma')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩgamma��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

