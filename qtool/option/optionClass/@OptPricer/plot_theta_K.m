function [ hfig ] = plot_theta_K( pricer , K )
%PLOT_THETA_K ��theta~K��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K      = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcTheta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.theta );
legend('theta');

xlabel('K')
ylabel('theta')

grid on;
txt = '��Ȩtheta��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100, ...
    datestr(copy.currentDate));

title(txt)

hold on
% ��ԭ��������
copy.K = center;
copy.calcTheta();
plot( copy.K, copy.theta , 'r*' ,...
    'MarkerSize' , 10 );



end

