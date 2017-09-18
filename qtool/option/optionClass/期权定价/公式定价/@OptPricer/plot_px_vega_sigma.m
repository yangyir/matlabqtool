function [ hfig ] = plot_px_vega_sigma( pricer )
%PLOT_PX_VEGA_SIGMA ��px_vega~sigma��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%
pricer.sigma = 0.10:0.05:1;
pricer.calcPx();
pricer.calcVega();


hfig = figure;
% px~sigma
subplot(211)
plot( pricer.sigma, pricer.px);
grid on
txt = '��Ȩ�۸��sigma�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, datestr(pricer.currentDate));
title(txt)
xlabel('sigma')
ylabel('px')

% vega~sigma
subplot(212)
plot( pricer.sigma, pricer.vega);
grid on
txt = 'vega��sigma�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, datestr(pricer.currentDate));
title(txt)
xlabel('sigma')
ylabel('vega')

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

