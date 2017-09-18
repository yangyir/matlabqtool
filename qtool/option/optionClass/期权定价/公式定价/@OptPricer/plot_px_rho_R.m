function [ hfig ] = plot_px_rho_R( pricer )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%% ��ͼ

pricer.r = 0.005:0.005:0.095;

pricer.calcPx();
pricer.calcRho();

hfig = figure;
% px~R
subplot(211)
plot( pricer.r, pricer.px);
grid on
txt = '��Ȩ�۸��R�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('R')
ylabel('px')

% rho~R
subplot(212)
plot( pricer.r, pricer.rho );
grid on
txt = 'Rho��R�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('R')
ylabel('Rho')

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

