function [ hfig ] = plot_delta_S( pricer )
%PLOT_DELTA_S ��delta~S��ͼ
% ---------------------
% �̸գ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���


%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;
pricer.calcDelta();

hfig = figure;
plot( pricer.S, pricer.delta);
legend('delta');
%%%%%%%%%%%%%%����������������
xlabel('S')
ylabel('delta')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = '��Ȩdelta��S�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.K, pricer.sigma*100, datestr(pricer.currentDate));
title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

