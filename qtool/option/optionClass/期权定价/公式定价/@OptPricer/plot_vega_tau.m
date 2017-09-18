function [ hfig ] = plot_vega_tau( pricer )
%PLOT_VEGA_TAU ��vega~tau��ͼ
% ---------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO: ���Ԥ����

% ���ɵı������б���
original = pricer.getCopy();

%%

S = [1.8,2.3,2.7];
colorheader = 'rgb';
hfig = figure;
hold on

for i = 1:3
    pricer.S = S(i);
    pricer.tau = 0.01:0.02:0.5;
    pricer.calcVega();
    plot( pricer.tau, pricer.vega,colorheader(i));
end

switch  pricer.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��')
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��')
                    
end    

xlabel('\sim tau')
ylabel('vega')

grid on;
txt = '��Ȩvega��\sim tau�ĺ���ͼ';
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

