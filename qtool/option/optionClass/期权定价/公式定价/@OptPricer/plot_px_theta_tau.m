function [ hfig ] = plot_px_theta_tau( pricer )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%

T = pricer.T;
currentDate = T-20:T-1;
pricer.currentDate = currentDate;
% �����������Լ���tau��ֵ
% pricer.tau = 0.01:0.008:0.155;
pricer.calcPx();
pricer.calcTheta();

hfig = figure;
% px~S
subplot(211)
plot( pricer.tau, pricer.px);
grid on
txt = '��Ȩ�۸��\tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100 );
title(txt)
xlabel('\tau')
ylabel('px')

% delta~S
subplot(212)
txt = 'theta��\tau�ĺ���ͼ';
plot( pricer.tau, pricer.theta);
grid on
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100 );
title(txt)
xlabel('\tau')
ylabel('theta')

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

