function [ hfig ] = plot_delta_K( pricer , K )
%PLOT_DELTA_K ��delta~K��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% ���Ʒ壬20160301��ʹ��Copy�Ľ��������ͼ
% ���Ʒ壬20160316�����ոո��centerȡ��ķ������м����hFig������жϷ���

%% Ԥ����
% TODO: ���Ԥ����

% ��copy��������о�
copy = pricer.getCopy();

%% ��ͼ

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcDelta();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.delta , 'b-' );
legend('delta');

xlabel('K')
ylabel('delta')

grid on;
txt = '��Ȩdelta��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100,...
    datestr( copy.currentDate ) );

hold on

% �������ĵĵ�
copy.K = center;
copy.calcDelta();
plot( copy.K, copy.delta , 'r*' ,...
    'MarkerSize' , 10 );

title( txt )

hold off

end

