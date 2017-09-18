function [ hfig ] = plot_gamma_tau_mix( pricer )
%PLOT_GAMMA_TAU ��gamma~tau��ͼ
% ����״̬��һ���
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
    pricer.calcGamma();
    plot( pricer.tau, pricer.gamma,colorheader(i));
end

switch  pricer.CP
      case {'C', 'c', 'Call', 'call', 'CALL' }
          legend('��ֵ��OTM��','ƽֵ��ATM��','ʵֵ��ITM��')
      case {'P', 'p', 'put', 'Put', 'PUT'}
          legend('ʵֵ��ITM��','ƽֵ��ATM��','��ֵ��OTM��')
                    
end    

xlabel('tau')
ylabel('gamma')

grid on;
txt = '��Ȩgamma��tau�ĺ���ͼ';
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

