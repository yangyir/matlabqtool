function [ hfig ] = plot_px_rho_r( pricer , r )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
copy = pricer.getCopy();

%% ��ͼ

if ~exist( 'r' , 'var' )
    r = 0.005:0.005:0.095;
end

copy.r = r;
copy.calcPx();
copy.calcRho();

% ����ԭ�еĽ��
pricer.calcPx();
pricer.calcRho();

hfig = figure;

% ��copy������ͼ
% px~R
subplot(211)
plot( copy.r, copy.px );
grid on
txt = '��Ȩ�۸��R�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));
title(txt)
xlabel('R')
ylabel('px')
% ����ԭ�еĵ��ͼ
hold on
plot( pricer.r, pricer.px , 'ro' , ... 
    'MarkerFaceColor' , 'r' )

% rho~R
subplot(212)
plot( copy.r, copy.rho );
grid on
txt = 'Rho��R�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
    datestr(copy.currentDate));
title(txt)
xlabel('R')
ylabel('Rho')
% ����ԭ�еĵ��ͼ
hold on
plot( pricer.r, pricer.rho , 'ro' , ... 
    'MarkerFaceColor' , 'r' )


end

