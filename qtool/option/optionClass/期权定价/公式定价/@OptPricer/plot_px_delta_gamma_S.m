function [ hfig ] = plot_px_delta_gamma_S( pricer )
%PLOT_PX_DELTA_GAMMA_S ��px_delta_gamma~S��ͼ
% ---------------------
% �̸գ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;

pricer.calcPx();
pricer.calcDelta();
pricer.calcGamma();

hfig = figure;

% px~S
subplot(311)
plot( pricer.S, pricer.px);
grid on
txt = '��Ȩ�۸��S�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)
xlabel('S')
ylabel('px')

% delta~S
subplot(312)
plot( pricer.S, pricer.delta);
grid on
xlabel('S')
ylabel('delta')
txt = 'Delta��S�ĺ���ͼ';

title(txt)

% gamma~S
subplot(313)
plot( pricer.S, pricer.gamma);
grid on
txt = 'Gamma��S�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end

end

