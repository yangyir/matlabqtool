function [ hfig ] = plot_optprice_tau( pricer )
%PLOT_OPTPRICE_tau ����Ȩ�۸��tau��ͼ
% ----------------------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���
% cg��20160302���޸���Ĭ�Ϻ����ֵ�� �ӻ���ǰ�㣬�Ըı���


%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
copy = pricer.getCopy();

% ����tauĬ��ֵ
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

%% ��ͼ����px~tau��ͼ
% ����
copy.tau = tau;
px = copy.calcPx();

% ����handlefig��������¿�figure�����򣬻��ں������figure��
if nargout > 0
    hfig = figure;
end

% ��copy������ͼ
plot( tau, px );
xlabel('\tau')
ylabel('px')

grid on
txt = '��Ȩ�۸�� \tau �ĺ���ͼ';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%% ', txt, ...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );

txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);

title(txt)


% �ӻ���ǰ��
hold on 
pricer.calcPx();
plot( pricer.tau, pricer.px, 'or');


end

