function [ hfig ] = plot_vega_sigma( pricer , sigma )
%PLOT_VEGA_sigma ��vega~sigma��ͼ
% ---------------------
% cg��20160302


%% Ԥ����
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
    sigma =[0:20] * (mx-mn)/20 + mn;
end

%% ��ͼ
% ��copy���м���
copy.sigma = sigma;
copy.calcVega();

% ��handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( copy.sigma, copy.vega);


xlabel('\sigma')
ylabel('vega')

grid on;
txt = '��Ȩvega��\sim sigma�ĺ���ͼ';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));
txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% �ӻ���ǰ��
hold on
pricer.calcVega()
plot( pricer.sigma, pricer.vega, 'or');



end

