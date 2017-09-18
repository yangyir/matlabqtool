function [ hfig ] = plot_px_vega_sigma( pricer , sigma )
%PLOT_PX_VEGA_SIGMA ��px_vega~sigma��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���


%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();


% ����sigmaĬ��ֵ��
if ~exist( 'sigma' , 'var' )
    center = pricer.sigma;
    if isnan(center), center = 0.3; end
    if isempty(center), center = 0.3; end
    if center <= 0,  center = 0.3; end
    mn = min( [ center * 0.5, 0.1]);
    mx = max( [ center * 1.5, 0.6] ); 
    sigma =[0:19] * (mx-mn)/20 + mn;
end
%% ��ͼ


copy.sigma = sigma;
copy.calcPx();
copy.calcVega();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

%% px~sigma
subplot(211)
plot( copy.sigma, copy.px);
grid on
txt = '��Ȩ�۸��sigma�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, ...
    datestr(copy.currentDate));
title(txt)
xlabel('sigma')
ylabel('px')

% �ӻ���ǰ��
hold on
pricer.calcPx();
plot( pricer.sigma, pricer.px, 'or');


%% vega~sigma
subplot(212)
plot( copy.sigma, copy.vega );
grid on
txt = 'vega��sigma�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, ...
    datestr(copy.currentDate));
title(txt)
xlabel('sigma')
ylabel('vega')

% �ӻ���ǰ��
hold on
pricer.calcVega();
plot( pricer.sigma, pricer.vega, 'or');
end

