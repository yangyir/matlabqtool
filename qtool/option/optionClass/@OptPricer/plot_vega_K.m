function [ hfig ] = plot_vega_K( pricer , K )
%PLOT_VEGA_K ��vega~K��ͼ
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
    K = leftK:0.02:rightK;
end;

copy.K = K;

copy.calcVega();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.vega);
legend('vega');

xlabel('K')
ylabel('vega')

grid on;
txt = '��Ȩvega��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100,...
    datestr(copy.currentDate));

title(txt)

hold on

% �������ĵĵ�
copy.K = center;
copy.calcVega();
plot( copy.K, copy.vega , 'r*' ,...
    'MarkerSize' , 10 );


end

