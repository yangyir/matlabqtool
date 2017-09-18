function [ hfig ] = plot_optprice_tau( obj  )
%PLOT_OPTPRICE_tau ����Ȩ�۸��tau��ͼ
% ----------------------------------
% ��ܣ�20160124
% ���Ʒ壬20160129�������˲��ı�ԭ��ֵ�ķ���

%% Ԥ����
% TODO�������������Ƿ���ֵ 

% ���ɵı������б���
original = obj.getCopy();

%% ��ͼ����px~tau��ͼ
T = obj.T;
currentDate = T-20:T-1;
obj.currentDate = currentDate;
px = obj.calcPx();
tau = obj.tau;

hfig = figure;
plot(tau, px);
xlabel('\tau')
ylabel('px')
grid on
txt = '��Ȩ�۸�� \tau �ĺ���ͼ';
txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%% ', txt, ...
    obj.CP,datestr( obj.T ), obj.K, obj.sigma*100 );
title(txt);

%% ���ԭ�ȵı���ԭ�ⲻ���ķ���

name = fieldnames( original );

for i  = 1:length( name )
    str = [ 'obj.',name{i},'=','original.',name{i},';' ];
    eval( str );
end


end

