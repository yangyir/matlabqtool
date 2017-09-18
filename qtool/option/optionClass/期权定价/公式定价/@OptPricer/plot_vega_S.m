function [ hfig ] = plot_vega_S( pricer )
%PLOT_VEGA_S ��vega~S��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%
pricer.S = 1.8:0.05:2.7;
pricer.calcVega();

hfig = figure;
plot( pricer.S, pricer.vega);
legend('vega');
%%%%%%%%%%%%%%����������������
xlabel('S')
ylabel('vega')
%%%%%%%%%%%%%%%%%%%%%%%
grid on;
txt = 'vega';
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
