function [ hfig ] = plot_rho_tau( pricer , tau )
%PLOT_RHO_TAU ��rho~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���


%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

% ����tauĬ��ֵ
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

%% ��ͼ
% ��copy���м���
copy.tau = tau;
rho    = copy.calcRho();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( copy.tau, copy.rho);

xlabel('\tau')
ylabel('rho')

grid on;
txt = '��Ȩrho��\tau�ĺ���ͼ';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% �ӻ���ǰ��
hold on 
pricer.calcRho();
plot( pricer.tau, pricer.rho, 'or');


end
