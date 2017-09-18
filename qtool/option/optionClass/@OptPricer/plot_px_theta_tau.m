function [ hfig ] = plot_px_theta_tau( pricer )
%PLOT_DELTA_S ��delta~S��ͼ
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


copy.tau = tau;
copy.calcPx();
copy.calcTheta();

hfig = figure;

%% px ~ tau
subplot(211)
plot( copy.tau, copy.px);
grid on
txt = '��Ȩ�۸��\tau�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );

title(txt)
xlabel('\tau')
legend('px')

% �ӻ���ǰ��
hold on 
pricer.calcPx();
plot( pricer.tau, pricer.px, 'or');


%% theta ~ tau
subplot(212)
txt = 'theta��\tau�ĺ���ͼ';
plot( copy.tau, copy.theta);
grid on

% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%', txt, ...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );
% title(txt)
xlabel('\tau')
legend('theta')

% �ӻ���ǰ��
hold on 
pricer.calcTheta();
plot( pricer.tau, pricer.theta, 'or');

end

