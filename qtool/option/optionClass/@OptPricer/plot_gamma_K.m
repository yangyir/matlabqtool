function [ hfig ] = plot_gamma_K( pricer , K )
%PLOT_GAMMA_K ��gamma~K��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% ���Ʒ壬20160316�����ոո��centerȡ��ķ������м����hFig������жϷ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K = leftK:0.02:rightK;
end;

copy.K = K;
copy.calcGamma();

if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.gamma , 'b-' );
legend('gamma');

xlabel('K')
ylabel('gamma')

grid on;
txt = '��Ȩgamma��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100, ...
    datestr(copy.currentDate) );

title(txt)

% �������ĵĵ�
copy.K = center;
copy.calcGamma();
hold on
plot( copy.K, copy.gamma , 'r*' ,...
    'MarkerSize' , 10 );


end

