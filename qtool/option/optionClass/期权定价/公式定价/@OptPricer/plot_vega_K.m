function [ hfig ] = plot_vega_K( pricer )
%PLOT_VEGA_K ��vega~K��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%

pricer.K = 1.7:0.02:2.7;
pricer.calcVega();
hfig = figure;

plot( pricer.K, pricer.vega);
legend('vega');

%%%%%%%%%%%%%%����������������
xlabel('K')
ylabel('vega')
%%%%%%%%%%%%%%%%%%%%%%%

grid on;
txt = '��Ȩvega��K�ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    pricer.CP,datestr( pricer.T ), pricer.sigma*100, datestr(pricer.currentDate));

title(txt)

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'pricer.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

